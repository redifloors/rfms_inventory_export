require 'test_helper'

class InventoryTest < ActiveSupport::TestCase
  def setup
    @inv = Inventory.new(code: 2, roll: '1234567', width: 12, feet: 100, inches: 5)
  end

  test 'should respond to product' do
    assert_respond_to Inventory.new, :product
  end

  test 'should create record from product' do
    inv = Inventory.new_by_product('"021234567')
    assert_kind_of Inventory, inv
    assert_equal 2, inv.code
    assert_equal '1234567', inv.roll
  end

  test 'should create record from bulk import' do
    data = "\"018888888\r\n12\r\n150\r\n0\r\n0\r\n\"029999999\r\n12\r\n150\r\n0\r\n0\r\nzy\r\n"
    assert_difference('Inventory.count', 2) do
      Inventory.bulk_import(data)
    end
  end

  test 'should respond to length' do
    assert_respond_to @inv, :length
    assert_equal 100.42, @inv.length
    @inv = inventories(:carpet)
    assert_equal 150, @inv.length
    assert_equal 150.00, @inv.length_to_f
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

  test 'should respond to inventory_code' do
    assert_respond_to @inv, :inventory_code
    assert_equal "#{'%02d'%@inv.code}#{@inv.roll}", @inv.inventory_code
    assert_equal "@#{'%02d'%@inv.code}#{@inv.roll}", @inv.inventory_code('@')
  end
end
