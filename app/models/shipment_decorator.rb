Shipment.class_eval do
  def count_inventory_units( variant )
    inventory_units.find( :all, :conditions => ['variant_id = ?', variant.id ] ).size
  end
end