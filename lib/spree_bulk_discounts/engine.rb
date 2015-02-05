module SpreeBulkDiscounts
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_bulk_discounts'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree.bulk_discount.environment", :before => :load_config_initializers do |app|
      Spree::BulkDiscount::Config = Spree::BulkDiscountConfiguration.new
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      if Rails.env.test?
        Dir.glob(File.join(File.dirname(__FILE__), './overrides/**/*_decorator*.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end

        if Spree::LineItem.table_exists?
          Spree::LineItem.register_price_modifier_hook(:bulk_discount_total)
        end
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
