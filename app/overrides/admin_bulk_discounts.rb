Deface::Override.new(virtual_path: "spree/admin/shared/sub_menu/_product",
                     name: "add_bulk_discount_settings_link",
                     insert_bottom: "[data-hook='admin_product_sub_tabs'], #sidebar-productgit [data-hook]",
                     text: "<%= tab :bulk_discounts %>")

Deface::Override.new(virtual_path: "spree/admin/products/_form",
                     name: "add_bulk_discount_products_select",
                     insert_bottom: "[data-hook='admin_product_form_right']",
                     partial: "spree/admin/overrides/products/bulk_discount")

