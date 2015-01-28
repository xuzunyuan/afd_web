package com.afd.web.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.afd.common.util.CartTransferUtils;
import com.afd.constants.order.OrderConstants;
import com.afd.param.cart.Cart;
import com.afd.param.cart.CartItem;
import com.afd.service.order.ICartService;
import com.afd.service.product.IProductService;
import com.afd.web.service.impl.LoginServiceImpl;
import com.afd.param.cart.CookieCartItem;
import com.afd.common.util.RequestUtils;

@Controller
@RequestMapping("/cart")
public class CartController{
	private static final Logger log = LoggerFactory
			.getLogger(CartController.class);

	@Autowired
	private IProductService productService;
	@Autowired
	private ICartService cartService;

	private static final String cookie = "[{\"num\":2,\"selected\":false,\"skuId\":37},{\"num\":2,\"selected\":false,\"skuId\":29},{\"num\":2,\"selected\":false,\"skuId\":1},{\"num\":2,\"selected\":false,\"skuId\":40}]";

	/**
	 * 修改购物车商品数量
	 * 
	 * @param cookieCart
	 * @param skuId
	 * @param newQuantity
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/modify")
	public CartItem modifyQuantity(
			@CookieValue(value = "cart", required = false) String cookieCart,
			long bsDetailId, long newQuantity, long oldQuantity,
			HttpServletRequest request, HttpServletResponse response) {
		// 修改商品数量
		List<CartItem> cartItems = this.cartService.modifyQuantity(cookieCart, bsDetailId,
				newQuantity, oldQuantity);
		
		this.saveCart(
				CartTransferUtils.cartItemsToCookieCartItems(cartItems),
				request, response);
		CartItem cartItem = new CartItem();
		if (cartItems != null && cartItems.size() > 0) {
			for (CartItem ci : cartItems) {
				if (ci.getBrandShowDetailId().equals(bsDetailId)) {
					cartItem = ci;
				}
			}
		}

		return cartItem;
	}

	/**
	 * 展示购物车
	 * 
	 * @param cookieCart
	 * @param modelMap
	 * @param response
	 * @return
	 */
	@RequestMapping("/cartContent")
	public String showCart(
			@CookieValue(value = "cart", required = false) String cookieCart,
			ModelMap modelMap, HttpServletResponse response,
			HttpServletRequest request) {
		// 展示购物车
		List<Cart> carts = cartService.showCart(cookieCart);
		// 保存购物车
		saveCart(CartTransferUtils.cartToCookieCartItems(carts), request,
				response);
		// 将carts添加到模型中
		modelMap.addAttribute("carts", carts);
		boolean isEmpty = Boolean.parseBoolean(request.getParameter("isEmpty"));
		boolean hasError = Boolean.parseBoolean(request.getParameter("hasError"));
		// 是否没有选商品结算（用户点击结算按钮）
		modelMap.addAttribute("isEmpty", isEmpty);
		// 结算商品是否有错误（点击结算按钮）
		modelMap.addAttribute("hasError", hasError);
		return "cartContent";
	}

	/**
	 * 删除商品
	 * 
	 * @param cookieCart
	 * @param skuId
	 * @param response
	 * @return
	 */
	@RequestMapping("/delete")
	public String delete(
			@CookieValue(value = "cart", required = false) String cookieCart,
			HttpServletRequest request, Long bsDetailId, HttpServletResponse response) {
		if (bsDetailId != null && bsDetailId > 0) {
			Set<Long> bsDetailIds = new HashSet<Long>();
			bsDetailIds.add(bsDetailId);
			// 删除商品
			List<CartItem> cartItems = this.cartService.deleteCartItems(cookieCart, bsDetailIds);
			saveCart(
					CartTransferUtils.cartItemsToCookieCartItems(cartItems),
					request, response);
		}
		// 跳回购物车
		return "redirect:/cart/cartContent.action";
	}

	/**
	 * 删除选中商品
	 * 
	 * @param cookieCart
	 * @param skuIds
	 * @param response
	 * @return
	 */
	@RequestMapping("/deleteSelected")
	public String deleteSelected(
			@CookieValue(value = "cart", required = false) String cookieCart,
			HttpServletRequest request, @RequestParam("bsDetailIds") String bsDetailIds,
			HttpServletResponse response) {
		if (StringUtils.isNotBlank(bsDetailIds)) {
			Set<Long> setBsDetailIds = new HashSet<Long>();
			for (String bsDetailId : bsDetailIds.split(",")) {
				setBsDetailIds.add(Long.parseLong(bsDetailId));
			}
			// 批量删除商品
			List<CartItem> cartItems = this.cartService.deleteCartItems(cookieCart, setBsDetailIds);
			saveCart(
					CartTransferUtils.cartItemsToCookieCartItems(cartItems),
					request, response);
		}
		// 跳回购物车
		return "redirect:/cart/cartContent.action";
	}

	/**
	 * 清除失效商品
	 * 
	 * @param cookieCart
	 * @param response
	 * @return
	 */
	@RequestMapping("/clearFailure")
	public String clearFailure(
			@CookieValue(value = "cart", required = false) String cookieCart,
			HttpServletRequest request, HttpServletResponse response) {
		// 清除失效商品
		List<CartItem> cartItems = this.cartService.clearFailureProduct(cookieCart);
		this.saveCart(CartTransferUtils.cartItemsToCookieCartItems(cartItems),
				request, response);
		// 跳回购物车
		return "redirect:/cart/cartContent.action";
	}

	/**
	 * 验证结算商品(用于异步调用，返回json)
	 * 
	 * @param cookieCart
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/validCartConfirm")
	public String validCartConfirm(HttpServletRequest request,
			HttpServletResponse response,
			@CookieValue(value = "cart", required = false) String cookieCart) {
		// 将cookie转化成carts
		List<CartItem> cartItems = this.cartService.getCartItemsByCookie(cookieCart);
		// 选中的商品组合成购物车
		cartItems = this.cartService.filterSelectedCart(cartItems);
		Map<String, Boolean> rtnMap = new HashMap<String, Boolean>();
		// 设置结算商品是否为空
		if (cartItems.isEmpty()) {
			rtnMap.put("isEmpty", true);
		} else {
			rtnMap.put("isEmpty", false);
		}
		// 设置结算商品是否有误
		if (this.cartService.hasErrorOnSelectedCart(cartItems)) {
			rtnMap.put("hasError", true);
		} else {
			rtnMap.put("hasError", false);
		}
		// 返回json
		return JSON.toJSONString(rtnMap);
	}

	@RequestMapping("/chgChecked")
	public void chgChecked(
			@CookieValue(value = "cart", required = false) String cookieCart,
			@RequestParam String bsDetails, @RequestParam boolean checked,
			HttpServletRequest request, HttpServletResponse response) {
		Set<Long> setBsDetailsIds = new HashSet<Long>();
		for (String bsDetail : bsDetails.split(",")) {
			setBsDetailsIds.add(Long.parseLong(bsDetail));
		}
		List<CartItem> cartItems = this.cartService.chgChecked(cookieCart, setBsDetailsIds, checked);
		this.saveCart(CartTransferUtils.cartItemsToCookieCartItems(cartItems),
				request, response);
	}
	
	private void saveCart(List<CookieCartItem> combineCartItems,
			HttpServletRequest request,
			HttpServletResponse response
			){
		if(combineCartItems == null){
			combineCartItems = new ArrayList<CookieCartItem>();
		}
		RequestUtils.setCookie(request, response, OrderConstants.COOKIE_CART, 
					JSON.toJSONString(combineCartItems), OrderConstants.COOKIE_CART_PERIOD);
	}

}