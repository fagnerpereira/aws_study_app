require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/signup"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "handles successful signup" do
      post "/signup", params: { user: { email: "test@example.com", password: "password123", name: "Test User" } }
      expect(response).to have_http_status(:redirect)
    end
    
    it "handles invalid signup" do
      post "/signup", params: { user: { email: "", password: "short", name: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /show" do
    it "redirects when not logged in" do
      get "/profile"
      expect(response).to have_http_status(:redirect)
    end
    
    it "returns success when logged in" do
      user = create(:user)
      login_as(user)
      get "/profile"
      expect(response).to have_http_status(:success)
    end
  end
end
