require "minitest/autorun"
require "paper_client"

class UnitTest < Minitest::Test
	def init_client
		client = PaperClient::Client.new("paper://127.0.0.1:3145")
		client.auth("auth_token")
		client.wipe

		return client
	end
end
