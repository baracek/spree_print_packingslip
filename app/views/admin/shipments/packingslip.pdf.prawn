require 'prawn/layout'

bill_address = @shipment.order.bill_address
ship_address = @shipment.order.ship_address

pdf.font "Helvetica"

pdf.image File.join( Rails.root, "public", Spree::PrintSettings::Config[:print_logo_path] ), :at => [0,720], :scale => 0.65

pdf.fill_color "005D99"
pdf.text "Packing Slip", :align => :center, :style => :bold, :size => 22
pdf.fill_color "000000"

pdf.text Spree::PrintSettings::Config[:print_company_name], :style => :bold, :align => :right, :size=>16
pdf.text Spree::PrintSettings::Config[:print_company_address1], :align => :right, :size=>14
pdf.text Spree::PrintSettings::Config[:print_company_address2], :align => :right, :size=>14
pdf.text Spree::PrintSettings::Config[:print_company_phone], :align => :right, :size=>14

pdf.font "Helvetica", :style => :bold, :size => 14
pdf.text "Shipment Number: #{@shipment.number}"

pdf.font "Helvetica", :size => 8
if @shipment.shipped_at.blank? == false
   pdf.text @shipment.shipped_at.to_s(:long)
end

# Address Stuff
pdf.bounding_box [0,600], :width => 540 do
  pdf.move_down 2
  data = [[Prawn::Table::Cell.new( :text => "Billing Address", :font_style => :bold ),
                Prawn::Table::Cell.new( :text =>"Shipping Address", :font_style => :bold )]]

  pdf.table data,
    :position           => :center,
    :border_width => 0.5,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :border_style => :underline_header,
    :column_widths => { 0 => 270, 1 => 270 }

  pdf.move_down 2
  pdf.horizontal_rule

  pdf.bounding_box [0,0], :width => 540 do
    pdf.move_down 2
    data2 = [["#{bill_address.firstname} #{bill_address.lastname}", "#{ship_address.firstname} #{ship_address.lastname}"],
            [bill_address.address1, ship_address.address1]]
    data2 << [bill_address.address2, ship_address.address2] unless bill_address.address2.blank? and ship_address.address2.blank?
    data2 << ["#{@shipment.order.bill_address.city}, #{(@shipment.order.bill_address.state ? @shipment.order.bill_address.state.abbr : "")} #{@shipment.order.bill_address.zipcode}",
              "#{@shipment.order.ship_address.city}, #{(@shipment.order.ship_address.state ? @shipment.order.ship_address.state.abbr : "")} #{@shipment.order.ship_address.zipcode}"]
    data2 << [bill_address.country.name, ship_address.country.name]
    data2 << [bill_address.phone, ship_address.phone]

    pdf.table data2,
      :position           => :center,
      :border_width => 0.0,
      :vertical_padding   => 0,
      :horizontal_padding => 6,
      :font_size => 9,
      :column_widths => { 0 => 270, 1 => 270 }
  end

  pdf.move_down 2

  pdf.stroke do
    pdf.line_width 0.5
    pdf.line pdf.bounds.top_left, pdf.bounds.top_right
    pdf.line pdf.bounds.top_left, pdf.bounds.bottom_left
    pdf.line pdf.bounds.top_right, pdf.bounds.bottom_right
    pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
  end

end

pdf.move_down 30

# Line Items
pdf.bounding_box [0,cursor], :width => 540, :height => 450 do
  pdf.move_down 2
  data =  [[Prawn::Table::Cell.new( :text => "SKU", :font_style => :bold),
                Prawn::Table::Cell.new( :text =>"Item Description", :font_style => :bold ),
                Prawn::Table::Cell.new( :text =>"Qty", :font_style => :bold )]]


  pdf.table data,
    :position           => :center,
    :border_width => 0,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :column_widths => { 0 => 75, 1 => 400, 2 => 65 } ,
    :align => { 0 => :left, 1 => :left, 2 => :right }

  pdf.move_down 4
  pdf.horizontal_rule
  pdf.move_down 2

  pdf.bounding_box [0,cursor], :width => 540 do
    pdf.move_down 2
    data2 = []
    @shipment.line_items.each do |line_item|
      data2 << [line_item.variant.product.sku,
                line_item.variant.product.name,
                @shipment.count_inventory_units( line_item.variant )]
    end


    pdf.table data2,
      :position           => :center,
      :border_width => 0,
      :vertical_padding   => 5,
      :horizontal_padding => 6,
      :font_size => 9,
      :column_widths => { 0 => 75, 1 => 400, 2 => 65 },
      :align => { 0 => :left, 1 => :left, 2 => :right }
  end

  pdf.move_down 2

  pdf.stroke do
    pdf.line_width 0.5
    pdf.line pdf.bounds.top_left, pdf.bounds.top_right
    pdf.line pdf.bounds.top_left, pdf.bounds.bottom_left
    pdf.line pdf.bounds.top_right, pdf.bounds.bottom_right
    pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
  end

end

# Footer
repeat :all do
  footer_message = <<EOS
Shipping is not refundable. | Special orders are non-refundable.
In order to return a product prior authorization with a RMA number is mandatory
All returned items must be in original un-opened packaging with seal intact.
EOS
  pdf.move_down 2
  pdf.text Spree::PrintSettings::Config[:print_company_website], :align => :right, :size=>10
  pdf.text_box footer_message, :at => [pdf.margin_box.left, pdf.margin_box.bottom + 30], :size => 8
end
