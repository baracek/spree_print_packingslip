class SpreePrintPackingslipHooks < Spree::ThemeSupport::HookListener
  insert_after :admin_shipment_edit_buttons do
    %( <%= button_link_to("Packing Slip", {:controller=>"admin/shipment", :action=>"packingslip", :format=>:pdf}) %> )
  end
end