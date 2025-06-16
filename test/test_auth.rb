require "minitest/autorun"
require "paper_client"

class AuthTest < Minitest::Test
	def test_auth_incorrect
		client = PaperClient::Client.new("paper://127.0.0.1:3145")

		assert_raises PaperClient::UnauthorizedError do
			client.auth("incorrect_auth_token")
		end
	end

	def test_auth_correct
		client = PaperClient::Client.new("paper://127.0.0.1:3145")
		client.auth("auth_token")
	end
end
