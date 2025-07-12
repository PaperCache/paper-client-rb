require "paper_client"

module PaperClient
	class Pool
		def initialize(addr, size)
			@clients = []

			for i in 0..size do
				@clients.push(PaperClient::Client.new(addr))
			end

			@index = 0
		end

		def client
			client = @clients[@index]

			@index += 1
			@index = @index % @clients.length

			return client
		end

		def auth(token)
			@clients.each {
				|client| client.auth(token)
			}
		end
	end
end
