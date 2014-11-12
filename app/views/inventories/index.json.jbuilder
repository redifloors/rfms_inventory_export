json.array!(@inventories) do |inventory|
  json.extract! inventory, :id, :code, :roll, :width, :feet, :inches
  json.url inventory_url(inventory, format: :json)
end
