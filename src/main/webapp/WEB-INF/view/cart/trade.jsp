<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="/common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>结算</title>
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript" src="${jsDomain}/jquery.cookie.js"></script>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/order.css"/>
	<script type="text/javascript">
		$(function(){
			$.post(
				"${ctx}/getAddr.action",
				{},
				function(data){
					var addrs = $.parseJSON(data);
					if(addrs.length > 0){
						$("div.shippingAddr").removeClass("noAddress");
						displayAddrs(addrs);
					} else {
						$("div.shippingAddr").addClass("noAddress");
					}
				}
			);
			$("div.pro-mod").load("${ctx}/tradeGoods.action");
		});
		function displayAddrs(addrs) {
			var htmlStr = "";
			for (var addr in addrs) {
				htmlStr += getaddrhtml(addr);
			}
			$("div.addressList ul").html(htmlStr);
		}
		function getaddrhtml(addr){
			var str = "<li class='addr-item'>" + 
				"<label>";
			if("1" == addr.isDefault) {
				str += "<input type='radio' class='radio' name='payMode' selected>" +
				"<span class='defAddr'>默认地址</span>";
			} else {
				str += "<input type='radio' class='radio' name='payMode'>";
			}
			str += "<span>" + addr.receiver + "</span>" +
					"<span>" + addr.provinceName + addr.cityName + addr.districtName + addr.townName + addr.addr + "</span>" +
					"<span>" + addr.mobile + "</span>" +
				"</label>" +
				"<span class='setlink'><a href='#'>修改</a><a href='#'>删除</a></span>" +
			"</li>";
			return str;
		}
	</script>
</head>
<body>
	<div class="wrapper">
		<jsp:include page="/common/head.html" />
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- cartList -->
				<div class="cartList">
					<div class="hd">
						<h2><i class="icon i-menu"></i>确认订单</h2>
						<ul class="mod-step">
							<li class="first over">
								<i class="num">1</i>
								<p class="text">购物车</p>
							</li>
							<li class="now">
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
					<div class="bd">
						<div class="shippingAddr noAddress"><!--给shippingAddr添加class 'unfold'以展开全部地址,第一次添加地址class加 'noAddress'-->
							<div class="wrap">
								<div class="hd"><h3>收货地址</h3><span>新增收货地址</span></div>
								<div class="bd">
									<div class="shippingForm">
										<form class="form">
											<fieldset>
												<div class="lenged">收货人信息</div>
												<div class="formGroup">
													<div class="form-item">
														<div class="item-label"><label><em>*</em>收货地址：</label></div>
														<div class="item-cont">
															<input type="text" class="txt lg w-xl"><span class="note errTxt">错误信息</span>
														</div>
													</div>
													<div class="form-item">
														<div class="item-label"><label><em>*</em>详细地址：</label></div>
														<div class="item-cont">
															<textarea name="" id="" style="width: 288px;height: 72px" class="resize-none" placeholder="不用重复填写省市区，不超过60个字"></textarea>
														</div>
													</div>
													<div class="form-item">
														<div class="item-label"><label>邮政编码：</label></div>
														<div class="item-cont">
															<input type="text" class="txt lg w-xl">
														</div>
													</div>
													<div class="form-item">
														<div class="item-label"><label><em>*</em>收货人：</label></div>
														<div class="item-cont">
															<input type="text" class="txt lg w-xl" placeholder="不超过15个字">
														</div>
													</div>
													<div class="form-item">
														<div class="item-label"><label><em>*</em>手机号码：</label></div>
														<div class="item-cont">
															<input type="text" class="txt lg w-xl" placeholder="11位手机号码"><label class="or">或</label><label class="fixedTel">固定电话：</label><div class="txt-tel"><input type="text" class="txt telArea"><i>-</i><input type="text" class="txt telNum"><i>-</i><input type="text" class="txt telExt"></div>
														</div>
													</div>
												</div>
												<div class="formGroup">
													<div class="form-item">
														<div class="item-cont">
															<label><input type="checkbox" class="chk">设置为默认发货地址</label>
														</div>
													</div>
													<div class="form-item">
														<div class="item-cont">
															<input type="button" class="btn btn-primary" value="保存收货人信息">
														</div>
													</div>
												</div>
											</fieldset>
										</form>
									</div>
									<div class="addressList">
										<ul> </ul>
									</div>
									<div class="addrMore"><span class="btn btn-def more">其他收货地址<span class="arrow bottom-hollow"><b></b><i></i></span></span></div>
									<div class="btnWrap"><a href="javascript:;" class="btn btn-assist p-lg">+ 使用新地址</a></div>
								</div>
							</div>
						</div>
						<!-- pay mode -->
						<div class="payMode">
							<div class="wrap">
								<div class="hd"><h3>支付方式</h3></div>
								<div class="bd">
									<dl class="pay-item">
										<dt><label><input type="radio" class="radio" disabled="disabled" name="payMode" />支付宝在线付款</label></dt>
										<dd><span class="ico alipay"><img src="img/pay/alipay.jpg" alt="" /></span>使用支付宝账号在线付款。</dd>
									</dl>
									<dl class="pay-item selected">
										<dt><label><input type="radio" class="radio" name="payMode" />网上银行在线付款</label></dt>
										<dd>
											<span class="ico checkedBank"><img src="img/pay/jinlin.jpg"/></span><dl class="mod-banks"><!-- 鼠标移上加class=hover -->
												<dt><span class="btn btn-def">选择支付银行<i class="arrow bottom-solid sm muted"></i></span></dt>
												<dd>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/icbc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/abc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/boc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/cbc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/ctb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/cmb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/ceb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/citic.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/cmbc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/sdb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/hxb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/cgb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/spdb.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/cib.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/psbc.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" /><img src="img/pay/bea.jpg" alt="" /></label></div>
													<div class="bank-item"><label><input type="radio" class="radio" name="banks" id="" value="" checked="checked" /><img src="img/pay/jinlin.jpg" alt="" /></label></div>
												</dd>
											</dl>使用您的网上银行借记卡及部分银行信用卡进行支付。
										</dd>
									</dl>
								</div>
							</div>
						</div>
						<!-- pay mode end -->
						<div class="pro-mod">加载中。。。。</div>
						<!-- order submit -->
						<div class="orderSubmit">
							<div class="submit-box">
								<div class="shippingInfo"><b>收货信息：</b><span class="warnColor">尚未选择收获信息</span><span>吴震亮</span><span class="address">北京市东城区朝内银河SOHO B座 20309室</span><span>13013131313</span></div>
								<div class="priceTotal payTotal"><b>实付金额：</b><span>&yen;<em>3184.00</em></span></div>
								<div class="checkedPay"><b>支付方式：</b><span>支付宝</span></div>
							</div>
							<a href="javascript:void(0)" class="btn btn-primary submitBtn">提交订单</a>
						</div>
						<!-- order submit end -->
					</div>
				</div>
				<!-- cartList end -->
			</div>
		</div>
		<jsp:include page="/common/foot.html" />
	</div>
</body>
</html>