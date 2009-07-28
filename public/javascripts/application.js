// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function createMarker(link, latitude, longitude) {
	var marker = new GMarker(new GLatLng(latitude, longitude));
	marker.value = link;
	GEvent.addListener(marker, "click", function() {
    	new Ajax.Request(link, {asynchronous:true, evalScripts:true, method:'get'}); 
    	return false;
    });
  	return marker;
}