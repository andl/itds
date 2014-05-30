require "optparse"
require 'terminal-table'
require 'readline'

module Itds
  class Repl
    class << self
      def config(options)
        @options = options
        @client = Client.new(options)
        self
      end

      def run
        while cmd = Readline.readline(prompt, true)
          execute_cmd(cmd)
        end
      end

      def prompt
        @prompt ||= "#{@options[:database]}> "
      end

      def execute_cmd(cmd)
        begin
          stop if cmd == "exit"
          res = @client.execute(cmd)
          print_result(res)
        rescue => e
          print_err(e)
        end
      end

      def print_result(res)
        fields = res.fields
        rows = []
        res.each do |rowset|
          rows << rowset.values
        end

        t = Terminal::Table.new :headings => fields, :rows => rows
        puts t
      end

      def print_err(err)
        puts "Error: #{err.message}"
      end

      def stop
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

        opts.on("-p", "--port [PORT]", Integer, "port number, default is 1433") do |p|
          options[:port] = p
        end

        opts.on("-u", "--user [USER]", "username") do |u|
          options[:username] = u
        end

        opts.on("-d", "--database [DATABASE]", "database name") do |d|
          options[:database] = d
        end

        opts.on("-P", "--password [PASSWORD]", "optional password") do |p|
          options[:password] = p
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
      if args.empty?
        trap("INT") { exit }
        Repl.run
      else
        Repl.execute_cmd(args.join(" "))
      end
    end
  end
end
