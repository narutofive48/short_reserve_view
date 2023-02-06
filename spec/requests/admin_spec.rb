require 'rails_helper'

RSpec.describe "Admins", type: :request do
  describe "GET /top" do
    it "returns http success" do
      get "/admin/top"
      expect(response).to have_http_status(:success)
    end
  end

end
