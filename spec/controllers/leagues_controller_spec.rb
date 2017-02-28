require 'rails_helper'

RSpec.describe LeaguesController do
  let(:user)    { FactoryGirl.create(:user) }
  let!(:empty_user_league) { FactoryGirl.create(:league, commissioner: user) }
  let!(:empty_not_user_league) { FactoryGirl.create(:league) }
  let!(:full_league) { FactoryGirl.create(:league, :full) }

  before do
    sign_in(user)
  end

  describe '#index' do
    it 'returns non-full/open leagues' do
      get :index
      expect(response).to have_http_status :ok
      expect(assigns(:leagues)).to include(empty_not_user_league)
      expect(assigns(:leagues)).to_not include(empty_user_league)
      expect(assigns(:leagues)).to_not include(full_league)
    end
  end
end
