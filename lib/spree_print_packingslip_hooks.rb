class SpreePrintPackingslipHooks < Spree::ThemeSupport::HookListener
  insert_after :admin_shipment_edit_buttons do
    %( <%= button_link_to("Packing Slip", packingslip_admin_order_shipment_url( @order, @shipment, :format => :pdf )) %> )
  end
end