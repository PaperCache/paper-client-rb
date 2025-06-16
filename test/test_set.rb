require "minitest/autorun"
require "paper_client"
require "global"

class SetTest < UnitTest
	def test_no_ttl
		client = init_client
		client.set("key", "value")
	end

	def test_ttl
		client = init_client
		client.set("key", "value", 3)
	end

	def test_ttl_timeout
		client = init_client
		client.set("key", "value", 1)

		sleep 2

		assert_raises PaperClient::KeyNotFoundError do
			client.get("key")
		end
	end
end
