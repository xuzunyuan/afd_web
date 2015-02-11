<!DOCTYPE html>
<html lang="zh-cn">
<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="../../common/common.jsp"%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>一网提交订单-支付失败</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/allstyle.min.css"/>
    <link rel="stylesheet" type="text/css" href="${cssDomain}/order.css"/>
    <script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
</head>
<body class="season season-winter">
	<div class="wrapper">
		<jsp:include page="/common/head.jsp" />
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- crumbs -->
				<div class="crumbs">
					<ul>
						<li><a href="http://www.yiwang.com">首页</a></li>
						<li><em>&gt;</em><a href="http://http://member.yiwang.com/user/center/">我的一网</a></li>
						<li><em>&gt;</em><a href="http://http://member.yiwang.com/trade/order/list/">我的订单</a></li>
						<li><em>&gt;</em>在线支付</li>
					</ul>
				</div>
				<!-- crumbs end -->
				<!-- cartList -->
				<div class="cartList">
					<div class="hd">
						<h2><i class="icon i-right"></i>订单提交成功</h2>
						<ul class="mod-step">
							<li class="first over">
								<i class="num">1</i>
								<p class="text">我的购物车</p>
							</li>
							<li class="over">
								<i class="num">2</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">确认订单信息</p>
							</li>
							<li class="last">
								<i class="num">3</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">成功提交订单</p>
							</li>
						</ul>
					</div>
					<div class="bd">
						<div class="orderState">
							<!-- submitState -->
							<dl class="order-submitState">
								<dt><i class="icon i-dangerLG"></i></dt>
								<dd>
									<h3>您的订单支付失败，请重新支付。</h3>
									<p>建议您：<a class="btn btn-primary lg" href="http://member.yiwang.com/trade/order/list/">去我的订单重新支付</a></p>
								</dd>
							</dl>
							<!-- submitState end -->
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