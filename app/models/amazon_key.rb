class AmazonKey < ActiveRecord::Base

	validates :key_code,
			  uniqueness: true,
			  presence: true
  
  def to_s
    "Key: #{self.key_code}"
  end

  def self.find_by_user_id_or_assign_to_user(user_id)
    key = AmazonKey.find_by_user_id(user_id)
  	unless key
  		key = AmazonKey.where(:assignment_date => nil).first
  		
  		raise NoAvaliableKeysError unless key
  		
  		key.update_attributes user_id: user_id, assignment_date: Time.now
  	end
  	key
  end
  
  def self.avaliable
    AvaliableKeys.new(AmazonKey.where(:assignment_date => nil).count)
  end

end

class AvaliableKeys
  attr_reader :current
  
  def initialize(current)
    @@minimal_avaliable_keys = 20
    @current = current
  end
  
  def under_minimal?
    self.current < @@minimal_avaliable_keys
  end
  
end

class NoAvaliableKeysError < StandardError; end