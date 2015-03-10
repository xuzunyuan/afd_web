package com.afd.web.controller;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.afd.common.mybatis.Page;
import com.afd.model.product.Brand;
import com.afd.model.product.BrandShow;
import com.afd.model.product.BrandShowDetail;
import com.afd.model.product.Product;
import com.afd.model.product.Sku;
import com.afd.param.product.SkuSpec;
import com.afd.param.product.SkuSpecVal;
import com.afd.service.product.IBrandService;
import com.afd.service.product.IBrandShowService;
import com.afd.service.product.IProductService;
import com.afd.web.service.IHtmlService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.alibaba.fastjson.JSON;

@Controller
public class BaseController {
	
	@Autowired
	private IHtmlService htmlService;
	
	@Autowired
	private IBrandShowService brandShowService;
	
	@Autowired
	private IProductService   productService;
	
	@Autowired
	private IBrandService   brandService;
	
	@Autowired
	private RedisTemplate<String, Serializable> redis;
	
	@RequestMapping(value = "/create")
	@ResponseBody
	public String all(HttpServletRequest request, HttpServletResponse response) {
		
		BrandShow record=new BrandShow();
		java.util.List<BrandShow> List = this.brandShowService.getValidBrandShows(record);
		
	    String msg = request.getParameter("msg");
	    System.out.println("*********msg***" + List.size());
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
    
	@RequestMapping(value = "/brandshows")
     public String index(HttpServletRequest request,Model model, HttpServletResponse response){
		BrandShow record=new BrandShow();
		DateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
        String s = format1.format(new Date());
        List<BrandShow> list =new ArrayList<BrandShow>();
        
        try{
        if(this.redis.opsForValue().size("bs"+s)==0){
        	list = this.brandShowService.getValidBrandShows(record);
        	this.redis.opsForValue().set("bs"+s, (Serializable)list,3600*24, TimeUnit.SECONDS);
        }else{
        	list = (List<BrandShow>)this.redis.opsForValue().get("bs"+s);
        } 
        }catch (Exception e){
        	list = this.brandShowService.getValidBrandShows(record);
		}
        
        
		if(list!=null&&list.size()>0){
			for(BrandShow item:list){
				Integer bsid = item.getBrandShowId();
				if(item.getBrandId()!=null){
					Integer bradndId = item.getBrandId();
					Brand brand = this.brandService.getByBrandId(new Long(bradndId));//todo
					if(brand!=null){
						item.setHomeBannerImg(brand.getLogoUrl());
					}
				}				
				BigDecimal lowestPrice = this.brandShowService.getLowestPrice(bsid);
				if(lowestPrice!=null){
					item.setLowestPrice(lowestPrice);
				}else{
					item.setLowestPrice(new BigDecimal("0.00"));
				}
			}
		}
		model.addAttribute("showlist", list);
    	 return "brandshow/index";
     }
	
	@RequestMapping(value = "/bsdetails")
	public String showDetail(@RequestParam(value="pageno", required=false, defaultValue="1") int pageNo,Long bsid,HttpServletRequest request,Model model, HttpServletResponse response){
		if(bsid==null){			
			return "redirect:/index.jsp";
		}
		Page<BrandShowDetail> page=new Page<BrandShowDetail>();
		Page<BrandShowDetail> ret=new Page<BrandShowDetail>();
		page.setPageSize(20);
		page.setCurrentPageNo(pageNo);
		Map<String,Object> map=new HashMap<String,Object>();
		 try{
		        if(this.redis.opsForValue().size("dsd"+bsid+"p"+bsid)==0){
		        	map.put("bsid", bsid);
		    		ret = this.brandShowService.getBrandShowDetailByPage(map, page);
		    		this.redis.opsForValue().set("dsd"+bsid+"p"+bsid, (Serializable)ret,3600*24, TimeUnit.SECONDS);
		        }else{
		        	ret = (Page<BrandShowDetail>)this.redis.opsForValue().get("dsd"+bsid+"p"+bsid);
		        } 
		        }catch (Exception e){
		        	map.put("bsid", bsid);
		    		ret = this.brandShowService.getBrandShowDetailByPage(map, page);
				}
		
		model.addAttribute("showdetails", ret.getResult());
		model.addAttribute("pageno", ret.getCurrentPageNo());
		model.addAttribute("pagetotal",ret.getTotalPage());
		return "brandshow/bsdetail";
	}
    
	@RequestMapping(value = "/brandshow")
	public String brandShow(Integer bsid,HttpServletRequest request,Model model, HttpServletResponse response){
		if(bsid==null){
			return "redirect:/index.jsp";
		}
		BrandShow brandShow = this.brandShowService.getBrandShowById(bsid);
		if(brandShow==null){
			return "redirect:/index.jsp";
		}
		model.addAttribute("brandShow",brandShow);
		return "active";
	}
	
	@RequestMapping(value = "/detail")
	public String detail(Integer bsdid,HttpServletRequest request,Model model, HttpServletResponse response){
		if(bsdid==null){			
			return "redirect:/index.jsp";
		}
		
		Map<String,Object> map=new HashMap<String,Object>();
		model.addAttribute("bsdid", bsdid);
		BrandShowDetail bsd = this.brandShowService.getBrandShowDetailById(bsdid);
		if(bsd==null){
			return "redirect:/index.jsp";
		}
		BrandShow brandshow = this.brandShowService.getBrandShowById(bsd.getBrandShowId());
		if(brandshow==null){
			return "redirect:/index.jsp";
		}
		model.addAttribute("bsdetail", bsd);
		model.addAttribute("brandshow", brandshow);
		Integer skuId = bsd.getSkuId();
		Sku sku = this.productService.getSkuById(skuId);
		if(sku==null){
			return "redirect:/index.jsp";
		}
		model.addAttribute("sku", sku);
		model.addAttribute("skujson",JSON.toJSONString(sku));
	    Integer prodId = sku.getProdId();
	    Product product = this.productService.getProductById(prodId);
	    if(product==null){
			return "redirect:/index.jsp";
		}
	    model.addAttribute("product", product);
	    List<Sku> skus = this.productService.getSkusByProdId(prodId);
	    if(skus==null||skus.size()==0){
			return "redirect:/index.jsp";
		}
	    model.addAttribute("skus", skus);
	    Map<String, SkuSpec> prductSpecs=new HashMap<String, SkuSpec>();
	    HashMap<String, Sku> skuMapJson = new HashMap<String,Sku>();		
	    for(Sku sku_tmp :skus){
	    	String SkuSpecIds = sku_tmp.getSkuSpecId();
			String skuSpecNames=sku_tmp.getSkuSpecName();
			this.getSpecMap(skuSpecNames,SkuSpecIds,prductSpecs);	
			skuMapJson.put(sku_tmp.getSkuSpecId(), sku_tmp);
		}
	    model.addAttribute("skusjson", JSON.toJSONString(skuMapJson));
	    model.addAttribute("prductSpecs", prductSpecs);
	    model.addAttribute("pspecsjson", JSON.toJSONString(prductSpecs));
		return "detail";
	}
	


	
	private void getSpecMap(String specNames,String specIds,Map<String, SkuSpec> prductSpecs) {
		
		if (!StringUtils.isBlank(specNames)&&!StringUtils.isBlank(specIds)) {
			String[] names = specNames.split("\\|\\|\\|");
			String[] ids = specIds.split("\\|\\|\\|");
				for(int i = 0;i<ids.length;i++){
					String name = names[i];
					String id = ids[i];
					String[] opt_name = name.split("\\:\\:\\:");
					String[] opt_id= id.split("\\:\\:\\:");
					String key=opt_id[0];
					SkuSpec skuSpec=new SkuSpec();
					if(prductSpecs.containsKey(key)){
						skuSpec=prductSpecs.get(key);
					}else{
						skuSpec.setSpecId(opt_id[0]);
						skuSpec.setSpecName(opt_name[0]);
						Map<String, SkuSpecVal> specVals=new HashMap<String, SkuSpecVal>();
						skuSpec.setSpecVals(specVals);
						
					}					
					SkuSpecVal skuSpecVal =new SkuSpecVal();
					skuSpecVal.setSpecId(opt_id[1]);
					skuSpecVal.setSpecName(opt_name[1]);
					Map<String, SkuSpecVal> specVals = skuSpec.getSpecVals();
					if(!specVals.containsKey(skuSpecVal.getSpecId())){
						specVals.put(skuSpecVal.getSpecId(), skuSpecVal);
						skuSpec.setSpecVals(specVals);
					}
					prductSpecs.put(key, skuSpec);					
				}
			}

	}
}