<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/common/common.jsp"%>
<html>
	<head>
		<meta charset="utf-8">
		<title>Welcome</title>
	</head> 
	<body>
		<form action="${ctx}/user/formLogin">
			用户名：<input type="text" name="userName" />
			密码：<input type="text" name="pwd" />
			<input type="submit" value="登录" />
			<input type="hidden" name="rtnUrl" value="${rtnUrl}" />
		</form>
	</body>
</html>
