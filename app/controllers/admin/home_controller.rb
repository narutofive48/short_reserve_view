class Admin::HomeController < ApplicationController
  before_action :authenticate_administrator!

  def index
  end
end
