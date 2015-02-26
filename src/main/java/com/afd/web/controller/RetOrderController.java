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
import com.afd.model.order.Order;
import com.afd.model.order.OrderItem;
import com.afd.model.order.ReturnOrder;
import com.afd.model.order.ReturnOrderItem;
import com.afd.model.product.BrandShow;
import com.afd.model.product.Product;
import com.afd.model.product.Sku;
import com.afd.model.seller.Seller;
import com.afd.model.seller.SellerLogin;
import com.afd.model.seller.SellerRetAddress;
import com.afd.service.order.IOrderService;
import com.afd.service.order.IRetOrderService;
import com.afd.service.product.IBrandShowService;
import com.afd.service.product.IProductService;
import com.afd.service.seller.ISellerLoginService;
import com.afd.service.seller.ISellerService;
import com.afd.web.service.impl.LoginServiceImpl;
import com.alibaba.dubbo.common.utils.StringUtils;

@Controller
@RequestMapping("/retOrder")
public class RetOrderController {
	@Autowired
	private IRetOrderService retOrderService;
	@Autowired
	private IOrderService orderService;
	@Autowired
	private ISellerService sellerService;
	@Autowired
	private ISellerLoginService sellerLoginService;
	@Autowired
	private IBrandShowService brandShowService;
	@Autowired
	private IProductService   productService;
	
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
	
	public String formApply(ReturnOrder retOrder,HttpServletRequest request){
		String uid = LoginServiceImpl.getUserIdByCookie(request);
		String ip = RequestUtils.getRemoteAddr(request);
		retOrder.setCreateIp(ip);
		retOrder.setStatus(OrderConstants.order_return_wait);
		retOrder.setUserId(Long.parseLong(uid));
		this.retOrderService.addRetOrder(retOrder);
		
		
		
		return "redirect:/retOrder/myRetOrders.action";
	}
	
	@RequestMapping("/myRetDetail")
	public String myRetDetail(@RequestParam Integer myRetId,HttpServletRequest request,ModelMap map){
		ReturnOrder returnOrder = this.retOrderService.getRetOrderByRetOrderId(myRetId);
		if(returnOrder==null){
			return "redirect:http://www.afd.com";
		}
		Long orderId = returnOrder.getOrderId();
		List<ReturnOrderItem> retOrderItems = returnOrder.getRetOrderItems();
		ReturnOrderItem retOrderItem=retOrderItems.get(0);
		map.addAttribute("retOrderItem", retOrderItem);
		Order order = this.orderService.getOrderById(orderId);
		if(retOrderItem==null){
			return "redirect:http://www.afd.com";
		}
		Long skuId = retOrderItem.getSkuId();
		Sku sku = this.productService.getSkuById(skuId.intValue());
		if(sku==null){
			return "redirect:http://www.afd.com";
		}
		String specNames = sku.getSkuSpecName();
		String specHtml=this.getSpecStr(specNames);
		map.addAttribute("specHtml", specHtml);
		Integer prodId = sku.getProdId();
		Product prod = this.productService.getProductById(prodId);
		map.addAttribute("prod", prod);
		map.addAttribute("sku", sku);
		Long bsid = order.getBrandShowId();
		BrandShow brandShow = this.brandShowService.getBrandShowById(bsid.intValue());
		if(brandShow==null){
			return "redirect:http://www.afd.com";
		}
		map.addAttribute("brandShow", brandShow);
		Long sellerId = returnOrder.getSellerId();
		Seller seller = this.sellerService.getSellerById(sellerId.intValue());
		if(seller==null){
			return "redirect:http://www.afd.com";
		}
		SellerLogin loginInfo = this.sellerLoginService.getLoginById(seller.getSellerLoginId());
		map.addAttribute("login", loginInfo);
		SellerRetAddress sellerRetAddress= new SellerRetAddress();//todo
		map.addAttribute("retAddress", sellerRetAddress);
		map.addAttribute("returnOrder", returnOrder);
		
		return "retOrder/myRetDetail";
	}
	
	private String getSpecStr(String specNames) {
		String str="";
		if (!StringUtils.isBlank(specNames)) {
			String[] names = specNames.split("\\|\\|\\|");			
				for(int i = 0;i<names.length;i++){
					String name = names[i];					
					String[] opt_name = name.split("\\:\\:\\:");
					str+="<p>"+opt_name[0]+":<span>"+opt_name[1]+"</span>"+"</p>";				
				}
			}
      return str;
	}
}
