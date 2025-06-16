require "minitest/autorun"
require "paper_client"
require "global"

class PolicyTest < UnitTest
	INITIAL_POLICY_ID = "lfu"
	UPDATED_POLICY_ID = "lru"

	def test_policy
		client = init_client

		client.policy(INITIAL_POLICY_ID)
		assert_equal client.stats.policy_id, INITIAL_POLICY_ID

		client.policy(UPDATED_POLICY_ID)
		assert_equal client.stats.policy_id, UPDATED_POLICY_ID
	end
end
