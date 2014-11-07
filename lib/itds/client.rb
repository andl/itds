require "forwardable"
require "tiny_tds"

# simple TinyTDS client wrapper
module Itds
  class Client
    extend Forwardable
    def_delegators :@backend, :close

    DEFAULT_OPTS = {
      port:     1433,
      username: 'sa',
      timeout:  5,
    }

    # The default connection settings according to:
    # http://stackoverflow.com/questions/9235527/incorrect-set-options-error-when-building-database-project
    DEFAULT_CONN_SETTINGS = {
      'ANSI_NULLS' => 'ON',
      'ANSI_PADDING' => 'ON',
      'ANSI_WARNINGS' => 'ON',
      'ARITHABORT' => 'ON',
      'CONCAT_NULL_YIELDS_NULL' => 'ON',
      'NUMERIC_ROUNDABORT' => 'OFF',
      'QUOTED_IDENTIFIER' => 'ON'
    }

    def initialize(opts={})
      opts = DEFAULT_OPTS.merge(opts)
      opts[:azure] = true if(opts[:database])
      opts[:login_timeout] = opts[:timeout]

      @backend = new_backend(opts)
      init_env
      @backend
    end

    def new_backend(opts)
      TinyTds::Client.new(opts)
    end

    def init_env
      DEFAULT_CONN_SETTINGS.each do |k,v|
        @backend.execute("SET #{k} #{v}")
      end
    end

    def execute(sql)
      res = @backend.execute(sql)
      res
    end
  end
end
