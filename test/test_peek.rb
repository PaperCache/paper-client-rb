require "minitest/autorun"
require "paper_client"
require "global"

class PeekTest < UnitTest
	def test_exists
		client = init_client

		client.set("key", "value")
		assert_equal client.peek("key"), "value"
	end

	def test_not_exists
		client = init_client

		assert_raises PaperClient::KeyNotFoundError do
			client.peek("key")
		end
	end
end
