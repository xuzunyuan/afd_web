<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%request.setAttribute("ctx", request.getContextPath()); %>
<%request.setAttribute("cssWebDomain", "http://css.yiwang.com/classic"); %>
<%request.setAttribute("cssDomain", "http://css.trade.yiwangimg.com"); %>
<%request.setAttribute("jsDomain", "http://js.trade.yiwangimg.com"); %>
<%request.setAttribute("imgDomain", "http://img.trade.yiwangimg.com"); %>
<%request.setAttribute("count", 6); %>
<%request.setAttribute("prefixImgUrl", "http://img"); %>
<%request.setAttribute("suffixImgUrl", ".yiwangimg.com/rc/getimg"); %>
<%request.setAttribute("cartUrl", "http://trade.yiwang.com/cart.jsp"); %>
<%request.setAttribute("prodUrl", "http://item.yiwang.com/detail/"); %>
