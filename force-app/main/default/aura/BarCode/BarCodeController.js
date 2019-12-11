({
    init:function(cmp,event,helper){
        if(cmp.get('v.setFocusOnInit')){
            window.setTimeout(
                $A.getCallback(function () {
                    cmp.find("barcode").focus();
                }),100
            );
        }
    },
    
    checkIdLength : function(cmp, event, helper) {
        cmp.find("barcode").focus();
        var key=event.key;
        //var MAXLENGTH = parseInt(cmp.get('v.length'));
        var tempInput = cmp.get("v.inputIdContract");
        if(/*(tempInput && tempInput.length >= MAXLENGTH) || */
            (key=='Enter' || key=='enter')){
            var barCode = cmp.getEvent("barCodeEvent");
            if (barCode) {
                barCode.setParams({
                    'barCode' : tempInput
                });
                barCode.fire();
            }
        }
    }
})