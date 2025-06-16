class SheetBuilder
	def initialize
		@buf = []
	end

	def write_u8(value)
		@buf.push(value)
		self
	end

	def write_u32(value)
		bytes = [value].pack("V")
		@buf.concat(bytes.bytes)
		self
	end

	def write_u64(value)
		bytes = [value].pack("Q<")
		@buf.concat(bytes.bytes)
		self
	end

	def write_f64(value)
		bytes = [value].pack("E")
		@buf.concat(bytes.bytes)
		self
	end

	def write_str(value)
		self.write_u32(value.length)
		@buf.concat(value.bytes)
		self
	end

	def bytes
		@buf
	end
end
