var canvas_list=[];
var page_container=null;
var msgbox=null;
var msgbox_wait_queue=null;
var pdf_load_timeout_obj;

function plainHTML_Fallback(){
	doMessage("warning","Falling back to plain HTML");
	freeDisplay();
	if(typeof(fail_callback)==="function"){
		fail_callback();
	}
}
function PDFJS_Fallback(){
	var script=document.createElement("script");
	script.setAttribute("type","text/javascript");
	script.setAttribute("src",pdfjs_url);
	document.body.appendChild(script);
	script.addEventListener("load",PDFJS_Fallback_Load_Success,false);
	script.addEventListener("error",PDFJS_Fallback_Load_Fail,false);
}
function PDFJS_Fallback_Load_Success(){
	if(typeof(PDFJS)==="undefined"){
		PDFJS_Fallback_Load_Fail();
	}
	doMessage("success","PDF.JS loaded");
	PDFJS.disableWorker=true;
	displayPDF(pdf_url);
}
function PDFJS_Fallback_Load_Fail(){
	doMessage("error","Couldn't load PDF.JS (at "+pdfjs_url+")");
	plainHTML_Fallback();
}
function getIconSRC(type){
	var imgsrc="";
	if(type==="success"){
		imgsrc="Graph/Success.png";
	}
	else if(type==="error"){
		imgsrc="Graph/Error.png";
	}
	else if(type==="warning"){
		imgsrc="Graph/Warning.png";
	}
	else if(type==="wait"){
		imgsrc="Graph/Wait.gif";
	}
	return imgsrc;
}
function hideMessageBox(){
	if(msgbox!==null){
		msgbox.parentNode.removeChild(msgbox);
		msgbox=null;
	}
}
function getMessageBox(){
	if(msgbox!==null){
		return msgbox;
	}
	msgbox=document.createElement("div");
	msgbox.setAttribute("style",
	"display:block;"+
	"background-color:silver;"+
	"border: 2px black outset;"+
	"padding:0.1em 0.5em 1em 1em;"+
	"margin:0px 2%;"+
	"margin-bottom:50px;");
	
	var closebar=document.createElement("div");
	closebar.setAttribute("style","text-align:right; border-bottom:1px black solid; margin-bottom:0.5em; padding-right:1ex;");
	
	var close=document.createElement("span");
	close.setAttribute("style","cursor:pointer; font-weight:bold;")
	close.appendChild(document.createTextNode("x"));
	close.addEventListener("click",hideMessageBox,false);
	
	closebar.appendChild(close);
	msgbox.appendChild(closebar);
	document.body.appendChild(msgbox);
	return msgbox;
}
function getPageContainer(){
	if(page_container!==null){
		return page_container;
	}
	
	page_container=document.createElement("div");
	page_container.setAttribute("style","text-align:center;");
	var container=document.createElement("div");
	container.setAttribute("style","display:inline-block;");
	page_container.appendChild(container);
	document.body.appendChild(page_container);
	return container;
}
function getCanvasElement(){
	var canvas=document.createElement("canvas");
	canvas.setAttribute("style",
		"display:block;"+
		"padding: 50px 0px;"+
		"height: "+window.innerHeight+"px");
	return canvas;
}
function doMessage(type, msg){
	var msgbox=getMessageBox();
	if(msgbox!==null){
		msgbox.appendChild(document.createElement("br"));
	}
	if(type==="hide"){
		hideMessageBox();
		return;
	}
	var img=null;
	var imgsrc=getIconSRC(type);
	if(imgsrc!==""){
		var img=document.createElement("img");
		img.setAttribute("alt",type+":");
		img.setAttribute("style","height:1em");
		img.setAttribute("src",imgsrc);
		msgbox.appendChild(img);
	}
	msgbox.appendChild(document.createTextNode(" "+msg));
	
	if(msgbox_wait_queue!==null){
		msgbox_wait_queue.src=imgsrc;
		msgbox_wait_queue=null;
	}
	else if(type==="wait"){
		msgbox_wait_queue=img;
	}
}
function freeDisplay(){
	var i;
	for(i=0; i<canvas_list.length; i++){
		var canvas=canvas_list[canvas_list.length-1-i];
		canvas.parentNode.removeChild(canvas);
	}
	canvas_list=[];
}
function PDFLoadError(error){
	doMessage("error", "Couldn't load PDF-File: "+error);
	window.clearTimeout(pdf_load_timeout_obj);
	plainHTML_Fallback(); 	
}
function displayPDF(pdffile){
	doMessage("wait", "Loading PDF-File");
	pdf_load_timeout_obj=window.setTimeout('PDFLoadError("Timed out")',pdf_load_timeout);
	
	PDFJS.getDocument(pdffile).then(function gotPDF(pdf){
		doMessage("success", "PDF-File loaded");
		window.clearTimeout(pdf_load_timeout_obj);
		var i;
		var context;
		var reference;
		var addendum="";
		for(i=1; i<pdf.numPages; i++){
			reference=generateCanvas();
			if(i==pdf.numPages-1){
				addendum="if(typeof(success_callback)==='function') success_callback();";
			}
			pdf.getPage(i).then(new Function("page",
				"var my_canvas=canvas_list["+reference+"];"+
				"try{"+
					"var viewport = page.getViewport(scale);"+
				"}catch(e){ doMessage('error', 'Couldnt create viewport: '+e); return}"+
				"my_canvas.height=viewport.height;"+
				"my_canvas.width=viewport.width;"+
				"try{"+
					"page.render({canvasContext: my_canvas.getContext('2d'), viewport: viewport});"+
				"}catch(e){ doMessage('error', 'Couldnt render page: '+e); return;}"+
				"doMessage('success', 'Page "+i+" rendered');"+addendum
			));
		}
	},PDFLoadError);
}
function generateCanvas(){
	var canvas=getCanvasElement();
	if(page_container===null){
		page_container=getPageContainer();
	}
	page_container.appendChild(canvas);
	canvas_list[canvas_list.length]=canvas;
	return canvas_list.length-1;
}
			
