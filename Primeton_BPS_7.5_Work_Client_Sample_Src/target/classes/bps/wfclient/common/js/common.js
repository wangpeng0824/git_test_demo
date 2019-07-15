String.prototype.trim=function(){
     return this.replace(/(^\s*)|(\s*$)/g, '');
};


function closeWindow(action) {   
    if (window.CloseOwnerWindow) {
        return window.CloseOwnerWindow(action);
    } else {
    	window.close();  
    }          
}

tfcToast = window.top.tfcToast || {};
tfcToast.take = tfcToast.take || function(text){//不重新定义方法，解决bug45183
	if(undefined == window.top.document.getElementById("toast")){
    	window.top.$("body").prepend("<div id='toast' style='padding: 10px; color: rgb(255, 255, 255); display: none; position: absolute; z-index: 10010; opacity: 1; background-color: rgb(0, 0, 0); border-radius: 5px;'>"+text+"</div>");
    }else{
    	window.top.$("#toast").stop();
    	window.top.document.getElementById("toast").innerHTML = text;
    	if(window.top.$("#toast").css("opacity") != 1){
    		window.top.$("#toast").css("opacity",1);
    		window.top.$("#toast").stop();
    	}
    }
	// 获取窗口宽度
	var winWidth;
	var winHeight;
	if ( window.top.innerWidth)
		winWidth = window.top.innerWidth;
	else if (( window.top.document.body) && ( window.top.document.body.clientWidth))
		winWidth = window.top.document.body.clientWidth;
	// 获取窗口高度
	if (window.top.innerHeight)
		winHeight = window.top.innerHeight;
	else if ((document.body) && (document.body.clientHeight))
		winHeight =  window.top.document.body.clientHeight;
	var top = window.top.document.body.scrollHeight - winHeight/2 - window.top.$("#toast").height()/2;
    var left = window.top.document.body.scrollWidth - winWidth/2 - window.top.$("#toast").width()/2 ;
    window.top.$("#toast").css("left",parseInt(left) + "px");
    window.top.$("#toast").css("top",parseInt(top) + "px");
    window.top.$("#toast").fadeIn(1000);
	window.top.$("#toast").fadeTo(1500,0.8);
	window.top.$("#toast").fadeOut(1500);
};