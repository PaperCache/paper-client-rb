require "tcp_client"

class SheetReader
	def initialize(tcp_client)
		@tcp_client = tcp_client
	end

	def read_bool
		return self.read_u8() == 33
	end

	def read_u8
		bytes = @tcp_client.read_bytes(1)
		return bytes[0]
	end

	def read_u32
		data = @tcp_client.read_bytes(4)
		return data.pack("C*").unpack1("V")
	end

	def read_u64
		data = @tcp_client.read_bytes(8)
		return data.pack("C*").unpack1("Q<")
	end

	def read_f64
		data = @tcp_client.read_bytes(8)
		return data.pack("C*").unpack1("E")
	end

	def read_str
		len = self.read_u32()
		bytes = @tcp_client.read_bytes(len)
		return bytes.pack("C*").force_encoding("UTF-8")
	end
end
