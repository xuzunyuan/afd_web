package com.afd.web.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.afd.common.util.RequestUtils;
import com.afd.constants.order.OrderConstants;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;
import com.afd.param.cart.CookieCartItem;

@Controller
@RequestMapping("/temp")
public class TempCartCookieController {
	
	@RequestMapping("/addcart")
	public String cartCookie() {
		return "/cart/tempCC";
	}
	
	@RequestMapping("/addCartCookie")
	public String addCartCookie(@CookieValue(value="cart",required=false) String cookieCart, 
			@RequestParam("bsdId") Long bsdId, HttpServletRequest request, HttpServletResponse response) {
		List<CookieCartItem> cookieCartItems = JSON.parseObject(cookieCart, new TypeReference<List<CookieCartItem>>(){});
		if(cookieCartItems == null || cookieCartItems.size() == 0){
			cookieCartItems = new ArrayList<CookieCartItem>();
		}
		CookieCartItem c = new CookieCartItem();
		c.setNum(1l);
		c.setBrandShowDetailId(bsdId);
		cookieCartItems.add(0,c);
		cookieCart = JSON.toJSONString(cookieCartItems);
		RequestUtils.setCookie(request, response, OrderConstants.COOKIE_CART, 
				cookieCart, OrderConstants.COOKIE_CART_PERIOD);
		return "/cart/tempCC";
	}
}
