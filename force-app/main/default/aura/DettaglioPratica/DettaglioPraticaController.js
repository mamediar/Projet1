({
	doInit : function(component, event, helper) {
		var listParams = component.get('v.lstAttribute');
        var numCol = component.get('v.numColums');
        var arrayParams = listParams.split(",");
		var bigArray = [];
        var array = [];
        for(var i = 0; i < arrayParams.length; i++){
            array.push(arrayParams[i]);
            if(array.length == numCol){
                bigArray.push(array);
                array = [];
            }                
        }
        if(array.length > 0){
            bigArray.push(array);
        }
        component.set('v.dettaglioConfig', bigArray);
	}
})