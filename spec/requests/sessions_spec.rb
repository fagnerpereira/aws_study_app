require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET /new" do
    it "returns http success" do
      get "/login"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "handles successful login" do
      post "/login", params: { email: user.email, password: "password123" }
      expect(response).to have_http_status(:redirect)
    end

    it "handles invalid login" do
      post "/login", params: { email: "invalid@example.com", password: "wrongpassword" }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /destroy" do
    it "handles logout" do
      delete "/logout"
      expect(response).to have_http_status(:redirect)
    end
  end
end
