<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<title>个人中心-退货管理</title>
<link rel="stylesheet" type="text/css"
	href="${cssDomain}/css/allstyle.css" />
<link rel="stylesheet" type="text/css"
	href="${cssDomain}/css/member.css" />
<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
</head>
<body class="" id="shopCart">
	<div class="wrapper">
		<!-- topbar -->
		<jsp:include page="/common/head.jsp" />
		<!-- topbar end -->
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- breadnav -->
				<div class="breadnav">
					<span class="index"><a href="">首页</a></span>
					<ul class="nav">
						<li><span>&gt;</span><a href="">我的AFD</a></li>
						<li><span>&gt;</span><a href="">个人中心</a></li>
					</ul>
				</div>
				<!-- breadnav end -->
				<!-- memberCenter -->
				<div class="memberCenter">
					<!-- memb-sidebar -->
					<jsp:include page="/common/left.jsp" />
					<!-- memb-sidebar end-->
					<!-- main -->
					<div class="memb-main">
						<div class="memg-bd">
							<div class="myorder-hd">
								<table>
									<tbody>
										<tr>
											<th width="180">退货单信息</th>
											<th width="480">商品信息</th>
											<th width="180">卖家信息</th>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="myorder-bd">
								<c:forEach items="${retOrders}" var="retOrder">
									<div class="salereturnList">
										<table>
											<colgroup>
												<col width="200">
												<col width="440">
												<col width="200">
											</colgroup>
											<thead>
												<tr>
													<th colspan="3"><span>退货单编号：${retOrder.retOrderId}</span>
														<span>申请时间：<fmt:formatDate
																value="${retOrder.createDate}"
																pattern="yyyy-MM-dd HH:mm:ss" /></span></th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td>
														<p>
															<strong>状态：<c:out value="${retOrder.strStatus}" /></strong>
														</p>
														<p>
															退款金额：<span class="errTxt"><fmt:formatNumber
																	pattern="0.00"
																	value="${retOrder.retOrderItems[0].retFee}" />元</span>
														</p>
														<p>
															<input type="button" value="取消申请" class="btn btn-primary">
														</p>
														<p>
															<a href="#">查看详情</a>
														</p>
													</td>
													<td class="salemeg">
														<p class="ordernum">
															订单编号：<a href="#">${retOrder.orderId}</a>
														</p> 
														<c:forEach items="${retOrder.retOrderItems}" var="retOrderItem">
															<div>
																<dl class="mod-orderGoods">
																	<dt>
																		<a href="#" class="thumbnail"><img
																			src="img/temp/img4.jpg" alt=""></a>
																	</dt>
																	<dd>
																		<p class="title">
																			<a href="#"><c:out value="${retOrderItem.prodId}" /></a>
																		</p>
																	</dd>
																</dl>
																<span>${retOrderItem.returnNumber}</span> <span><fmt:formatNumber pattern="￥0.00" value="${retOrderItem.retFee}" /></span>
															</div>
														</c:forEach>
													</td>
													<td>
														<ul>
															<li><p>卖家姓名：潘金莲</p></li>
															<li><p>联系电话：12589458925</p></li>
															<li><p>QQ号码：25896148531</p></li>
														</ul>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</c:forEach>
							</div>
							<div class="pagingGroup">
								<!-- paging -->
								<div class="paging">
									<span class="pageup disabled"><i>&lt;&nbsp;</i>上一页</span>
									<ul>
										<li class="on"><a href="">1</a></li>
										<li><a href="">2</a></li>
										<li><a href="">3</a></li>
										<li><a href="">4</a></li>
										<li><span>...</span></li>
										<li><a href="">100</a></li>
									</ul>
									<span class="pagedown"><a href="">下一页<i>&nbsp;&gt;</i></a></span>
									<p class="goto">
										<span>到第</span><input type="text" name="" id="" class="input"><span>页</span>
										<button class="btn btn-def sm">确定</button>
									</p>
								</div>
								<!-- paging end -->
							</div>
						</div>
					</div>
					<!-- main end-->
				</div>
				<!-- memberCenter end-->
			</div>
		</div>
		<!-- container end -->
		<!-- footer -->
		<div id="footer">
			<div class="links">
				<a href="#" target="_blank">关于</a>| <a href="#" target="_blank">联系我们</a>|
				<a href="#" target="_blank">网站地图</a>| <a href="#" target="_blank">网站合作</a>|
				<a href="#" target="_blank">友情链接</a>| <a href="#" target="_blank">帮助中心</a>|
				<a href="#" target="_blank">版权声明</a>
			</div>
			<p class="copyright">Copyright &copy; 2013-2014 shop.com All
				Rights Reserved.</p>
		</div>
		<!-- footer end -->
	</div>
</body>
</html>
