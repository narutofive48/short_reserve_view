module Noticable
  extend ActiveSupport::Concern
  module ClassMethods
    def displaying
      where("begin_at <= NOW()").where("end_at >= NOW() OR end_at IS NULL").where(checked_at: nil)

    end
  end
  def check
    touch(:checked_at)
  end
end
