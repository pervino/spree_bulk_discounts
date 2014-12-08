Deface::Override.new(virtual_path: "spree/admin/shared/_configuration_menu",
                     name: "add_bulk_discount_settings_link",
                     insert_bottom: "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
                     text: "<%= configurations_sidebar_menu_item 'Bulk Discounts', admin_bulk_discounts_path %>")

Deface::Override.new(virtual_path: "spree/admin/products/_form",
                     name: "add_bulk_discount_products_select",
                     insert_bottom: "[data-hook='admin_product_form_right']",
                     partial: "spree/admin/overrides/products/bulk_discount")

