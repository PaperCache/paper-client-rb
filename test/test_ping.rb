require "minitest/autorun"
require "paper_client"
require "global"

class PingTest < UnitTest
	def test_ping
		client = init_client
		assert_equal client.ping, "pong"
	end
end
