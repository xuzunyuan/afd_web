package com.afd.web.controller;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.afd.common.mybatis.Page;
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
import com.alibaba.fastjson.JSON;

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
	public String myRetOrders(HttpServletRequest request,ModelMap map,Page<ReturnOrder> page){
		page.setPageSize(10);
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		page = this.retOrderService.getRetOrdersByUserId(Long.parseLong(userId),page);
		map.addAttribute("retOrders", page.getResult());
		map.addAttribute("page", page);
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
	public String formApply(ReturnOrder retOrder,HttpServletRequest request,@RequestParam List<String> imgs){
		String uid = LoginServiceImpl.getUserIdByCookie(request);
		String ip = RequestUtils.getRemoteAddr(request);
		retOrder.setCreateIp(ip);
		retOrder.setStatus(OrderConstants.order_return_wait);
		retOrder.setUserId(Long.parseLong(uid));
		retOrder.setReturnType(OrderConstants.ORDER_RETURN_TYPE_PART);
		if(imgs!=null&&imgs.size()>0){
			StringBuilder imgUrl = new StringBuilder();
			int i = 0;
			for(String img : imgs){
				if(i==0){
					imgUrl.append(img);
				}else{
					imgUrl.append(",").append(img);
				}
				i++;
			}
			retOrder.setEvidencePicUrl(imgUrl.toString());
		}
		this.retOrderService.addRetOrder(retOrder);
		
		return "redirect:/retOrder/myRetOrders.action";
	}
	
	@RequestMapping("/myRetDetail")
	public String myRetDetail(@RequestParam Long myRetId,HttpServletRequest request,ModelMap map){
		Page<ReturnOrder> page=new Page<ReturnOrder>();
		page.setPageSize(1);
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		page = this.retOrderService.getRetOrdersByUserId(Long.parseLong(userId),page);
		ReturnOrder returnOrder = page.getResult().get(0);
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
		List<OrderItem> orderItems= this.orderService.getOrderItemsByOrderId(orderId.intValue());
		Long skuId = retOrderItem.getSkuId();
		Sku sku = this.productService.getSkuById(skuId.intValue());
		map.addAttribute("sku", sku);
		OrderItem orderItemCopy = null;
		for(OrderItem oi : orderItems ){
			if(oi.getSkuId().compareTo(skuId)==0){
				orderItemCopy=oi;
				break;
			}
		}
		if(orderItemCopy==null){
			return "redirect:http://www.afd.com";
		}
		Map<String, String> specMap = orderItemCopy.getSpecNames();		
		String specHtml=this.getSpecStr(specMap);
		map.addAttribute("specMap", specMap);
		map.addAttribute("specHtml", specHtml);
		Long prodId = orderItemCopy.getProdId();
		Product prod = this.productService.getProductById(prodId.intValue());
		map.addAttribute("orderItem", orderItemCopy);
		map.addAttribute("prod", prod);
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
		Integer sRAId = brandShow.getsRAId();
		SellerRetAddress retAddress=null;
		if(sRAId!=null){
			retAddress=this.sellerService.getSellerRetAddress(sRAId);
		}
		map.addAttribute("retAddress", retAddress);
		map.addAttribute("returnOrder", returnOrder);
		if(returnOrder.getStatus().equals(OrderConstants.order_return_cancel)){
			//return "retOrder/myRetCancel";
		}
		return "retOrder/myRetDetail";
	}
	
	@RequestMapping("/cancelRetOrder")
	public String cancelRetOrder(@RequestParam Long myRetId,HttpServletRequest request,ModelMap map){
		ReturnOrder returnOrder = this.retOrderService.getRetOrderByRetOrderId(myRetId);
		if(returnOrder==null||!returnOrder.getStatus().equals("1")){
			return "redirect:http://www.afd.com";
		}
		String uid = LoginServiceImpl.getUserIdByCookie(request);
		int ret=this.retOrderService.cancelRetOrderById(myRetId,Long.parseLong(uid));
		if(ret<1){
			return "redirect:http://www.afd.com";
		}
		return "redirect:/retOrder/myRetDetail.action?myRetId="+myRetId;
	}
	
	private String getSpecStr(Map<String, String> specMaps) {
		String str="";
		Iterator<Entry<String, String>> iter = specMaps.entrySet().iterator();
		while (iter.hasNext()) {
		Entry<String, String> entry = iter.next();
		String key = entry.getKey();
		String val = entry.getValue();
		str+="<p>"+key+":<span>"+val+"</span>"+"</p>";
		}	
      return str;
	}
	
	@ResponseBody
	@RequestMapping("/cancelRetOrder")
	public String cancelRetOrder(HttpServletRequest request,@RequestParam Long retOrderId){
		String uid = LoginServiceImpl.getUserIdByCookie(request);
		this.retOrderService.cancelRetOrderById(retOrderId,Long.parseLong(uid));
		Map<String,Boolean> map = new HashMap<String,Boolean>();
		map.put("status", true);
		return JSON.toJSONString(map);
	}
}
