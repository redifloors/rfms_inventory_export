class Inventory < ActiveRecord::Base
  attr_accessor :product
  before_save :split_product

  def length
    feet.to_f + (inches.to_f/12).round(2)
  end

  def sq_feet
    length * width
  end

  def yards
    (length * 0.33).round(2)
  end

  def sq_yards
    yards * width
  end

  private

  def split_product
    if self.product and self.product.match(/@(\d{2})(\d+)/)
      self.code = $1.to_i
      self.roll = $2.to_s
    end
  end

end
