class AmazonKey < ActiveRecord::Base

	validates :key_code,
			  uniqueness: true,
			  presence: true
  
  def to_s
    "Key: #{self.key_code}"
  end
  
  def self.unassign_key_for_user(user_id)
      key = AmazonKey.find_by_user_id(user_id)
      key.unassign if key
      key
  end

  def self.find_by_user_id_or_assign_to_user(user_id)
    key = AmazonKey.find_by_user_id(user_id)
  	unless key
  		key = AmazonKey.where(:user_id => nil).first
  		
  		raise NoAvaliableKeysError unless key
  		
  		key.update_attributes user_id: user_id, assignment_date: Time.now
  	end
  	key
  end
  
  def self.avaliable
    AvaliableKeys.new(AmazonKey.where(:assignment_date => nil).count)
  end
  
  def unassign
    update_attributes :user_id => nil, :assignment_date => nil
    self
  end
  
  def assigned?
    self.user_id != nil
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