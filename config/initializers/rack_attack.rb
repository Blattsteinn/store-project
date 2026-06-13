class Rack::Attack
  # Throttle order creation by IP: max 10 attempts per hour
  throttle("orders/ip", limit: 10, period: 1.hour) do |req|
    req.ip if req.path == "/orders" && req.post?
  end

  # Throttle order creation by email: max 5 attempts per email per hour
  throttle("orders/email", limit: 5, period: 1.hour) do |req|
    if req.path == "/orders" && req.post?
      req.params["email"].to_s.downcase.strip.presence
    end
  end
end
