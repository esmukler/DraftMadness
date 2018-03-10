require 'rails_helper'

RSpec.describe School do
  let!(:school) { FactoryGirl.create(:school) }
  let!(:old_school) { FactoryGirl.create(:school, :old) }

  describe 'self.current' do
    it "returns only schools for the current year's tournament" do
      expect(School.current).to eq [school]
    end
  end

  describe 'self.find_using_slug' do
    let!(:play_in_school) do
      FactoryGirl.create(:school, name: 'Providence/USC', slug: 'providence/southern-california')
    end

    it 'finds the school if an exact match' do
      expect(described_class.find_using_slug('ucla')).to eq school
    end

    it 'still finds the school if its a two-slug school' do
      expect(described_class.find_using_slug('providence')).to eq play_in_school
      expect(described_class.find_using_slug('southern-california')).to eq play_in_school
    end
  end
end
