require "minitest/autorun"
require "paper_client"
require "global"

class VersionTest < UnitTest
	def test_version
		client = init_client
		assert client.version.length > 0
	end
end
