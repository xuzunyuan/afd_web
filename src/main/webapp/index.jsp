<!DOCTYPE html>
<%@include file="/common/common.jsp" %>

<html>
	<head>
		<meta charset="utf-8">
		<title>Welcome</title>
		<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
		<script type="text/javascript" src="${jsDomain}/jquery.cookie.js"></script>
		<script type="text/javascript" src="${jsDomain}/login.js"></script>
	</head> 
	<body>
		<c:url value="/showMessage.html" var="messageUrl" />
		<a href="${messageUrl}">Click to enter</a>
		<form action="submit.action">

		</form>
	</body>
</html>
