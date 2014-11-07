require 'spec_helper'

module Itds
  describe Client do

    it "able to set login timeout" do
      timeout = 2
      t = Thread.new do
        Client.new(
          {
            host:     localhost,
            timeout:  timeout,
          }
        )
      end

      sleep(timeout + 2)
      expect(t.alive?).to eq(false)
    end
  end
end
