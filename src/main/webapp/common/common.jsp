<%@page import="com.afd.common.util.PropertyUtils"%>
<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@taglib prefix="my" uri="/WEB-INF/tld/my.tld"%>
<%@taglib prefix="pg" uri="/WEB-INF/tld/page.tld"%>
<%request.setAttribute("ctx", request.getContextPath()); %>
<%request.setAttribute("cssDomain", "http://css.web.juyouli.com"); %>
<%request.setAttribute("jsDomain", "http://js.web.juyouli.com"); %>
<%request.setAttribute("imgDomain", "http://img.web.juyouli.com"); %>
<%request.setAttribute("imgUploadUrl", "http://upload.juyouli.com/rc/upload"); %>
<%request.setAttribute("imgUrl", "http://img.juyouli.com/rc/getimg"); %>
<%request.setAttribute("prefixImgUrl", "http://img"); %>
<%request.setAttribute("suffixImgUrl", ".juyouli.com/rc/getimg"); 
	PropertyUtils.setRequestProperties(request);
%>

