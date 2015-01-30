<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="/common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>购物车</title>
</head>
<body>
	<c:choose>
		<c:when test="${carts == null || fn:length(carts) == 0 }">
			<script type="text/javascript">
// 				$("#footer").addClass("fixed");
			</script>
			<!-- orderState -->
			<div class="orderState">
				<!-- cart null -->
				<dl class="cartNull">
					<dt><img src="img/person.png" alt="" /></dt>
					<dd>
						<h3>购物车很空很伤心<br />主人，快点填充我空虚的内心吧...</h3>
						<p><a href="#">去首页逛逛 <em>&gt;</em></a></p>
					</dd>
				</dl>
			</div>
			<!-- orderState end -->
		</c:when>
		<c:otherwise>
			<div class="cartList-caption">
				<table>
					<tr>
						<td width="80" class="alloption"><label><input type="checkbox" class="chk" />全选</label></td>
						<td width="294">商品</td>
						<td width="170">规格</td>
						<td width="113">单元（元）</td>
						<td width="130">数量</td>
						<td width="113">小计（元）</td>
						<td width="100" class="last">操作</td>
					</tr>
				</table>
			</div>
			<c:forEach items="${carts }" var="cart" varStatus="var">
				<div class="cartList-group">
					<div class="caption">
						<input type="checkbox" class="chk" /><span>订单${var.count }：<c:out value="${cart.brandShowTitle }" /></span>
					</div>
					<c:forEach items="${cart.cartItems }" var="cartItem">
						<div class="row">
							<table>
								<colgroup>
									<col width="34" />
									<col width="340" />
									<col width="170" />
									<col width="113" />
									<col width="130" />
									<col width="113" />
									<col width="100" />
								</colgroup>
								<tbody>
									<tr>
										<td class="alloption"><input type="checkbox" class="chk" /></td>
										<td>
											<dl class="mod-orderGoods">
												<dt>
													<a href="#" class="thumbnail"><img src="${imgDomain }/${cartItem.prodImgUrl }" alt="" /></a>
												</dt>
												<dd>
													<p class="title"><a href="#"><c:out value="${cartItem.prodName }"/></a></p>
												</dd>
											</dl>
										</td>
										<td class="information">
											<div class="mod-goodsAttr">
												<div class="selectedAttr">
													<c:forEach items="${cartItem.specs }" var="spec">
														<p><c:out value="${spec.key}"/>：<span><c:out value="${spec.value }"/></span></p>
													</c:forEach>
												</div>
											</div>
										</td>
										<td>
											<p class="nowPrice"><fmt:formatNumber value="${cartItem.showPrice }" minFractionDigits="2" /></p>
											<p class="price"><fmt:formatNumber value="${cartItem.maketPrice }" minFractionDigits="2" /></p>
										</td>
										<td>
											<div class="mod-modified">
												<div class="minus disabled">-</div>
												<input type="text" class="txt sm" value="1">
												<div class="plus">+</div>
											</div>
											<div class="note numWarn"><span>限购<c:out value="${cartItem.purchaseCountLimit }"/>件</span></div>
										</td>
										<td>
											<p class="subtotal"><c:out value="${cartItem.showPrice * cartItem.num }"/></p>
										</td>
										<td class="operate">
											<p><a href="#">删除</a></p>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</c:forEach>
				</div>
			</c:forEach>
			<div class="cartList-group orderClosing">
				<div class="orderSubmit fixed">
					<div class="submit-box">
						<div class="func"><label><input type="checkbox" name="" class="chk">全选</label><span id="delAll">删除</span><span id="clear">消除失效商品</span></div>
					<a href="javascript:void(0)" class="btn btn-assist submitBtn">结&nbsp;算</a>
						<div class="priceTotal">总计：<span>¥<em>1592.00</em></span>元 （全场包邮）</div>
						<div class="thum">
							<p class="whole">已选商品<em>3</em>件</p>
						</div>
					</div>
				</div>
			</div>
		</c:otherwise>
	</c:choose>
</body>
</html>