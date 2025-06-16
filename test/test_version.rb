require "minitest/autorun"
require "paper_client"

class VersionTest < Minitest::Test
	def test_ping
		client = PaperClient.new("paper://127.0.0.1:3145")
		assert client.version().length > 0
	end
end
