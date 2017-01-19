module ApplicationHelper
  def return_cookie_filters(cookie_key: nil, filter_key:nil,values: nil, defaults: nil, type: nil)
    raise "Error" if cookie_key.nil? || filter_key.nil? || (values.nil? && type != "boolean")
    values = ["false"] if type == "boolean"
    values = values.map {|v| v[1].to_s} if type == "select" || values[0].class == Array
    defaults ||= [] if type == "select"
    if !cookies[cookie_key].blank?
      json = JSON.parse(cookies[cookie_key])
      if !json[filter_key].blank?
        checked_envs ||= json[filter_key] if type == "boolean" || type == "select"
        checked_envs ||=  values.map {|v|  json[filter_key].include?(v) ? v : nil }.compact
      end
    end
    checked_envs ||= defaults.nil? ? (type == "checkbox" ? values : nil) : defaults
  end
end
