require "minitest/autorun"
require "paper_client"
require "global"

class StatsTest < UnitTest
	def test_stats
		client = init_client
		client.stats.inspect
	end
end
