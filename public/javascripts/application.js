// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function createMarker(latitude, longitude, id) {
	var marker = new GMarker(new GLatLng(latitude, longitude));
	marker.value = id;
	GEvent.addListener(marker, "click", function() {
    	new Ajax.Request('/incidents/' + id, {asynchronous:true, evalScripts:true, method:'get'}); 
    	return false;
    });
  	return marker;
}