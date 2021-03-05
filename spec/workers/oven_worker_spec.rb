require 'rails_helper'
describe "OvenWorker" do
  describe "perform" do
    it "Sets cookie as completed after 2 minutes" do
      cookie = FactoryGirl.create(:cookie, completed_baking_at: nil)
      completion_time = DateTime.current
      Kernel.should_receive(:sleep).with(120)
      OvenWorker.new.perform(cookie.id)
      cookie.reload
      expect(cookie.completed_baking_at).to be_within(1.second).of(completion_time)
    end
  end
end