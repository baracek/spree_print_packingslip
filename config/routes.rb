Rails.application.routes.draw do
  match "admin/shipment/packingslip/:id" => "admin/shipments#packingslip"
end
