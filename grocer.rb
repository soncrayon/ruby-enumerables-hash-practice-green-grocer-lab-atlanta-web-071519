def consolidate_cart(cart)
  organized_cart = {}
  cart.map { |item_hash|
    item_hash.each { |name, price_details|
      if organized_cart[name].nil?
        organized_cart[name] = price_details.merge({:count => 1})
      else
        organized_cart[name][:count] += 1
      end
    }
  }
  return organized_cart
end

def apply_coupons(consolidated_cart, coupons)
  
  cart_w_coupons = {}
 
    coupons.map { |coupon|
      if ((consolidated_cart[coupon[:item]]) && (consolidated_cart[coupon[:item]][:count] >= coupon[:num]))
        item_w_coupon_name = "#{coupon[:item]} W/COUPON"
        item_w_coupon_count = coupon[:num] 
        item_w_coupon_clearance = consolidated_cart[coupon[:item]][:clearance]#true 
        item_w_coupon_price = (coupon[:cost]) / item_w_coupon_count
        
            if cart_w_coupons[item_w_coupon_name]
              item_w_coupon_name[:count] += 1 
            elsif cart_w_coupons[item_w_coupon_name].nil? 
              cart_w_coupons.merge!({item_w_coupon_name => {:price => item_w_coupon_price,
                :clearance => item_w_coupon_clearance,
                :count => item_w_coupon_count
              }})
            end 
            
        consolidated_cart[coupon[:item]][:count] = consolidated_cart[coupon[:item]][:count] - item_w_coupon_count 
      end 
      }
       
     cart_w_coupons = cart_w_coupons.merge!(consolidated_cart)
   
  return cart_w_coupons
end 

def apply_clearance(cart)
  cart.map { |item, price_hash|
    if price_hash[:clearance] == true
      price_hash[:price] = (price_hash[:price] * 0.8).round(2)
    end
  }
  return cart
end

def checkout(items, coupons)
  cart = consolidate_cart(items)
  cart1 = apply_coupons(cart, coupons)
  cart2 = apply_clearance(cart1)
  
  total = 0
  
  cart2.map { |name, price_hash|
    total += price_hash[:price] * price_hash[:count]
  }
  
  total > 100 ? total * 0.9 : total
  
end