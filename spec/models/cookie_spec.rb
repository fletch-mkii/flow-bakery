require 'rails_helper'

describe Cookie do
  subject { Cookie.new }

  describe "associations" do
    it { is_expected.to belong_to(:storage) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:storage) }
  end

  describe "ready?" do
    it "returns true when a cookie is marked as completed" do
      cookie = FactoryGirl.create(:cookie, completed_baking_at: DateTime.current)
      expect(cookie.ready?).to eq(true)
    end

    it "returns false when a cookie is not marked as completed" do
      cookie = FactoryGirl.create(:cookie, completed_baking_at: nil)
      expect(cookie.ready?).to eq(false)
    end
  end

  describe "normalize_blank_fillings" do
    it "calls the method before validation" do
      cookie = FactoryGirl.build(:cookie, fillings: "")
      expect(cookie).to receive(:normalize_blank_fillings)
      cookie.validate
    end

    it "normalizes blank fillings to nil" do
      cookie = FactoryGirl.build(:cookie, fillings: "")
      expect(cookie.fillings).to eq("")
      cookie.normalize_blank_fillings
      expect(cookie.fillings).to eq(nil)
    end

    it "does not alter non-blank fillings" do
      cookie = FactoryGirl.build(:cookie, fillings: "Salsa")
      expect(cookie.fillings).to eq("Salsa")
      cookie.normalize_blank_fillings
      expect(cookie.fillings).to eq("Salsa")
    end
  end
end
