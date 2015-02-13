package com.afd.web.controller;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.afd.constants.user.UserConstants;
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
	public String addAddress(UserAddress address,HttpServletRequest request){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		if("on".equals(address.getIsDefault())){
			address.setIsDefault(UserConstants.ADDRESS_IS_DEFAULT);
		}else{
			address.setIsDefault(UserConstants.ADDRESS_IS_NOT_DEFAULT);
		}
		
		String telArea = request.getParameter("telArea");
		String telNum = request.getParameter("telNum");
		String telExt = request.getParameter("telExt");
		
		StringBuilder sb = new StringBuilder();
		if(StringUtils.isNotBlank(telArea)){
			sb.append(telArea).append("-");
		}
		sb.append(telNum);
		if(StringUtils.isNotBlank(telExt)){
			sb.append("-").append(telExt);
		}
		address.setTel(sb.toString());
		
		if(address.getAddrId()!=null){
			this.addrService.updateAddress(address);
		}else{
			address.setUserId(Long.parseLong(userId));
			this.addrService.addAddress(address);
		}
		return "redirect:/user/userAddress.action";
	}
	
	@RequestMapping("/setDefault")
	public String setDefault(@RequestParam String addrId,HttpServletRequest request){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		this.addrService.setDefault(addrId,userId);
		
		return "redirect:/user/userAddress.action";
	}
	
	@RequestMapping("/delAddr")
	public String delAddr(@RequestParam Long addrId,HttpServletRequest request){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		this.addrService.delAddr(addrId,Long.parseLong(userId));
		
		return "redirect:/user/userAddress.action";
	}
	
	@ResponseBody
	@RequestMapping("/getAddr")
	public String getAddr(@RequestParam Long addrId,HttpServletRequest request){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		UserAddress addr = this.addrService.getAddressByIdUid(addrId,Long.parseLong(userId));
		if(addr!=null){
			return JSON.toJSONString(addr);
		}
		return null;
	}
	
	@ResponseBody
	@RequestMapping("/canAdd")
	public String canAdd(HttpServletRequest request){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		List<UserAddress> addrs = this.addrService.getAddressesByUserId(Long.parseLong(userId));
		Map<String,Boolean> map = new HashMap<String,Boolean>();
		if(addrs!=null&&addrs.size()>=20){
			map.put("status", false);
		}else{
			map.put("status", true);
		}
		return JSON.toJSONString(map);
	}
}
