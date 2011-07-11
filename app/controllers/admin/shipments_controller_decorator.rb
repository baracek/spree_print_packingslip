Admin::ShipmentsController.class_eval do
  respond_to :pdf
  
  def packingslip
    @shipment = Shipment.find_by_param( params["id"] )
    respond_with( @shipment )
  end
end