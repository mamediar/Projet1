({
	init : function(cmp, event, helper) {
        var selRows=cmp.get("v.selectedRows");
        
	},
    
    saveBarcode:function(cmp,event){
        var barCode=event.getParam('barCode');
        cmp.set('v.barCodeVector','\n Barcode vettore:'+barCode);
    }
})