require 'spec_helper'

describe CookieBatchBaker do
    describe 'perform' do
        it 'creates the batch of cookies' do
        oven = FactoryGirl.create(:oven)
        batch_baker = CookieBatchBaker.new('Cranberries', 12, oven)
        batch_baker.perform
        cookies = Cookie.all

        expect(cookies.length).to eq(12)
        expect(cookies.pluck(:storage_id)).to eq(Array.new(12) { oven.id })
        end
    end
end