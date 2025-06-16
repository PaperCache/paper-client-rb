require "minitest/autorun"
require "paper_client"
require "global"

class SizeTest < UnitTest
	def test_exists
		client = init_client

		client.set("key", "value")
		assert client.size("key") > 0
	end

	def test_not_exists
		client = init_client

		assert_raises PaperClient::KeyNotFoundError do
			client.size("key")
		end
	end
end
