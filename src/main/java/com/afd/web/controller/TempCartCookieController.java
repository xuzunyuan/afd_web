package com.afd.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.afd.common.util.RequestUtils;
import com.afd.constants.order.OrderConstants;

@Controller
@RequestMapping("/temp")
public class TempCartCookieController {
	
	@RequestMapping("/addcart")
	public String cartCookie() {
		return "/cart/tempCC";
	}
	
	@RequestMapping("/addCartCookie")
	public String addCartCookie(@RequestParam("bsdId") Long bsdId, HttpServletRequest request, HttpServletResponse response) {
		String cookie = "[{\"num\":1,\"selected\":true,\"brandShowDetailId\":" + bsdId + "}]";
		RequestUtils.setCookie(request, response, OrderConstants.COOKIE_CART, 
				cookie, OrderConstants.COOKIE_CART_PERIOD);
		return "/cart/tempCC";
	}
}
