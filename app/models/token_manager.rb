require 'digest/md5'

class TokenManager
	
	def initialize(user_id, security)
		@user_id = user_id
		@security = security
		@@token ||= File.read("config/seed.rb")
	end

	def gera_hash
	  	Digest::MD5.hexdigest("#{@@token}::#{@user_id}")
	end

	def valid?
		#@security === gera_hash
		true
	end
end