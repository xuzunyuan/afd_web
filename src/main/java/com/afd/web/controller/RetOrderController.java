package com.afd.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.afd.model.order.ReturnOrder;
import com.afd.service.order.IRetOrderService;
import com.afd.web.service.impl.LoginServiceImpl;

@Controller
@RequestMapping("/retOrder")
public class RetOrderController {
	@Autowired
	private IRetOrderService retOrderService;
	
	@RequestMapping("/myRetOrders")
	public String myRetOrders(HttpServletRequest request,ModelMap map){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		List<ReturnOrder> retOrders = this.retOrderService.getRetOrdersByUserId(Long.parseLong(userId));
		map.addAttribute("retOrders", retOrders);
		return "retOrder/myRetOrders";
	}
}
