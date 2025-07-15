require "minitest/autorun"
require "paper_client"
require "global"

class ResizeTest < UnitTest
	INITIAL_SIZE = 10 * 1024 * 1024
	UPDATED_SIZE = 10 * 1024 * 1024

	def test_resize
		client = init_client

		client.resize(INITIAL_SIZE)
		assert_equal client.status.max_size, INITIAL_SIZE

		client.resize(UPDATED_SIZE)
		assert_equal client.status.max_size, UPDATED_SIZE
	end
end
