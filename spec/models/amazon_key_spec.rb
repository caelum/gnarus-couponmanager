Spec::Matchers.define :be_unassigned do |key|
  match do |key|
    key.user_id == nil && key.assignment_date == nil
  end
end


describe AmazonKey do
  it "should raise error if new key is required but none is avaliable" do
     AmazonKey.create(:key_code => "sfgdhf3gj43", :user_id => 13, :assignment_date => Time.now)
     AmazonKey.create(:key_code => "zfd90gs2dfg", :user_id => 20, :assignment_date => Time.now)
     AmazonKey.create(:key_code => "dfd354fgh4563", :user_id => 30, :assignment_date => Time.now)
     
     lambda { AmazonKey.find_by_user_id_or_assign_to_user(111) }.should raise_error
  end
  
  context "one key assigned to gnarus user with id=13, another to id=20 and 3 avaliable keys" do
    before do
      AmazonKey.create(:key_code => "fff555", :user_id => 13, :assignment_date => Time.now)
      AmazonKey.create(:key_code => "zfd90gs2dfg", :user_id => 20, :assignment_date => Time.now)
      AmazonKey.create(:key_code => "abc123")
      AmazonKey.create(:key_code => "hgk324gjhkjgdfd")
      AmazonKey.create(:key_code => "sbsd345hjety")
    end
    
    it "should find key assigned to user" do
      key = AmazonKey.find_by_user_id_or_assign_to_user(13)

      key.key_code.should == "fff555"
      key.user_id == 13
    end


    it "should assign key to user if avaliable" do
       key = AmazonKey.find_by_user_id_or_assign_to_user(15)

       key.key_code.should == "abc123"
       key.user_id == 15
    end

    it "should return number of avaliable unassigned keys" do
      AmazonKey.avaliable.current.should == 3
    end
    
    it "should return true if number of avaliable keys is under minimal of 20 avaliable keys" do
      AmazonKey.avaliable.under_minimal?.should be true
    end
  end
  
  it "should return false if number of avaliable keys is over 20" do
    AmazonKey.create(:key_code => "fff555", :user_id => 13, :assignment_date => Time.now)
    AmazonKey.create(:key_code => "zfd90gs2dfg", :user_id => 20, :assignment_date => Time.now)
    
    22.times do |i|
      AmazonKey.create(:key_code => "abc123#{i}")
    end
    
    AmazonKey.avaliable.under_minimal?.should be false
  end
  
  it "should change assignment_date and user_id to nil" do
    key = AmazonKey.create(:key_code => "fff555", :user_id => 13, :assignment_date => Time.now)
  
    #expect{key.unassign}.to change{key.user_id}.to(nil) 
    
    key.unassign.should be_unassigned
  end
  
  it "should be assigned if user_id is nil" do
    key_with_no_user_id = AmazonKey.new(:key_code => "adfsadfdasfg")
    key_with_user_id = AmazonKey.new(:key_code => "sfdgf5346fg", :user_id => 10)
    
    key_with_no_user_id.assigned?.should == false
    key_with_user_id.assigned?.should == true
  end
    
end