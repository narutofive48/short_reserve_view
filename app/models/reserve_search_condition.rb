class ReserveSearchCondition
  include ActiveModel::Model
  attr_writer :date
  def date
    Date.parse(@date)
  rescue
    nil
  end
end
