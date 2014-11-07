require "optparse"
require 'terminal-table'
require 'readline'

module Itds
  class Repl
    class << self
      def config(options)
        @options = options
        @client = Client.new(options)
      end

      def run
        print_help

        while cmd = Readline.readline(prompt, true)
          execute_cmd(cmd)
        end
      end

      def print_help
        msg = <<-EOT
itds SQL server interactive console.
Press Ctrl-C to cancel current query, press again to quit.
EOT
        puts msg
      end

      def prompt
        @prompt ||= "#{@options[:database]}> "
      end

      def execute_cmd(cmd)
        begin
          stop if cmd == "exit"
          @res = @client.execute(cmd)
          print_result(@res)
        rescue => e
          print_err(e)
        ensure
          cancel_request
        end
      end

      def cancel_request
        if @res
          @res.cancel
          @res = nil
        end
      end

      def print_result(res)
        fields = res.fields
        rows = []
        res.each do |rowset|
          rows << rowset.values
        end

        output = {}
        output[:headings] = fields unless fields.empty?
        output[:rows] = rows unless rows.empty?

        unless output.empty?
          puts Terminal::Table.new output
        end

        print_affected_row(res)
      end

      def print_affected_row(res)
        # tiny_tds seems not only return affected_rows for update/delete
        # but also select.
        affected = res.affected_rows

        if affected > 0
          puts ""
          puts "Affected Rows: #{affected}"
        end
      end

      def print_err(err)
        puts "Error: #{err.message}"
      end

      def singal
        if @res
          cancel_request
        else
          stop
        end
      end

      def stop
        @client.close
        exit
      end
    end
  end


  class ReplRunner
    def self.run(args=[])
      options = {}
      mandatory = [:host]

      opts_parser = OptionParser.new do |opts|
        opts.banner = "Usage: itds [options] [sql]"

        opts.on("-h", "--host HOST", "host or ip") do |h|
          options[:host] = h
        end

        opts.on("-P", "--port [PORT]", Integer, "port number, default is 1433") do |p|
          options[:port] = p
        end

        opts.on("-u", "--user [USER]", "username") do |u|
          options[:username] = u
        end

        opts.on("-d", "--database [DATABASE]", "database name") do |d|
          options[:database] = d
        end

        opts.on("-p", "--password [PASSWORD]", "optional password") do |p|
          options[:password] = p
        end

        opts.on("--timeout [TIMEOUT]", "connect and query timeout, 5 secs by default") do |t|
          options[:timeout] = t.to_i
        end

        opts.on_tail("--help", "show this help message") do
          puts opts
          exit
        end

        opts.on_tail("--version", "show version") do
          puts Itds::VERSION
          exit
        end
      end

      if args.empty?
        puts opts_parser.help
        exit
      end

      opts_parser.parse!(args)
      missing = mandatory.select {|p| options[p].nil? }
      unless missing.empty?
        puts "Missing mandatory options: #{missing.join(', ')}"
        exit
      end

      Repl.config(options)
      if args.empty? #interactive
        trap("INT") { Repl.singal }
        Repl.run
      else
        Repl.execute_cmd(args.join(" "))
      end
    end
  end
end
