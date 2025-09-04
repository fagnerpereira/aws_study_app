require 'rails_helper'

RSpec.describe "Lessons", type: :request do
  let(:user) { create(:user) }
  
  describe "GET /show" do
    it "returns http success" do
      login_as(user)
      domain = create(:domain)
      lesson = create(:lesson, domain: domain)
      get "/domains/#{domain.id}/lessons/#{lesson.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
