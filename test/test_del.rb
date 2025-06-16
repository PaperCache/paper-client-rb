require "minitest/autorun"
require "paper_client"
require "global"

class DetTest < UnitTest
	def test_exists
		client = init_client

		client.set("key", "value")
		client.del("key")
	end

	def test_not_exists
		client = init_client

		assert_raises PaperClient::KeyNotFoundError do
			client.del("key")
		end
	end
end
