package com.afd.web.controller;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.afd.model.user.Geo;
import com.afd.model.user.User;
import com.afd.model.user.UserAddress;
import com.afd.model.user.UserExt;
import com.afd.service.user.IAddressService;
import com.afd.service.user.IGeoService;
import com.afd.service.user.IUserService;
import com.afd.web.service.impl.LoginServiceImpl;
import com.alibaba.fastjson.JSON;

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
	@Autowired
	private IAddressService addrService;
	@Autowired
	private IGeoService geoService;
	
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
	
	@RequestMapping("/userAddress")
	public String userAddress(HttpServletRequest request,ModelMap map){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		List<UserAddress> addresses = this.addrService.getAddressesByUserId(Long.parseLong(userId));
		map.addAttribute("addrs", addresses);
		int count = (addresses!=null)?addresses.size():0;
		map.addAttribute("addrCount", count);
		List<Geo> provinces = this.geoService.getGeoProvince();
		map.addAttribute("provinces", provinces);
		
		return "user/address";
	}
	
	@ResponseBody
	@RequestMapping("/getNextGeo")
	public String getNextGeo(@RequestParam Long geoId){
		List<Geo> cities = this.geoService.getGeoByFId(geoId);
		return JSON.toJSONString(cities);
	}
	
	@RequestMapping("/addAddress")
	public String addAddress(UserAddress address){
		if(address.getAddrId()!=null){
			this.addrService.updateAddress(address);
		}else{
			this.addrService.addAddress(address);
		}
		return "redirect:/user/userAddress.action";
	}
}
