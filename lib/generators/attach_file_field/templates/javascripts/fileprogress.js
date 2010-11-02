/* ******************************************
 *	SwfFileProgress Object
 *	Control object for displaying file info
 * ****************************************** */

function SwfFileProgress(file, targetID) {
  var container = targetID + "_progress";
	this.fileProgressID = targetID + "_swf";

	this.fileProgressWrapper = document.getElementById(this.fileProgressID);
	
	if (!this.fileProgressWrapper) {
		this.fileProgressWrapper = document.createElement("div");
		this.fileProgressWrapper.className = "progress-container";
		this.fileProgressWrapper.id = this.fileProgressID;
		
		var progressStatus = document.createElement("div");
		progressStatus.className = "status-message";
		progressStatus.innerHTML = "&nbsp;";
		
		this.fileProgressElement = document.createElement("div");
		this.fileProgressElement.className = "progress-bar";
		
		var progressBar = document.createElement("div");
		progressBar.className = "progress";
    
    var progressCancel = document.createElement("a");
		progressCancel.className = "progressCancel";
		progressCancel.href = "#";
		progressCancel.style.visibility = "hidden";
		progressCancel.appendChild(document.createTextNode(" "));
    
		this.fileProgressElement.appendChild(progressBar);
    
    this.fileProgressWrapper.appendChild(progressStatus);
		this.fileProgressWrapper.appendChild(this.fileProgressElement);
		this.fileProgressWrapper.appendChild(progressCancel);
    
		document.getElementById(container).appendChild(this.fileProgressWrapper);

	} else {
		this.fileProgressElement = this.fileProgressWrapper.childNodes[1];
		//this.fileProgressElement.childNodes[1].firstChild.nodeValue = file.name;
	}

	this.height = this.fileProgressWrapper.offsetHeight;
}
SwfFileProgress.prototype.setProgress = function(percentage) {
	var value = parseInt((400 * percentage / 100));	
	this.fileProgressElement.childNodes[0].style.width = value + "px";
};
SwfFileProgress.prototype.setComplete = function() {
	/*this.fileProgressElement.className = "progressContainer blue";
	this.fileProgressElement.childNodes[3].className = "progressBarComplete";*/
	this.fileProgressElement.childNodes[0].style.width = "0px";
};
SwfFileProgress.prototype.setError = function() {
	/*this.fileProgressElement.className = "progressContainer red";
	this.fileProgressElement.childNodes[3].className = "progressBarError";*/
	this.fileProgressElement.childNodes[0].style.width = "0px";

};
SwfFileProgress.prototype.setCancelled = function() {
	/*this.fileProgressElement.className = "progressContainer";
	this.fileProgressElement.childNodes[3].className = "progressBarError";*/
	this.fileProgressElement.childNodes[0].style.width = "0px";

};
SwfFileProgress.prototype.setStatus = function(status) {
	this.fileProgressWrapper.childNodes[0].innerHTML = status;
};

SwfFileProgress.prototype.toggleCancel = function(show, swfuploadInstance) {
  var progressCancel = this.fileProgressWrapper.childNodes[2];
	progressCancel.style.visibility = show ? "visible" : "hidden";
	
	if (swfuploadInstance) {
		var fileID = this.fileProgressID;
		progressCancel.onclick = function () {
			swfuploadInstance.cancelUpload(fileID);
			return false;
		};
	}
};

SwfFileProgress.prototype.parseXML = function(xml){
  var xmlDoc = null;
   
  if (window.ActiveXObject) 
  {
    xmlDoc = Ajax.getTransport();
    xmlDoc.async = false;
    xmlDoc.loadXML(xml);
  }
  else
  {
    var parser = new DOMParser();
  	xmlDoc = parser.parseFromString(xml,"text/xml");  
  }
  
  return xmlDoc;
};

SwfFileProgress.prototype.setThumbnail = function(serverData, collection_id) {
  var xml = this.parseXML(serverData);
  
  var thumbnail = xml.getElementsByTagName('asset');
  var asset = document.getElementById(collection_id + '_asset');
  
  thumbnail = (thumbnail[0] == null ? xml : thumbnail[0])
  
  if (thumbnail != null)
  {
    var id_node = thumbnail.getElementsByTagName('id')[0]; 
    var filename_node = thumbnail.getElementsByTagName('filename')[0];
    var styles_node = thumbnail.getElementsByTagName('styles')[0];
    var thumb_node = styles_node.getElementsByTagName('thumb')[0];
    
    var id = id_node.childNodes[0].nodeValue;
    var filename = filename_node.childNodes[0].nodeValue;
    var thumb = thumb_node.childNodes[0].nodeValue;
    
    var div = document.createElement('div');
    div.className = "r-ill";
    
    var div_data = document.createElement('div');
    div_data.className = 'r-ill-data';
    
    var span = document.createElement('span');
    span.className = 'file-name';
    span.innerHTML = filename;

    var picture = document.createElement('div');
    picture.id = "asset_" + id;
    picture.className = "l-ill";
        
    var image = document.createElement('img');
    image.title = filename;
    image.alt = filename;
    image.src = thumb;
    
    var link = document.createElement('a');
    link.className = 'del';
    link.href = "javascript:void(0)";
    
    link.onclick = function () {
      if (confirm('Удалить?')) { 
        jQuery.ajax({
          complete:function(request){$('#' + collection_id + '_asset').fade()}, 
          data:'_method=delete', 
          dataType:'script', 
          type:'post', 
          url:'/manage/assets/' + id}); 
      }; 
      
      return false;  
    }
    
    var del = document.createElement('img');
    del.title = "Удалить";
    del.alt = "Удалить";
    del.src = "/attach_file_field/images/cross_ico.gif";
    
    link.appendChild(del);
    
    div_data.appendChild(span);
    div_data.appendChild(link);
    div.appendChild(div_data);
    
    picture.appendChild(image);
    
    asset.innerHTML = '';
    asset.appendChild(div);
    asset.appendChild(picture);
    asset.style.display = '';
  }
};
