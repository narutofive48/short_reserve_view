require 'rails_helper'

RSpec.describe "Offices", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/offices/show"
      expect(response).to have_http_status(:success)
    end
  end

end
