package com.afd.web.controller;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;

import com.afd.model.user.User;
import com.afd.model.user.UserExt;
import com.afd.service.user.IUserService;
import com.afd.web.service.impl.LoginServiceImpl;

@Controller
@RequestMapping("/user")
public class UserController {
	@InitBinder  
    protected void initBinder(HttpServletRequest request,  
        ServletRequestDataBinder binder) throws Exception {  
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");  
        CustomDateEditor editor = new CustomDateEditor(df, true);  
        binder.registerCustomEditor(Date.class, editor);  
    }
	
	@Autowired
	private IUserService userService;
	
	@RequestMapping("/userInfo")
	public String userInfo(HttpServletRequest request,ModelMap map){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		User user = this.userService.getUserInfoById(Long.parseLong(userId));
		map.addAttribute("user", user);
		String success = request.getParameter("success");
		map.addAttribute("success", success);
		return "user/userInfo";
	}
	
	@RequestMapping("/saveUserInfo")
	public String saveUserInfo(User user){
		if(user!=null){
			this.userService.updateUser(user);
			if(user.getUserExt()!=null){
				UserExt userExt = user.getUserExt();
				userExt.setUserId(user.getUserId());
				this.userService.updateUserExt(userExt);
			}
		}
		return "redirect:/user/userInfo.action?success=true";
	}
}
