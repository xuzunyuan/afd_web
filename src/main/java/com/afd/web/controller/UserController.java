package com.afd.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.afd.web.service.impl.LoginServiceImpl;

@Controller
@RequestMapping("/user")
public class UserController {
	
	@Autowired
	private LoginServiceImpl loginService;

	@RequestMapping("/login")
	public String login(){
		return "login";
	}
	
	@RequestMapping("/formLogin")
	public String login(HttpServletRequest req,HttpServletResponse resp){
		boolean success = this.loginService.login(req, resp);
		return "success";
	}
}
