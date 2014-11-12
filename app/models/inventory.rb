class Inventory < ActiveRecord::Base
  attr_accessor :product
  before_save :split_product

  private

  def split_product
    if self.product and self.product.match(/@(\d{2})(\d+)/)
      self.code = $1.to_i
      self.roll = $2.to_i
    end
  end
end
