<!DOCTYPE html>
<html lang="zh-cn">
<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/common/common.jsp"%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>一网提交订单-订单支付</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/allstyle.min.css"/>
    <link rel="stylesheet" type="text/css" href="${cssDomain}/order.css"/>
    <script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
    <script type="text/javascript" src="${jsDomain}/jquery.cookie.js"></script>
	<script type="text/javascript">
	var paymode='${payMode}';
	var payurl="${payurl}";
	function togglebank(){
		 $("#selectbankdiv").toggleClass("selected");
	}	
	function chosebank(obj){
		$("#selectedbank").find("img").attr("src",""+$(obj).next("img").attr("src"));
		$("#selectbankdiv").toggleClass("selected");
	};
	
	function paysubmit(){
		
		var paymode_sel=$("input[type=radio][name=payMode]:checked").val();
		if(paymode_sel=="20"){
			payurl="${paydomain}/alipay/pay?a=${paymentId}&b=${total}"
		}
		if(paymode_sel=="1z"){
			payurl="${paydomain}/unionpay/pay?a=${paymentId}&b=${total}&c=";
		}
		var get_char = paymode_sel.charAt(0);
		if(paymode_sel!="1z"&&get_char=="1"){
			payurl="${paydomain}/unionpay/pay?a=${paymentId}&b=${total}&c="+paymode_sel;
		}
		$("#maskdiv").show();
		$("#showdiv").show();
		window.open(payurl,"payment");	
	}
	$(function(){	
		
		if(paymode=="20"){
			
			$("#selectedbank").find("img").attr("src","${imgDomain}/pay/alipay1.jpg");
			$("#selectedbank").show();
			$("#banktip").hide();
		}
		if(paymode=="1z"){
			$("#selectedbank").find("img").attr("src","${imgDomain}/pay/unionpay1.jpg");
			$("#selectedbank").show();
			$("#banktip").hide();
		}
		var get_char = paymode.charAt(0);
		if(paymode!="1z"&&get_char=="1"){
			var bankimg=$("input[type=radio][name=payMode][value="+paymode+"]").next("img").attr("src");
			$("#selectedbank").find("img").attr("src",bankimg);
			$("#selectedbank").show();
			$("#banktip").show();			
        }
		$("input[type=radio][name=payMode][value="+paymode+"]").prop("checked", true);
	});

</script>
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
						<li><em>&gt;</em><a href="http://member.yiwang.com/user/center/">我的一网</a></li>
						<li><em>&gt;</em><a href="http://member.yiwang.com/trade/order/list/">我的订单</a></li>
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
							<li class="over">
								<i class="num">3</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">成功提交订单</p>
							</li>
						</ul>
					</div>
					<div class="bd">
						<div class="orderState payState">
							<!-- submitState -->
							<dl class="order-submitState">
								<dt><i class="icon i-dangerLG"></i></dt>
								<dd>
									<h3>您的订单已经成功提交，请尽快付款</h3>
									<p>为了保证及时处理掉您的订单，请于下单<em>24小时内</em>付款，逾期未付款订单将被取消，需重新下单。</p>
									<p class="lightColor">使用您的手机号码登录网站，可以查看订单状态和货品配送情况。</p>
								</dd>
							</dl>
							<!-- submitState end -->
							<div class="aside">
								<p class="orderTotal">应付款：<span>&yen;<em><fmt:formatNumber value="${total}" pattern="0.00" /></em></span></p>
								<div class="orderNumber">
								    <c:if test="${ordernums > 1}">
								     <span>共<b>${ordernums}</b>笔订单</span><!--如果只有一个订单，则隐藏该行-->
							        </c:if>
							        <c:if test="${ordernums == 1}">
								     <span>订单编号：${orderlist[0].orderId}</span><!--如果只果有一个订单，订单编号在此处显示-->
							        </c:if>
									<!-- orderDetails -->
									<dl class="orderDetails">
										<dt><a href="javascript:void(0)" class="btn btn-def lg">订单详情<i class="arrow bottom-solid sm muted"></i></a></dt>
										
										<dd>
											<ul class="orderList">
										<c:forEach items="${orderlist}" var="order" varStatus="status">
												<li class='item  <c:if test="${status.last}">last</c:if>'>
													<table>
														<colgroup>
															<col width="375" />
															<col width="85" />
															<col width="150" />
														</colgroup>
														<caption><span><b>订单${status.count}：<c:out value="${order.storeName}"></c:out></b></span><c:if test="${ordernums > 1}"><span>订单编号：<c:out value="${order.orderId}"></c:out></span></c:if><span class="otherPrice">快递费：<fmt:formatNumber value="${order.deliverFee}" pattern="0.00" /></span></caption>
														<tbody>
											 <c:forEach items="${order.orderItems}" var="orderitem">	
													<tr>
														<th><p><c:out value="${orderitem.prodTitle}"></c:out></p></th>
														<td>数量：${orderitem.num}</td>
														<td>交易金额：<fmt:formatNumber value="${orderitem.transPrice*orderitem.num}" pattern="0.00" /></td>
													</tr>
											   </c:forEach>
														</tbody>
													</table>
												</li>
											</c:forEach>
											</ul>
										</dd>
									</dl>
									<!-- orderDetails end -->
								</div>
							</div>
						</div>
						<!-- orderPay -->
						<div class="orderPay">
							<div class="wrap">
								<div class="hd"><h3>网银支付</h3></div>
								<div class="bd">
									<div id="selectbankdiv" class="pay-ebank selected"><!--选择支付方式后加class  "selected"-->
										<div class="whichEbank">
											<p id="selectedpayMode" class="selectedMode"><em>支付方式：</em><span class="ico" id="selectedbank" style="display:none"><img src=""  alt="" /></span><span class="hint1">请选择适合您的在线支付方式</span><span id="banktip" class="hint2">付款时需跳转至银行支付</span></p>
											<p class="editPayMode"><a href="javascript:void(0)" onclick="togglebank();">修改在线付款方式</a></p>
										</div>
										<div class="ebankList">
											<span class="arrow top-hollow lg"><b></b><i></i></span>
											<dl class="item">
												<dt>支付平台：</dt>
												<dd>
													<div class="bank-item"><label><input type="radio" class="radio"  id="zhi" name="payMode" value="20" onclick="chosebank(this)"><img src="${imgDomain}/pay/alipay1.jpg" alt=""></label></div>
													<div class="bank-item"><label><input type="radio" class="radio"  id="yin" name="payMode" value="1z" onclick="chosebank(this)"><img src="${imgDomain}/pay/unionpay1.jpg" alt=""></label></div>
												</dd>
											</dl>
											<dl class="item">
												<dt>支付平台：</dt>
												<dd>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="10" onclick="chosebank(this)"/><img src="${imgDomain}/pay/icbc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="11" onclick="chosebank(this)"/><img src="${imgDomain}/pay/abc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="12" onclick="chosebank(this)"/><img src="${imgDomain}/pay/boc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="13" onclick="chosebank(this)"/><img src="${imgDomain}/pay/cbc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="14" onclick="chosebank(this)"/><img src="${imgDomain}/pay/ctb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="15" onclick="chosebank(this)"/><img src="${imgDomain}/pay/cmb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="16" onclick="chosebank(this)"/><img src="${imgDomain}/pay/ceb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="17" onclick="chosebank(this)"/><img src="${imgDomain}/pay/citic.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="18" onclick="chosebank(this)"/><img src="${imgDomain}/pay/cmbc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="1a" onclick="chosebank(this)"/><img src="${imgDomain}/pay/hxb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="1b" onclick="chosebank(this)"/><img src="${imgDomain}/pay/cgb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="1c" onclick="chosebank(this)"/><img src="${imgDomain}/pay/spdb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="1d" onclick="chosebank(this)"/><img src="${imgDomain}/pay/cib.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="1e" onclick="chosebank(this)"/><img src="${imgDomain}/pay/psbc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="payMode"  value="1f" onclick="chosebank(this)"/><img src="${imgDomain}/pay/bea.jpg" alt="" /></label></div>
												</dd>
											</dl>
										</div>
									</div>
									<p class="payPrice">支付金额：<b><fmt:formatNumber value="${total}" pattern="0.00" /></b>元</p>
									<p class="payBtn"><a  href="javascript:void(0)" onclick="paysubmit()" class="btn btn-primary">确认支付</a></p>
								</div>
							</div>
						</div>
						<!-- orderPay end -->
					</div>
				</div>
				<!-- cartList end -->
			</div>
		</div>
		<!-- container end -->
		<jsp:include page="/common/foot.html" />
	</div>
	<!-- pop -->
		<div id="showdiv" style="display:none" class="popup pop-pay">
		<div class="hd">
			<h2>登录网上银行付款</h2>
			<i title="关闭" class="close" onclick="$('#showdiv').hide();$('#maskdiv').hide();"></i>
		</div>
		<div class="bd">
			<h4>请在新开的网银页面完成付款后选择：</h4>
			<p><i class="icon i-rightSM"></i><b>付款成功：</b><span>您可以：<a href="/cart.jsp">返回购物车继续购物</a><a href="http://member.yiwang.com/trade/order/list/">查看订单</a></span></p>
			<p><i class="icon i-graveSM""></i><b>付款失败：</b><span>建议您：<a href="javascript:void(0)" onclick="$('#showdiv').hide();$('#maskdiv').hide();">重新支付</a><a href="javascript:void(0)" onclick="$('#showdiv').hide();$('#maskdiv').hide();$('#selectbankdiv').addClass('on');">更改支付方式</a></span></p>
		</div>
	</div>
	<!-- popup end -->
	<div id="maskdiv" class="mask" style="display:none"></div>
</body>
</html>
