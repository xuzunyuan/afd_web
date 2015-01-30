<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="/common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>购物车</title>
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript" src="${jsDomain}/jquery.cookie.js"></script>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/order.css"/>
	<script type="text/javascript">
		$(function(){
			$.cookie("tradesubmit", null, {
				expires : -1
			});
			$("div.cart-show").load("${ctx}/cart/cartContent.action?dt=" + new Date().getTime());
		});
		</script>
</head>
<body id="shopCart">
	<div class="wrapper">
		<jsp:include page="/common/head.html" />
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- cartList -->
				<div class="cartList">
					<div class="hd">
						<h2><i class="icon i-cart"></i>我的购物车</h2>
						<ul class="mod-step">
							<li class="first now">
								<i class="num">1</i>
								<p class="text">购物车</p>
							</li>
							<li class="">
								<i class="num">2</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">确认订单</p>
							</li>
							<li class="">
								<i class="num">2</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">在线支付</p>
							</li>
							<li class="last">
								<i class="num">3</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">完成</p>
							</li>
						</ul>
					</div>
					<div class="bd cart-show">
						<!-- orderState -->
						<div class="orderState">
							<!-- cart loading -->
							<div class="cartLoading">
								<img src="img/load.gif" alt="" />
								<h3>加载中...若页面长时间不显示商品</h3>
								<p><a href="#">点击刷新 </a></p>
							</div>
							<!-- cart loading end -->
						</div>
					</div>
				</div>
				<!-- cartList end -->
			</div>
		</div>
		<!-- container end -->
		<jsp:include page="/common/foot.html" />
	</div>
</body>
</html>