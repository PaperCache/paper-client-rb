require "tcp_client"
require "sheet_builder"
require "sheet_reader"

class PaperClient
	def initialize(addr)
		@host, @port = parse_addr(addr)
		@tcp_client = TcpClient.new(@host, @port)

		handshake(@tcp_client)
	end

	def ping()
		sheet = SheetBuilder.new()
			.write_u8(CommandByte::PING)

		return self.process_data(sheet)
	end

	def version()
		sheet = SheetBuilder.new()
			.write_u8(CommandByte::VERSION)

		return self.process_data(sheet)
	end

private

	def process_data(sheet)
		@tcp_client.send(sheet)
		reader = SheetReader.new(@tcp_client)

		is_ok = reader.read_bool()
		str = reader.read_str()
	end
end

module CommandByte
	PING = 0
	VERSION = 1
end

def handshake(tcp_client)
	reader = SheetReader.new(tcp_client)
	is_ok = reader.read_bool()

	if !is_ok
		raise "Unreachable server."
	end
end

def parse_addr(addr)
	if !addr.start_with?("paper://")
		raise "Invalid address."
	end

	addr = addr.sub(/^paper:\/\//, "")

	host, port = addr.split(":")
	return host, port.to_i
end
