require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/games/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /service_match" do
    it "returns http success" do
      get "/games/service_match"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /architecture_challenge" do
    it "returns http success" do
      get "/games/architecture_challenge"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /cost_calculator" do
    it "returns http success" do
      get "/games/cost_calculator"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /quick_quiz" do
    it "returns http success" do
      get "/games/quick_quiz"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /scenario_tree" do
    it "returns http success" do
      get "/games/scenario_tree"
      expect(response).to have_http_status(:success)
    end
  end

end
