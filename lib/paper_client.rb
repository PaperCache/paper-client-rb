require "tcp_client"
require "sheet_builder"
require "sheet_reader"

module PaperClient
	class Client
		def initialize(addr)
			@host, @port = parse_addr(addr)
			@tcp_client = TcpClient.new(@host, @port)

			handshake(@tcp_client)
		end

		def ping
			sheet = SheetBuilder.new
				.write_u8(CommandByte::PING)

			return self.process_data(sheet)
		end

		def version
			sheet = SheetBuilder.new
				.write_u8(CommandByte::VERSION)

			return self.process_data(sheet)
		end

		def auth(token)
			@token = token

			sheet = SheetBuilder.new
				.write_u8(CommandByte::AUTH)
				.write_str(@token)

			return self.process(sheet)
		end

		def get(key)
			sheet = SheetBuilder.new
				.write_u8(CommandByte::GET)
				.write_str(key)

			return self.process_data(sheet)
		end

		def set(key, value, ttl = 0)
			sheet = SheetBuilder.new
				.write_u8(CommandByte::SET)
				.write_str(key)
				.write_str(value)
				.write_u32(ttl)

			return self.process(sheet)
		end

		def del(key)
			sheet = SheetBuilder.new
				.write_u8(CommandByte::DEL)
				.write_str(key)

			return self.process(sheet)
		end

		def has(key)
			sheet = SheetBuilder.new
				.write_u8(CommandByte::HAS)
				.write_str(key)

			return self.process_has(sheet)
		end

		def peek(key)
			sheet = SheetBuilder.new
				.write_u8(CommandByte::PEEK)
				.write_str(key)

			return self.process_data(sheet)
		end

		def ttl(key, ttl = 0)
			sheet = SheetBuilder.new
				.write_u8(CommandByte::TTL)
				.write_str(key)
				.write_u32(ttl)

			return self.process(sheet)
		end

		def size(key)
			sheet = SheetBuilder.new
				.write_u8(CommandByte::SIZE)
				.write_str(key)

			return self.process_size(sheet)
		end

		def wipe
			sheet = SheetBuilder.new
				.write_u8(CommandByte::WIPE)

			return self.process(sheet)
		end

		def resize(size)
			sheet = SheetBuilder.new
				.write_u8(CommandByte::RESIZE)
				.write_u64(size)

			return self.process(sheet)
		end

		def policy(policy_id)
			sheet = SheetBuilder.new
				.write_u8(CommandByte::POLICY)
				.write_str(policy_id)

			return self.process(sheet)
		end

		def status
			sheet = SheetBuilder.new
				.write_u8(CommandByte::STATUS)

			return self.process_status(sheet)
		end

	private
		def process(sheet)
			@tcp_client.send(sheet)
			reader = SheetReader.new(@tcp_client)

			is_ok = reader.read_bool

			if !is_ok
				raise parse_error(reader)
			end
		end

		def process_data(sheet)
			@tcp_client.send(sheet)
			reader = SheetReader.new(@tcp_client)

			is_ok = reader.read_bool

			if !is_ok
				raise parse_error(reader)
			end

			return reader.read_str
		end

		def process_has(sheet)
			@tcp_client.send(sheet)
			reader = SheetReader.new(@tcp_client)

			is_ok = reader.read_bool

			if !is_ok
				raise parse_error(reader)
			end

			return reader.read_bool
		end

		def process_size(sheet)
			@tcp_client.send(sheet)
			reader = SheetReader.new(@tcp_client)

			is_ok = reader.read_bool

			if !is_ok
				raise parse_error(reader)
			end

			return reader.read_u32
		end

		def process_status(sheet)
			@tcp_client.send(sheet)
			reader = SheetReader.new(@tcp_client)

			is_ok = reader.read_bool

			if !is_ok
				raise parse_error(reader)
			end

			pid = reader.read_u32

			max_size = reader.read_u64
			used_size = reader.read_u64
			num_objects = reader.read_u64

			rss = reader.read_u64
			hwm = reader.read_u64

			total_gets = reader.read_u64
			total_sets = reader.read_u64
			total_dels = reader.read_u64

			miss_ratio = reader.read_f64

			num_policies = reader.read_u32
			policies = []

			for _ in 1..num_policies do
				policies.push(reader.read_str)
			end

			policy_id = reader.read_str
			is_auto_policy = reader.read_bool

			uptime = reader.read_u64

			return Status.new(\
				pid,\
				max_size,\
				used_size,\
				num_objects,\
				rss,\
				hwm,\
				total_gets,\
				total_sets,\
				total_dels,\
				miss_ratio,\
				policies,\
				policy_id,\
				is_auto_policy,\
				uptime\
			)
		end
	end

	class Status
		attr_reader\
			:pid,\
			:max_size,\
			:used_size,\
			:num_objects,\
			:rss,\
			:hwm,\
			:total_gets,\
			:total_sets,\
			:total_dels,\
			:miss_ratio,\
			:policies,\
			:policy_id,\
			:is_auto_policy,\
			:uptime

		def initialize(\
			pid,\
			max_size,\
			used_size,\
			num_objects,\
			rss,\
			hwm,\
			total_gets,\
			total_sets,\
			total_dels,\
			miss_ratio,\
			policies,\
			policy_id,\
			is_auto_policy,\
			uptime\
		)
			@pid = pid

			@max_size = max_size
			@used_size = used_size
			@num_objects = num_objects

			@rss = rss
			@hwm = hwm

			@total_gets = total_gets
			@total_sets = total_sets
			@total_dels = total_dels

			@miss_ratio = miss_ratio

			@policies = policies
			@policy_id = policy_id
			@is_auto_policy = is_auto_policy

			@uptime = uptime
		end
	end

	class InternalError < StandardError; end
	class InvalidAddressError < StandardError; end
	class ConnectionRefusedError < StandardError; end
	class MaxConnectionsExceededError < StandardError; end
	class UnauthorizedError < StandardError; end
	class DisconnectedError < StandardError; end
	class KeyNotFoundError < StandardError; end
	class ZeroValueSizeError < StandardError; end
	class ExceedingValueSizeError < StandardError; end
	class ZeroCacheSizeError < StandardError; end
	class UnconfiguredPolicy < StandardError; end
	class InvalidPolicy < StandardError; end
end

module CommandByte
	PING = 0
	VERSION = 1

	AUTH = 2

	GET = 3
	SET = 4
	DEL = 5

	HAS = 6
	PEEK = 7
	TTL = 8
	SIZE = 9

	WIPE = 10

	RESIZE = 11
	POLICY = 12

	STATUS = 13
end

def parse_error(reader)
	code = reader.read_u8

	if code == 0
		cache_code = reader.read_u8

		return case cache_code
			when 1
				PaperClient::KeyNotFoundError
			when 2
				ZeroValueSize
			when 3
				ExceedingValueSize
			when 4
				ZeroCacheSize
			when 5
				UnconfiguredPolicy
			when 6
				InvalidPolicy
			else
				PaperClient::InternalError
		end
	end

	return case code
		when 2
			PaperClient::MaxConnectionsExceededError
		when 3
			PaperClient::UnauthorizedError
		else
			PaperClient::InternalError
	end
end

def handshake(tcp_client)
	reader = SheetReader.new(tcp_client)
	is_ok = reader.read_bool

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
