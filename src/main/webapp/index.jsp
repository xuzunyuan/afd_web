<!DOCTYPE html>
<%@include file="/common/common.jsp" %>

<html>
	<head>
		<meta charset="utf-8">
		<title>Welcome</title>
		<script type="text/javascript" src="${ctx}/js/jquery.min.js"></script>
		<script type="text/javascript" src="${ctx}/js/jquery.cookie.js"></script>
		<script type="text/javascript">
			var u = $.cookie("_u");
			var um = $.cookie("_um");
			var ut = $.cookie("_ut");
			alert(u);
			
		</script>
	</head> 
	<body>
		<c:url value="/showMessage.html" var="messageUrl" />
		<a href="${messageUrl}">Click to enter</a>
		<form action="submit.action">

		</form>
	</body>
</html>
