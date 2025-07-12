require "minitest/autorun"
require "paper_pool"
require "global"

class PoolTest < UnitTest
	def test_allows_use
		pool = PaperClient::Pool.new("paper://127.0.0.1:3145", 2)
		client = pool.client

		assert_equal client.ping, "pong"
	end

	def test_auth
		pool = PaperClient::Pool.new("paper://127.0.0.1:3145", 2)
		client = pool.client

		assert_raises PaperClient::UnauthorizedError do
			client.set("key", "value")
		end

		client = pool.client
		client.auth("auth_token")
		client.set("key", "value")
	end
end
