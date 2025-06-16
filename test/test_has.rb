require "minitest/autorun"
require "paper_client"
require "global"

class HasTest < UnitTest
	def test_exists
		client = init_client

		client.set("key", "value")
		assert client.has("key")
	end

	def test_not_exists
		client = init_client
		assert !client.has("key")
	end
end
