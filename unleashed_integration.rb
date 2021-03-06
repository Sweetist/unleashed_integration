require_relative 'lib/unleashed/unleashed'

class UnleashedIntegration < EndpointBase::Sinatra::Base
  set :logging, true

  post '/get_products' do
    begin
      client = Services::Product.new(@config)
      products = client.get

      products.each { |product| add_object :product, product }

      code    = 200
      message = products.size > 0 ? "Received #{products.size} Products" : ""
      add_param client
    rescue ApiError, RecordNotFound => e
      code    = 500
      message = e.message
    end

    result code, message
  end

  post '/get_customers' do
    begin
      client = Services::Customer.new(@config)
      customers = client.get

      customers.each { |customer| add_object :customer, customer }

      code = 200
      message = customers.size > 0 ? "Received #{customers.size} Customers" : ""
      add_param client
    rescue ApiError, RecordNotFound => e
      code    = 500
      message = e.message
    end

    result code, message
  end

  post '/get_orders' do
    begin
      client = Services::Order.new(@config)
      orders = client.get

      orders.each { |order| add_object :order, order }

      code = 200
      message = orders.size > 0 ? "Received #{orders.size} Orders" : ""
      add_param client
    rescue ApiError, RecordNotFound => e
      code    = 500
      message = e.message
    end

    result code, message
  end

  post '/get_inventory' do
    begin
      client = Services::Inventory.new(@config)
      inventory = client.get
      inventory.each { |inventory| add_object :inventory, inventory }

      code = 200
      message = inventory.size > 0 ? "Received #{inventory.size} Inventory" : ""
      add_param client
    rescue ApiError, RecordNotFound => e
      code    = 500
      message = e.message
    end

    result code, message
  end

  post '/get_shipments' do
    begin
      client = Services::Shipment.new(@config)
      shipments = client.get
      shipments.each { |shipment| add_object :shipment, shipment }

      code = 200
      message = shipments.size > 0 ? "Received #{shipments.size} Shipments" : ""
      add_param client
    rescue ApiError, RecordNotFound => e
      code    = 500
      message = e.message
    end

    result code, message
  end

  ["/add_product", "/update_product"].each do |path|
    post path do
      begin
        client  = Services::Product.new(@config)
        product = client.create(@payload['product'])

        add_object :product, product

        code = 200

        if path == '/add_product'
          message = "Created Product #{@payload['product']['id']} in Unleashed"
        else
          message = "Updated Product #{@payload['product']['id']} in Unleashed"
        end
      rescue ApiError, RecordNotFound => e
        code    = 500
        message = e.message
      end

      result code, message
    end
  end

  ["/add_customer", "/update_customer"].each do |path|
    post path do
      begin
        client  = Services::Customer.new(@config)
        customer = client.create(@payload['customer'])

        add_object :customer, customer

        code    = 200

        if path == '/add_customer'
          message = "Created Customer #{@payload['customer']['id']} in Unleashed"
        else
          message = "Updated Customer #{@payload['customer']['id']} in Unleashed"
        end

      rescue ApiError, RecordNotFound => e
        code    = 500
        message = e.message
      end

      result code, message
    end
  end

  post "/set_inventory" do
    begin
      client  = Services::Inventory.new(@config)
      inventory = client.create(@payload['inventory'])

      add_object :inventory, inventory

      code    = 200
      message = "Set Inventory in Unleashed"
    rescue ApiError, RecordNotFound => e
      code = 500
      message = e.message
    end

    result code, message
  end

  post "/add_order" do
    begin
      client  = Services::Order.new(@config)
      order = client.create(@payload['order'])

      add_object :order, order

      code    = 200
      message = "Created Order #{order['id']} in Unleashed"
    rescue ApiError, RecordNotFound => e
      code = 500
      message = e.message
    end

    result code, message
  end

  def add_param(client)
    add_parameter(:modified_since, client.last_update) if client.last_update
  end
end