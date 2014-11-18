class InventoryStatus
  attr_accessor :valid, :invalid, :total
  attr_reader :errors

  def initialize
    @total = @valid = @invalid = 0
    @errors = Array.new
  end

  def <<(input)
    @errors << input
  end
end

class Inventory < ActiveRecord::Base
  attr_accessor :product, :bulk
  # before_save :split_product

  validates_presence_of :store, :code, :width, :feet
  validates :roll, presence: true, uniqueness: { :scope => :code }

  def self.bulk_import(data)
    line_count = 0
    status = InventoryStatus.new
    record = nil

    data.split("\r\n").each do |line|
      if line[0].ord == 34 or line == 'zy' # Beginning of record or end of data
        # Start the record
        if line[0].ord == 34
          line_count = 0
          status.total += 1
        else
          line_count = -1
        end

        # Save the record and record any errors
        if record
          if record.valid?
            record.save
            status.valid += 1
          else
            status.invalid += 1
            if record.kind_of?(Inventory)
              status << record.errors.map(&:full_messages)
            else
              status << 'Invalid data received in input'
            end
          end
        end
      end

      case line_count
        when -1 then break
        when 0 then record = new_by_product(line)
        when 1 then record.width  = line.to_i
        when 2 then record.feet   = line.to_i
        when 3 then record.inches = line.to_i || 0
        when 4 then record.store  = line.to_i || 0
        else
          status.errors << 'Record overflow occurred, too many record lines or we did not find a delimiter.'
          break
      end
      line_count += 1
    end

    status << 'We did not find the end of the data record, the last entry may not have been saved' if line_count > 0
    status << 'No valid record(s) were found in input' if status.total > 0 and status.valid == 0
    status << 'No record(s) found in input' if status.total == 0
    status
  end

  def length_to_f
    feet.to_f + (inches.to_f/12).round(2)
  end

  def length
    (length_to_f % 1).zero? ? length_to_f.to_i : length_to_f
  end

  def sq_feet
    (length * width).round(2)
  end

  def yards
    (length * 0.33).round(2)
  end

  def sq_yards
    (yards * width).round(2)
  end

  def product_code
    '%02d' % code
  end

  def inventory_code(pre = nil)
    "#{pre}#{product_code}#{roll}"
  end

  def self.new_by_product(product)
    find_or_create_by split_product(product) if product
  end

  private

  def self.split_product(product)
    if product and product.match(/.(\d{2})(.+)/)
      { code: $1.to_i, roll: $2.to_s }
    else
      { code: nil, roll: nil }
    end
  end

end
