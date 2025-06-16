require "minitest/autorun"
require "paper_client"
require "global"

class GetTest < UnitTest
	def test_exists
		client = init_client

		client.set("key", "value")
		assert_equal client.get("key"), "value"
	end

	def test_not_exists
		client = init_client

		assert_raises PaperClient::KeyNotFoundError do
			client.get("key")
		end
	end
end
