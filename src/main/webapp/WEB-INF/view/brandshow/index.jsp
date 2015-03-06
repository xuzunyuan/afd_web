<%@include file="/common/common.jsp" %>
<c:if test="${!empty showlist}">
 <c:forEach items="${showlist}" var="show" varStatus="status">
 <div class="mod-goodsShow">
							<a href="${ctx}/brandshow.action?bsid=${show.brandShowId}">
								<div class="g-info">
			
									<c:if test ="${!empty show.homeBannerImg}">									
									<img src="${my:random(imgGetUrl)}?rid=${show.homeBannerImg}" alt="" />
									</c:if>
									<c:if test ="${empty show.homeBannerImg}">
									<img src="${imgDomain}/temp/img7.jpg" alt="" />
									</c:if>
									<p class="g-text">${show.title}</p>
									<p class="g-price">${show.lowestPrice}<em>元起</em></p>
									<p class="g-time" gtimeid="${status.index + 1}" endtime="${show.endDate}">剩余时间：
									<span style="display:none" id="year${status.index + 1}">35</span>
                                    <span style="display:none" id="month${status.index + 1}">05</span>
                                    <span id="day${status.index + 1}">29</span>天
                                    <span id="hour${status.index + 1}">21</span>时
                                    <span id="mini${status.index + 1}">27</span>分
                                    <span id="sec${status.index + 1}">31</span>秒</p>
								</div>
								<div class="g-img">
								<c:if test ="${!empty show.showBannerImg}">									
									<img src="${my:random(imgGetUrl)}?rid=${show.showBannerImg}" alt="" />
									</c:if>
									<c:if test ="${empty show.showBannerImg}">
									<img src="${imgDomain}/temp/img2.jpg" alt="" />
									</c:if>
								</div>
							</a>
 </div>
 </c:forEach>
 <script type="text/javascript">
  $(".g-time").each(function(){
    var obj=$(this);
    var gid=obj.attr("gtimeid");
    var timestr=obj.attr("endtime");
    var time=Date.parse(timestr.replace(/-/g,"/"));
    var timehtml={
        sec:$("#sec"+gid)[0],
        mini:$("#mini"+gid)[0],
        hour:$("#hour"+gid)[0],
        day:$("#day"+gid)[0],
        month:$("#month"+gid)[0],
        year:$("#year"+gid)[0]
    };
    fnTimeCountDown(time,timehtml);
  });
 </script>
</c:if>