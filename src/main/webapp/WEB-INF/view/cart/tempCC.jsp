<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="/common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>TEMP</title>
<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
		<script type="text/javascript" src="${jsDomain}/jquery.cookie.js"></script>
		<script type="text/javascript">
			$(function(){
				$("input[type=button]").click(function(){
					var bsdId = $("input[name=bsdId]").val();
					if(!bsdId){
						alert("请填写sku");
						return false;
					}else{
						if(!/^\d+$/.exec(bsdId)){
							alert("请正确填写sku");
							return false;
						}
						$("#form").submit();
					}
				});
				
			});
		</script>
</head>
<body>
	<form action="${ctx}/temp/addCartCookie.action" id="form">
		<input type="text" name="bsdId" />
		<input type="button" value="添加sku" />
	</form>
</body>
</html>