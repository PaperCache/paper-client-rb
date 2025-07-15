require "minitest/autorun"
require "paper_client"
require "global"

class StatusTest < UnitTest
	def test_status
		client = init_client
		client.status.inspect
	end
end
