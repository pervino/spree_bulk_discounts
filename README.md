SpreeBulkDiscounts
==================

Yo yo yo! This is the custom built Spree Bulk Discounts gem for exclusive use with Personal Wine.

Changes
-------
* Spree::BulkDiscountConfiguration - Contains defaults to override on initialization.
* Two options for break point values, percent off and flat amount off (TODO validation on flat off)
* no more janky item adjustments override. Redone using Spree's recommend override pattern and hooks into a callback.
* Uses hstore for breakpoints in BulkDiscount because, why not.

Installation
------------

Add spree_bulk_discounts to your Gemfile:

```ruby
gem 'spree_bulk_discounts'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_bulk_discounts:install
```

Testing
-------

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app DB=postgres`.

```shell
bundle
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_bulk_discounts/factories'
```

Copyright (c) 2014 [name of extension creator], released under the New BSD License
