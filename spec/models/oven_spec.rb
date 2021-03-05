require 'rails_helper'

describe Oven do
  subject { Oven.new }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:cookies) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:user) }
  end

  describe "batch_ready?" do
    let!(:full_oven) { FactoryGirl.create(:oven) }
    let!(:empty_oven) { FactoryGirl.create(:oven) }
    let!(:cookie_one) { FactoryGirl.create(:cookie, storage: full_oven, storage_type: 'Oven', fillings: 'dirt') }
    let!(:cookie_two) { FactoryGirl.create(:cookie, storage: full_oven, storage_type: 'Oven', fillings: 'dirt') }
    let!(:cookie_three) { FactoryGirl.create(:cookie, storage: full_oven, storage_type: 'Oven', fillings: 'dirt') }

    describe "returns true" do
      it 'when an oven has associated cookies and a value for batch_completed_baking_at' do
        full_oven.update(batch_completed_baking_at: DateTime.current)
        expect(full_oven.batch_ready?).to eq(true)
      end
    end

    describe "returns false" do
      it 'when an oven has associated cookies and no value for batch_completed_baking_at' do
        expect(full_oven.batch_ready?).to eq(false)
      end

      it 'when an oven has no associated cookies and a value for batch_completed_baking_at' do
        empty_oven.update(batch_completed_baking_at: DateTime.current)
        expect(empty_oven.batch_ready?).to eq(false)
      end

      it 'when an oven has no associated cookies and no value for batch_completed_baking_at' do
        expect(empty_oven.batch_ready?).to eq(false)
      end
    end
  end

  describe "in_use?" do
    it 'returns true when an oven has associated cookies' do
      oven = FactoryGirl.create(:oven)
      cookie_one = FactoryGirl.create(:cookie, storage: oven, storage_type: 'Oven', fillings: 'rocks')
      cookie_two = FactoryGirl.create(:cookie, storage: oven, storage_type: 'Oven', fillings: 'rocks')
      cookie_three = FactoryGirl.create(:cookie, storage: oven, storage_type: 'Oven', fillings: 'rocks')
      expect(oven.in_use?).to eq(true)
    end

    it 'returns false when an oven has no associated cookies' do
      oven = FactoryGirl.create(:oven)
      expect(oven.in_use?).to eq(false)
    end
  end

  describe "batch_fillings" do
    let!(:full_oven) { FactoryGirl.create(:oven) }
    let!(:empty_oven) { FactoryGirl.create(:oven) }
    let!(:cookie_one) { FactoryGirl.create(:cookie, storage: full_oven, storage_type: 'Oven', fillings: 'dirt') }
    let!(:cookie_two) { FactoryGirl.create(:cookie, storage: full_oven, storage_type: 'Oven', fillings: 'dirt') }
    let!(:cookie_three) { FactoryGirl.create(:cookie, storage: full_oven, storage_type: 'Oven', fillings: 'dirt') }

    describe "an oven with cookies" do
      describe "cookies with the same fillings" do
        it 'returns the fillings' do
          oven = FactoryGirl.create(:oven)
          cookie_one = FactoryGirl.create(:cookie, storage: oven, storage_type: 'Oven', fillings: 'grass')
          cookie_two = FactoryGirl.create(:cookie, storage: oven, storage_type: 'Oven', fillings: 'grass')
          cookie_three = FactoryGirl.create(:cookie, storage: oven, storage_type: 'Oven', fillings: 'grass')
          expect(oven.batch_fillings).to eq('grass')
        end
      end
      describe "cookies with different fillings" do
        it 'returns the fillings joined by a whitespace' do
          oven = FactoryGirl.create(:oven)
          cookie_one = FactoryGirl.create(:cookie, storage: oven, storage_type: 'Oven', fillings: 'dirt')
          cookie_two = FactoryGirl.create(:cookie, storage: oven, storage_type: 'Oven', fillings: 'rocks')
          cookie_three = FactoryGirl.create(:cookie, storage: oven, storage_type: 'Oven', fillings: 'grass')
          cookie_four = FactoryGirl.create(:cookie, storage: oven, storage_type: 'Oven', fillings: 'grass')
          expect(oven.batch_fillings).to include('dirt', 'rocks', 'grass')
        end
      end
    end

    describe "an oven without cookies" do
      it 'returns an empty string' do
        oven = FactoryGirl.create(:oven)
        expect(oven.batch_fillings).to eq('')
      end
    end
  end
end
