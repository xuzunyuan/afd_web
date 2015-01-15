package com.afd.web.controller;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.afd.web.service.IHtmlService;

@Controller
public class BaseController {
	
	@Autowired
	private IHtmlService htmlService;
	
	@RequestMapping(value = "/create")
	@ResponseBody
	public String all(HttpServletRequest request, HttpServletResponse response) {
	    String msg = request.getParameter("msg");
	    System.out.println("*********msg***" + msg);
	    try {
	    	Map<String, String> pmap = new HashMap<String,String>();
	    	pmap.put("title", "this is test");
	    	pmap.put("content", "this is test content.");
	         this.htmlService.all("ftl/test",pmap);

	    } catch (Exception e) {
	      e.printStackTrace();
	      return "0";
	    }
	    return "1";
	  }


}
