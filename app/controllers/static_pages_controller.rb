class StaticPagesController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_login_has_shop
  def top;end
end
