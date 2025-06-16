require "minitest/autorun"
require "paper_client"
require "global"

class GetTest < UnitTest
	def test_exists
		client = init_client

		client.set("key", "value")
		client.ttl("key", 5)
	end

	def test_not_exists
		client = init_client

		assert_raises PaperClient::KeyNotFoundError do
			client.ttl("key", 5)
		end
	end
end
