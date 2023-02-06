require 'rails_helper'

RSpec.describe "/index.html.erb", type: :view do
  describe "Get /index" do
    subject { GET() }
    before{ }
    it "一覧が表示される" do
      subject
    end
  end
end
