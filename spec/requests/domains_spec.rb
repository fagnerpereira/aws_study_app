require 'rails_helper'

RSpec.describe "Domains", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/domains"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      domain = create(:domain)
      get "/domains/#{domain.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
