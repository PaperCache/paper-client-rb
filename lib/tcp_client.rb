require "socket"

class TcpClient
	BUF_SIZE = 4096

	def initialize(host, port)
		@socket = TCPSocket.new(host, port)
		@buf = Queue.new
	end

	def send(sheet)
		data = sheet.bytes.pack("C*")
		@socket.write(data)
	end

	def read_bytes(size)
		while @buf.length < size
			chunk = @socket.recv(BUF_SIZE)
			chunk.each_byte { |b| @buf.push(b) }
		end

		data = []

		for _ in 1..size do
			data.push(@buf.pop)
		end

		return data
	end
end
