require 'rails_helper'

RSpec.describe "Games", type: :request do
  let(:user) { create(:user) }
  
  describe "GET /index" do
    it "returns http success" do
      login_as(user)
      get "/games"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /service_match" do
    it "returns http success" do
      login_as(user)
      get "/games/service-match"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /architecture_challenge" do
    it "returns http success" do
      login_as(user)
      get "/games/architecture-challenge"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /cost_calculator" do
    it "returns http success" do
      login_as(user)
      get "/games/cost-calculator"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /quick_quiz" do
    it "returns http success" do
      login_as(user)
      get "/games/quick-quiz"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /scenario_tree" do
    it "returns http success" do
      login_as(user)
      get "/games/scenario-tree"
      expect(response).to have_http_status(:success)
    end
  end
end
