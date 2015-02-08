package com.afd.web.controller;

import java.io.IOException;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.WebRequest;

import com.afd.common.util.DateUtils;
import com.afd.constants.SystemConstants;
import com.afd.constants.user.UserConstants;
import com.afd.model.user.User;
import com.afd.service.sms.ISmsService;
import com.afd.service.sms.SmsServiceMock;
import com.afd.service.user.IUserService;
import com.afd.web.service.impl.LoginServiceImpl;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;

@Controller
public class LoginController {
	private Logger log = LoggerFactory.getLogger(LoginController.class);
	
	@Autowired
	private LoginServiceImpl loginService;
	@Autowired
	private IUserService userService;
	private ISmsService smsService = new SmsServiceMock();
	@Autowired
	private RedisTemplate<String, Serializable> redis;

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
	
	@RequestMapping("/register")
	public String register(){
		return "register";
	}
	
	@RequestMapping("/formRegister")
	public String formRegister(HttpServletRequest request,HttpServletResponse response,ModelMap map){
		String userName = request.getParameter("userName");
		String mobile = request.getParameter("mobile");
		String pwd = request.getParameter("pwd");
		
		User user = new User();
		user.setUserName(userName.toLowerCase());
		user.setPwd(pwd);
		user.setMobile(mobile);
		
		this.userService.register(user);
		
		this.loginService.login(request, response);
		map.addAttribute("userName", userName);
		return "registerSuccess";
	}
	
	@ResponseBody
	@RequestMapping("/validUserName")
	public String validUserName(@RequestParam String userName){
		boolean status = this.userService.uniqueUserName(userName);
		Map<String,Boolean> map = new HashMap<String, Boolean>();
		map.put("status", status);
		return JSON.toJSONString(map);
	}
	
	@ResponseBody
	@RequestMapping("/validMobile")
	public String validMobile(@RequestParam String mobile){
		boolean status = this.userService.uniqueMobile(mobile);
		Map<String,Boolean> map = new HashMap<String, Boolean>();
		map.put("status", status);
		return JSON.toJSONString(map);
	}
	
	@ResponseBody
	@RequestMapping("/getCode")
	public String getCode(@RequestParam String mobile){
		String code = RandomStringUtils.randomNumeric(6);
		this.redis.opsForValue().set(SystemConstants.CACHE_PREFIX+UserConstants.VALID_CODE+mobile, code, 300, TimeUnit.SECONDS);
		this.smsService.sendSms(mobile, "您的验证码是"+code+"，验证码将在120秒后失效，请尽快完成注册！");
		return "";
	}
	
	@ResponseBody
	@RequestMapping("/validCode")
	public String validCode(@RequestParam String code,@RequestParam String mobile){
		String validCode = (String)this.redis.opsForValue().get(SystemConstants.CACHE_PREFIX+UserConstants.VALID_CODE+mobile);
		Map<String,Boolean> map = new HashMap<String, Boolean>();
		if(code.equals(validCode)){
			map.put("status", true);
		}else{
			map.put("status", false);
		}
		
		return JSON.toJSONString(map);
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping("/validRegister")
	public String validRegister(@RequestParam(required=false) String code,@RequestParam(required=false) String mobile,
			@RequestParam(required=false) String userName,@RequestParam(required=false) String pwd,@RequestParam(required=false) String repwd){
		Map<String,Integer> map = new HashMap<String, Integer>();
		
		//验证用户名
		if(StringUtils.isBlank(userName)){
			map.put("userNameStatus", 1);
		}else if(userName.length() > 20 || userName.length() < 6){
			map.put("userNameStatus", 2);
		}else if(userName.matches(".*[\\u4e00-\\u9fa5]+.*$")){
			map.put("userNameStatus", 3);
		}else{
			String json = this.validUserName(userName);
			Map<String,Boolean> mapTemp = JSON.parseObject(json, new TypeReference<Map<String,Boolean>>(){});
			boolean status = mapTemp.get("status");
			if(!status){
				map.put("userNameStatus", 4);
			}else{
				map.put("userNameStatus", 0);
			}
		}
		
		//验证手机号
		if(StringUtils.isBlank(mobile)){
			map.put("mobileStatus", 1);
		}else if(!mobile.matches("^1\\d{10}")){
			map.put("mobileStatus", 2);
		}else{
			String json = this.validMobile(mobile);
			Map<String,Boolean> mapTemp = JSON.parseObject(json, new TypeReference<Map<String,Boolean>>(){});
			boolean status = mapTemp.get("status");
			if(!status){
				map.put("mobileStatus", 3);
			}else{
				map.put("mobileStatus", 0);
			}
		}
		
		//校验验证码
		if(StringUtils.isBlank(code)){
			map.put("codeStatus", 1);
		}else if(0!=map.get("mobileStatus")){
			map.put("codeStatus", 2);
		}else{
			String json = this.validCode(code, mobile);
			Map<String,Boolean> mapTemp = JSON.parseObject(json, new TypeReference<Map<String,Boolean>>(){});
			boolean status = mapTemp.get("status");
			if(!status){
				map.put("codeStatus", 3);
			}else{
				map.put("codeStatus", 0);
			}
		}
		
		//验证密码
		if(StringUtils.isBlank(pwd)){
			map.put("pwdStatus", 1);
		}else if(pwd.length() > 20 || pwd.length() <6){
			map.put("pwdStatus", 2);
		}else{
			map.put("pwdStatus", 0);
		}
		
		//验证二次密码
		if(StringUtils.isBlank(repwd)){
			map.put("repwdStatus", 1);
		}else{
			if(!repwd.equals(pwd)){
				map.put("repwdStatus", 2);
			}else{
				map.put("repwdStatus", 0);
			}
		}
		
		return JSON.toJSONString(map);
	}
	
	public static void main(String[] args) {
		System.out.println(DateUtils.parseDate(1421737716365l));
	}
}
