<!DOCTYPE html>
<%@include file="/common/common.jsp" %>
<html lang="zh-cn">
<head>
	<meta charset="utf-8">
	<title>详情页</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/store.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/jquery.jqzoom.css" >
</head>
<body class="">
	<div class="wrapper">
		<jsp:include page="/common/head.html"/>
		<!-- crossnav -->
		<div class="crossnav">
			<ul>
				<li class="on"><a href="#">详情&nbsp;&nbsp;页</a></li>
			</ul>
		</div>
		<!-- crossnav -->
		<!-- container -->
		<div id="container">
		<script type="text/javascript" src="http://js.web.afdimg.com/jquery.jqzoom-core.js"></script>
			<div class="wrap">
				<div class="headSyn">
					<div class="countDown">
						<p>距特卖介绍还剩：<img src="${imgDomain}/clok.png" alt=""><span>06:07:51:41.3</span></p>
					</div>
					<!-- breadnav  -->
					<div class="breadnav">
						<span class="index"><a href="">首页</a></span>
						<ul class="nav">
							<li><span>&gt;</span><a href="">Ponie Conie 元旦特辑</a></li>
							<li><span>&gt;</span><a href="#">Ponie Conie婴儿衣服夏季短袖连衣裙套装女宝宝夏装纯棉套装淑女</a></li>
						</ul>
					</div>
				</div>
				<!-- breadnav end -->
				<!-- goodsBuy -->
				<div class="goodsBuy">
					<div class="article">
						<div class="g-preview">
						<div class="clearfix">
						   <a id="picbig" href="http://hplus.sinaapp.com/static/images/2013/imgProd/1.png" class="jqzoom" rel="gal1">
							<img  id="picsmall" src="http://hplus.sinaapp.com/static/images/2013/imgProd/1show.png"   title="triumph"  style="border: 1px solid #a2a0a0;">
						  </a>
							<div class="ico"><i></i></div>
						</div>
						<div class="images">
							<div class="slide slide-primary" style="height: 62px">
								<div class="prev"><i class="ico" onclick="move_left()"></i></div>
								<div class="next"><i class="ico" onclick="move_right()"></i></div>
								<!-- items -->
								<div class="items">
									<ul id="imglist" style="width: 999em;">
										
									</ul>
								</div>
								<!-- items end -->
							</div>
						</div>
					</div>
					<!-- g-buy -->
					<div class="g-buy">
						<h2 class="mainTitle">krazy2013性感女装优雅三种穿法吊带裙夜店修身包身包臀连衣裙117</h2>
						<h3 class="subTitle">新品推广促销，全场满100元送神秘礼物！</h3>
						<!-- g-items -->
						<div class="g-items active">
							<div class="prices">
								<dl class="g-item barginPrice"><dt>促销价</dt><dd><span>¥<em>398.00</em></span></dd></dl>
							</div>
								<dl class="g-item"><dt>市场价</dt><dd><span><del>¥1380.00</del></span></dd></dl>
							<dl class="g-item">
								<dt>快递费</dt>
								<dd><div class="g-tag">包邮</div>
								</dd>
							</dl>
						</div>
						<!-- g-items end -->
						<!-- g-items -->
						<div class="g-items g-attr">
<c:if test="${!empty prductSpecs}">
<c:forEach items="${prductSpecs}" var="spec" varStatus="status">
                            <dl class="g-item" tagname="spid" spid="${spec.value.specId}">
								<dt>${spec.value.specName}</dt>
								<dd>
								<c:forEach items="${spec.value.specVals}" var="specval" varStatus="status">
									<div class="attrElem">
										<a  href="javascript:void(0)" onclick="choose_spec('${specval.value.specId}')">
											<span tagname="spvid" spvid="${specval.value.specId}">${specval.value.specName}</span>											
										</a>
									</div>
								</c:forEach>
								</dd>
							</dl>
</c:forEach>
</c:if>
							<dl class="g-item">
								<dt>数量</dt>
								<dd>
									<div class="mod-modified">
										<div class="minus disabled">-</div>
										<input type="text" class="txt sm" value="1">
										<div class="plus">+</div>
									</div><span>件</span><span>库存<em>828</em>件</span>
								</dd>
							</dl>
						</div>
						<!-- g-items end -->
						<div class="btnWrap clearfix">
							<a href="#" class="btn btn-assist xl btn-addCart"><i class="icon i-cartSM"></i>加入购物车</a>
						</div>
					</div>
					<!-- g-buy end -->
				</div>
				</div>
				<!-- goodsBuy -->
				<!-- goodsRec -->
				<div class="goodRec">
					<!-- goodsDetails -->
					<div class="goodsDetails">
						
					</div>
					<!-- goodsDetails -->
					<!-- goodsRecommend -->

					<!-- goodsRecommend -->
				</div>
				<!-- goodRec end -->
			</div>
		</div>
		<!-- container end -->
		<!-- footer -->
		<jsp:include page="/common/foot.html" />
		<!-- footer end -->
		<!-- float -->
		<div id="float" class="float-box">
			<div id="hometop" class="return-top"><a title="返回顶部" href="javascript:void(0);"></a> </div>
		</div>
		<!-- float end -->
	</div>
	<script type="text/javascript">
	//var skuList = ${skusjson} ;
	  var skuList = {"4:::18":{"createByName":"一网开发","createDate":1423124312000,"lastUpdateDate":1423124312000,"marketPrice":2.00,"prodId":3,"salePrice":11.00,"skuId":1,"skuImgUrl":"IMG_2015_02_05_7aa8b905f37e4d39937b4e6945f87148.jpg","skuSpecId":"4:::18","skuSpecName":"颜色分类:::军绿色","skuStatus":"1","stockBalance":3,"updateByName":"一网开发"}} ;
	  var defaultSku = ${skujson}; 
	  var selecSku=defaultSku;
	var prductspecs=${pspecsjson};
	var total_length=74;
	var img_length=74;
	function choose_spec(spvid){
		 var target_obj=$("span[tagname=spvid][spvid="+spvid+"]")[0];
		 var target_div_obj=$(target_obj).parent().parent();
    	 if(target_div_obj.hasClass("disabled")){
    		 return false;
    	 }
    	 if(target_div_obj.hasClass("selected")){
    		 return false;
    	 }
		$("span[tagname=spvid]").each(function(){
		    $(this).next().remove();
		    $(this).parent().parent().removeClass("selected");
		  });
		$("span[spvid="+spvid+"]").each(function(){
		    $(this).after('<i class="on">已选中</i>');
		    $(this).parent().parent().addClass("selected");
		  });
		$("div.attrElem").removeClass("disabled");
		exclude_sku();
		if(check_spec_finish()){
			selecSku=skuList[get_sku()];
		}
	};
	function check_spec_finish(){
		var flag=true;
		$("span[tagname=spid]").each(function(){
		    if($(this).find("div.attrElem.selected").length==0){
		    	flag=false;
		    	return false;
		    }
		  });
		
		return flag;
	};
	function get_sku(){
		var spec_str_arr=new Array();
		$("dl[tagname=spid]").each(function(){
		    var spid=$(this).attr("spid");
		    var spvid_obj=$(this).find("div.attrElem.selected")[0];
		    if(spvid_obj){
		    	var obj_temp=$(spvid_obj).find("span[tagname=spvid]")[0];
		    	if(obj_temp){
		    		var spvid=$(obj_temp).attr("spvid");
		    		spec_str_arr.push(spid+":::"+spvid);
		    	}
		    }
		  });
		return spec_str_arr.join("|||");
	};
	
	var produt_spcs_arr=new Array();//所有的规格的id
	var produt_spcvs_arr=new Array();//所有的规格值的id
    function exclude_sku(){
		var spids_str=get_sku();
		var spids_arr=spids_str.split("|||");
    	for(var i=0;i<produt_spcs_arr.length;i++){
    		var one_attrvalids=produt_spcvs_arr[i];
    		for(var j=0;j<one_attrvalids.length;j++){
    			var str_temp=produt_spcs_arr[i]+":::"+one_attrvalids[j];
    			var spids_str_temp=spids_arr;
    			     spids_str_temp[i]=str_temp;
    			     var new_spcs_str=spids_str_temp.join("|||");   			    
    			     if(typeof(skuList[new_spcs_str])=='undefined'){    			    	    			    	
    			    	 var target_obj=$("span[tagname=spvid][spvid="+one_attrvalids[j]+"]")[0];
    			    	 $(target_obj).parent().parent().addClass("disabled");
    			     }
    		}
    	}
	};
	function load_imgs(){
		var imgurls=selecSku.skuImgUrl;
		var imgurls_arr=imgurls.split();
		var html_str="";
		for(var i in imgurls_arr){
			html_str+=get_img_html(imgurls_arr[i]);
		}
		$("#picbig").attr("href",'${my:random(imgGetUrl)}?rid='+imgurls_arr[0]+'&op=s0_w900_h900');
		$("#picsmall").attr("src",'${my:random(imgGetUrl)}?rid='+imgurls_arr[0]+'&op=s0_w418_h418');
		$("#imglist").html(html_str);
		total_length=img_length*imgurls_arr.length;
		
	}
	function get_img_html(imgurl){
		var html_str='';
		html_str+='<li>';
		html_str+='<div class="img on">';
		html_str+='<a href="#">';
		html_str+='<a class="zoomThumbActive" href="javascript:void(0);" rel="{gallery: \'gal1\',smallimage:\'${my:random(imgGetUrl)}?rid='+imgurl+'&op=s0_w418_h418\'}\',largeimage: \'${my:random(imgGetUrl)}?rid='+imgurl+'&op=s0_w900_h900\'}">';
		html_str+='<img src="${my:random(imgGetUrl)}?rid='+imgurl+'&op=s0_w55_h55" alt="">';
		html_str+='</a>';
		html_str+='</a>';
		html_str+='</div>';
		html_str+='</li>';
		return html_str;
	}
	$(function(){
		load_imgs();
		var specs=defaultSku.skuSpecId;
		var list=specs.split("|||");
		for(var i in prductspecs){ 
			var obj=prductspecs[i]; 
			produt_spcs_arr.push(obj.specId);
			var vals=obj.specVals;
			var vals_arr=new Array();
			for(var j in vals){
				vals_arr.push(vals[j].specId);
			};
			produt_spcvs_arr.push(vals_arr);
			};
		for(var i=0;i<list.length;i++){
			var item=list[i];
			var item_list=item.split(":::");
			var spvid=item_list[1];
			choose_spec(spvid);
		};
		
		

	});
	</script>
	<script  type="text/javascript">
	
            function move_left(){
                var left = $("#imglist").position().left;
                var width= $("#imglist").width();
                if(left<0){
                    $("#imglist").animate({left:(left+img_length)+"px"});
                }
            }
            function move_right(){
                var left = $("#imglist").position().left;               
                if(total_length-img_length*5+left>0){
                    $("#imglist").animate({left:(left-img_length)+"px"});
                }
            }
          
            $(document).ready(function() {
                $('.jqzoom').jqzoom({
                    zoomType: 'reverse',
                    lens:true,
                    xOffset:8,
                    preloadImages: false,
                    title:false,

                    imageOpacity:0.5,
                    alwaysOn:false
                });
            });
        </script>
        <script type="text/javascript">
            $(function(){

                document.onclick=function(e){
                    var e=e?e:window.event;
                    var tar = e.srcElement||e.target;
                    if(tar.id!="prod_price1"){
                        $('#prod_price1').css('z-index',-1);$('#prod_price').show();
                    }
                }
            })
        </script>
</body>
</html>
