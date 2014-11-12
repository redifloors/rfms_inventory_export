require 'test_helper'

class InventoryTest < ActiveSupport::TestCase
  def setup
    @inv = Inventory.new(product: '@021234567', width: 12, feet: 100, inches: 5)
  end

  test 'should respond to product' do
    assert_respond_to Inventory.new, :product
  end

  test 'should parse product before save' do
    # inv = Inventory.new(product: '@021234567', width: 12, feet: 100, inches: 5)

    # Make sure code and roll are nil before the save (test the test)
    assert_nil @inv.code
    assert_nil @inv.roll

    # Save the record
    @inv.save!

    # Code and Roll should now be filled in from product
    assert_equal 2, @inv.code
    assert_equal '1234567', @inv.roll
  end

  test 'should respond to length' do
    assert_respond_to @inv, :length
    assert_equal 100.42, @inv.length
  end

  test 'should respond to yards' do
    assert_respond_to @inv, :yards
    assert_equal 33.14, @inv.yards
  end

  test 'should respond to sq_feet' do
    assert_respond_to @inv, :sq_feet
    assert_equal 1205.04, @inv.sq_feet
  end

  test 'should respond to sq_yards' do
    assert_respond_to @inv, :sq_yards
    assert_equal 397.68, @inv.sq_yards
  end
end
