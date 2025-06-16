require "minitest/autorun"
require "paper_client"
require "global"

class WipeTest < UnitTest
	def test_wipe
		client = init_client

		client.set("key", "value")
		client.wipe
		assert !client.has("key")
	end
end
