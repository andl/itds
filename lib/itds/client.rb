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

    def initialize(opts={})
      opts = DEFAULT_OPTS.merge(opts)
      opts[:azure] = true if(opts[:database])
      opts[:login_timeout] = opts[:timeout]

      @backend = new_backend(opts)
    end

    def new_backend(opts)
      TinyTds::Client.new(opts)
    end

    def execute(sql)
      res = @backend.execute(sql)
      res
    end
  end
end
