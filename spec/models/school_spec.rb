require 'rails_helper'

RSpec.describe School do
  let!(:school) { FactoryGirl.create(:school) }
  let!(:old_school) { FactoryGirl.create(:school, :old) }

  describe 'self.current' do
    it "returns only schools for the current year's tournament" do
      expect(School.current).to eq [school]
    end
  end
end
