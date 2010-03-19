class Object

	# Just helps generating nice error messages
	# when things go wrong
	class ProxyObject

		attr_accessor :fake_class

		def to_s
			@fake_class.to_s
		end

	end

	# Just like should_receive in the standard rspec
	# but also calls the real method
	def should_receive!(sym, opts={}, &block)

		@__rspec_obj__ ||= ProxyObject.new
		@__rspec_obj__.fake_class = self.class

		m = class<<self;self;end

		sym_old =  "__#{sym}__old__"

		# Generates for sym => :foo
		#
		#   alias :foo_old :foo
		#
		#   def foo *args, &block
		#       foo_old *args, &block
		#       @__rspec_obj__.send :foo, *args, &block
		#   end
		if not respond_to?("#{sym_old}".to_sym)
			m.class_eval <<-EOS, __FILE__, __LINE__
					alias :#{sym_old} :#{sym}

					def #{sym}  *args, &block 
							#{sym_old} *args, &block
							@__rspec_obj__.send :#{sym}, *args, &block
					end
			EOS
		end
		@__rspec_obj__.should_receive(sym, opts, &block)
	end

end
