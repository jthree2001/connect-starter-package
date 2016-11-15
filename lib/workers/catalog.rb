class Catalog
  attr_accessor :schema
  def initialize(instance_id)
    @instance_id = instance_id
    @schema = ActiveRecord::Base.connection.schema_search_path
  end

  def perform()
    @appinstance = ZuoraConnect::AppInstance.find(@instance_id)
    @appinstance.new_session()
    products = Product.all
    resp = @appinstance.target_login.client.rest_call(:url => @appinstance.target_login.client.rest_endpoint("catalog/products"))
    resp["products"].each do |product|
      if products.where(:name => product["name"]).size == 0
        Product.create!(:name => product["name"], :price => product["productRatePlans"][0]["productRatePlanCharges"][0]["pricingSummary"][0], :category => product["category"])
      end
    end
  end
end
