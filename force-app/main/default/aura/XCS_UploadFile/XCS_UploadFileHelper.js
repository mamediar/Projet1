({
    handleUploadFinished : function(component,event) {
        
    },
    
    showSpinner : function(cmp){
        var x = cmp.get("v.spinner");
        x++;
        cmp.set("v.spinner", x);
    },
    
    hideSpinner : function(cmp){
        var x = cmp.get("v.spinner");
        x--;
        cmp.set("v.spinner", x);
    },
})