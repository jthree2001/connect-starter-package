class Product < ActiveRecord::Base

  before_destroy :delete_in_zuora
  before_create :create_in_zuora
  before_update :update_in_zuora

  private
  def delete_in_zuora
    url = Thread.current[:appinstance].target_login.client.rest_endpoint("object/product/#{self.zuora_id}")
    resp = Thread.current[:appinstance].target_login.client.rest_call(:url => url, :method => :delete, :debug => false)
    if resp[0]["success"]
      return true
    else
      return false
    end
  end

  def create_in_zuora
    resp = Thread.current[:appinstance].target_login.client.rest_call(:url => Thread.current[:appinstance].target_login.client.rest_endpoint("object/product"), :method => :post, body: {"Name" => self.name, "EffectiveStartDate" => DateTime.now.strftime("%F") , "EffectiveEndDate" => 100.years.from_now.strftime("%F")}.to_json, :debug => false)[0]
    if resp["Success"]
      self.zuora_id = resp["Id"]
    else
      return false
    end
  end

  def update_in_zuora
    resp = Thread.current[:appinstance].target_login.client.rest_call(:url => Thread.current[:appinstance].target_login.client.rest_endpoint("object/product/#{self.zuora_id}"), :method => :put, body: {"Name" => self.name}.to_json, :debug => false)[0]
    if resp["Success"]
      return true
    else
      return false
    end
  end
end
