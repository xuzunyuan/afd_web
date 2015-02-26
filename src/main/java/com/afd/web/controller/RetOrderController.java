package com.afd.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.afd.common.util.RequestUtils;
import com.afd.constants.order.OrderConstants;
import com.afd.model.order.OrderItem;
import com.afd.model.order.ReturnOrder;
import com.afd.model.seller.Seller;
import com.afd.service.order.IOrderService;
import com.afd.service.order.IRetOrderService;
import com.afd.service.seller.ISellerService;
import com.afd.web.service.impl.LoginServiceImpl;

@Controller
@RequestMapping("/retOrder")
public class RetOrderController {
	@Autowired
	private IRetOrderService retOrderService;
	@Autowired
	private IOrderService orderService;
	@Autowired
	private ISellerService sellerService;
	
	@RequestMapping("/myRetOrders")
	public String myRetOrders(HttpServletRequest request,ModelMap map){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		List<ReturnOrder> retOrders = this.retOrderService.getRetOrdersByUserId(Long.parseLong(userId));
		map.addAttribute("retOrders", retOrders);
		return "retOrder/myRetOrders";
	}
	
	@RequestMapping("/retOrderApply")
	public String retOrderApply(@RequestParam Long orderItemId,HttpServletRequest request,ModelMap map){
		OrderItem orderItem = this.orderService.getOrderItemById(orderItemId);
		if(orderItem==null){
			return "redirect:http://www.afd.com";
		}
		Long sellerId = orderItem.getOrder().getSellerId();
		Seller seller = this.sellerService.getSellerById(sellerId.intValue());
		
		map.addAttribute("orderItem", orderItem);
		map.addAttribute("seller", seller);
		return "retOrder/retOrderApply";
	}
	
	@RequestMapping("/formApply")
	public String formApply(ReturnOrder retOrder,HttpServletRequest request){
		String uid = LoginServiceImpl.getUserIdByCookie(request);
		String ip = RequestUtils.getRemoteAddr(request);
		retOrder.setCreateIp(ip);
		retOrder.setStatus(OrderConstants.order_return_wait);
		retOrder.setUserId(Long.parseLong(uid));
		retOrder.setReturnType(OrderConstants.ORDER_RETURN_TYPE_PART);
		this.retOrderService.addRetOrder(retOrder);
		
		return "redirect:/retOrder/myRetOrders.action";
	}
	
	
}
