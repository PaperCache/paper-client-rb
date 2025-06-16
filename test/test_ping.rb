require "minitest/autorun"
require "paper_client"

class PingTest < Minitest::Test
	def test_ping
		client = PaperClient.new("paper://127.0.0.1:3145")
		assert_equal client.ping(), "pong"
	end
end
