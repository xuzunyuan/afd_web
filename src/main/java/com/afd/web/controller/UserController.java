package com.afd.web.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.afd.web.service.impl.LoginServiceImpl;

@Controller
@RequestMapping("/user")
public class UserController {
	private Logger log = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private LoginServiceImpl loginService;

	@RequestMapping("/login")
	public String login(@RequestParam(required=false,value="rtnUrl") String rtnUrl,ModelMap map){
		map.addAttribute("rtnUrl", rtnUrl);
		return "login";
	}
	
	@RequestMapping("/formLogin")
	public String login(HttpServletRequest req,HttpServletResponse resp){
		boolean success = this.loginService.login(req, resp);
		if(success){
			String rtnUrl = req.getParameter("rtnUrl");
			if(StringUtils.isNotBlank(rtnUrl)){
				try {
					resp.sendRedirect(rtnUrl);
				} catch (IOException e) {
					log.error(e.getMessage(), e);
				}
			}
		}
		
		return "success";
	}
	
	@RequestMapping("/isLogin")
	public String islogin(HttpServletRequest req,HttpServletResponse resp,ModelMap map){
		boolean success = LoginServiceImpl.isLogin(req, resp);
		map.addAttribute("success", success);
		return "islogin";
	}
}
