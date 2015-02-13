<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="/common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>head</title>
	<script type="text/javascript" src="http://js.web.afdimg.com/jquery.min.js"></script>
	<script type="text/javascript" src="http://js.web.afdimg.com/jquery.cookie.js"></script>
	<script type="text/javascript" src="http://js.web.afdimg.com/login.js"></script>
	<script type="text/javascript">
		$(function(){
			var cartCookie = "";
			$(document).on("mouseover","div#shoppingCart",function(){
				if($(this).hasClass("hover")) {
					return;
				} else {
					$(this).addClass("hover");
				}
				var currCookie = getCookie("cart");
				if(cartCookie == currCookie) {
					return;
				} else {
					cartCookie = currCookie;
				}
				showMiniCart();
			});
			$(document).on("mouseout","div#shoppingCart",function(){
				$(this).removeClass("hover");
			});
		});
		function getCookie(c_name){
			if (document.cookie.length>0){
				c_start=document.cookie.indexOf(c_name + "=");
					if (c_start!=-1){
					c_start=c_start + c_name.length+1;
					c_end=document.cookie.indexOf(";",c_start);
					if (c_end==-1) c_end=document.cookie.length;
					return unescape(document.cookie.substring(c_start,c_end));
				}
			}
			return "";
	    }
		function showMiniCart() {
			$.post(
				"${ctx}/cart/miniCart.action",
				{},
				function(data){
					var cartData = $.parseJSON(data);
					var obj = $("div#shoppingCart div.bd");
					if(cartData.totalNum > 0) {
						var html = "<div class='shoppingList'>" + 
										"<div class='list'>";
						var carts = cartData.carts;
						for(var index in cartData.carts) {
							var cartItems = carts[index].cartItems;
							for(var index2 in cartItems) {
								var cartItem = cartItems[index2];
								html += "<dl>" + 
										  "<dt><a href='#'><img src='" + cartItem.prodImgUrl + "' alt='' /></a></dt>" +
										  "<dd class='goodsTitle'>" +
										  	"<p><a href='#' title=''>" + cartItem.prodName + "</a></p>" +
										  "</dd>" +
										  "<dd class='subtotal'>" +
										  	"<p><span class='price'>&yen;<strong>" + cartItem.showPrice.toFixed(2) + "</strong></span><em>x</em><span class='number'>" + cartItem.num + "</span></p>" +
										  	"<p><a href='javascript:delMiniCart(" + cartItem.brandShowDetailId + ");' >删除</a></p>" +
										  "</dd>" +
										"</dl>";
							}
						}
						html += "<a href='${ctx}/cart/cart.action' class='cart-more'>更多...</a>" + 
							"</div>" + 
							"<div class='summation'>" + 
								"<p class='total'>购物车里共有<em>" + cartData.totalNum + "</em>件商品，总计" +
									"<span class='priceTotal'>&yen;<strong>" + cartData.totalMoney + "</strong></span></p>" + 
								"<a href='${ctx}/cart/cart.action' class='btn btn-assist'>查看我的购物车</a>" + 
							"</div>" + 
						"</div>";
						obj.html(html);
					} else {
						var html = "<div class='shoppingCart-empty show'>" + 
										"<p>快去挑选喜欢的商品吧！</p>" +
									"</div>";
						obj.html(html);
					}
				}
			);
		}
		function delMiniCart(bsdid){
			$.post(
				"${ctx}/cart/delMiniCart.action",
				{bsdid:bsdid},
				showMiniCart
			);
		}
	</script>
</head>
<body>
	<!-- topbar -->
	<div id="topbar">
		<div class="wrap">
			<div id="siteNav">
				<dl class="noSubmenu">
					<dt class="hd"><a href="#">我的订单</a></dt>
				</dl>
				<dl class="myCenter">
					<dt class="hd"><a href="#">我的AFD<span class="arrow bottom-hollow xs"><b></b><i></i></span></a></dt>
				  	<dd class="bd">
				  		<ul>
				  		  <li><a href="#">已买商品</a></li>
				  		  <li><a href="#">我的足迹</a></li>
				  		  <li><a href="#">我的购物车</a></li>
				  		</ul>
				  	</dd>
				</dl>
				<dl class="noSubmenu">
			  		<dt class="hd"><a href="#">我是商家</a></dt>
			 		
				</dl>
			</div>
			<div class="signin">
				<span id="name">欢迎来到AFD！</span><span id="unLogin" class="hide">请<a href="#">登录</a><em>/</em><a href="#">免费注册</a></span><span id="login" ><a id="logout" href="#" class="quit">[退出]</a></span>
			</div>
		</div>
	</div>
	<!-- topbar end -->
	<!-- header -->
	<div id="header">
		<div class="wrap">
			<div id="logo">
				<div class="logo"><a href="#" title="logo"><img src="http://img.web.afdimg.com/logo.png" alt="logo"></a></div>
				<div class="slogan"><img src="http://img.web.afdimg.com/slogan.png"/></div>
			</div>
			<!-- shopping cart -->
			<div id="shoppingCart">
				<div class="cart">
					<a href="#">我的购物车<span class="arrow bottom-hollow"><b></b><i></i></span></a>
				</div>
				<div class="bd">
				</div>
			</div>
			<div id="safeguard"><img src="http://img.web.afdimg.com/safeguard.jpg"/></div>
		</div>
	</div>
	<!-- header end -->
</body>
</html>