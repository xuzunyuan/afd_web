<%@include file="/common/common.jsp" %>
<c:if test="${pageno==1}">
<script type="text/javascript">
totalpages=${pagetotal};
</script>
</c:if>
<c:if test="${!empty showdetails}">
<c:forEach items="${showdetails}" var="detail" varStatus="status">
<div class="mod-activegoods">
						<a href="${ctx}/detail.action?bsdid=${detail.bSDId}">
						<div class="g-m">
						    <c:if test ="${!empty detail.prodImg}">									
									<img src="${my:random(imgGetUrl)}?rid=${detail.prodImg}"/>
							</c:if>
							<c:if test ="${empty detail.prodImg}">									
									<img src="${imgDomain}/temp/active-good.jpg" alt="">
							</c:if>
							<!--  div class="g-img">
								<img src="${imgDomain}/temp/active-good.jpg" alt="prodImg"-->
							</div>
							<div class="g-info">
								<div class="hd">
									<span>${detail.prodTitle}</span>
								</div>
								<div class="bd">
									<div class="price">
									<c:set value="${ fn:split(detail.showPrice, '.') }" var="prices" />
										<p class="nowPrice"><span>￥</span>${prices[0]}.<span>${prices[1]}</span></p>
										<p class="befPrice">原价：${detail.showPrice}</p>
									</div>
									<div class="onbuy"><a href="#"><img src="${imgDomain}/onbuy.png" alt=""></a></div>
								</div>
							</div>
						</div>
						</a>
</div>
</c:forEach>
</c:if>