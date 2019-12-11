({
   showSpinner : function(cmp){
       
        var count = cmp.get("v.showSpinner")+1;
        cmp.set("v.showSpinner", count);    
         console.log("Mostro spinner "+count);
    },
    
    hideSpinner : function(cmp){
        var count = cmp.get("v.showSpinner")-1;
        cmp.set("v.showSpinner", count);        
        console.log("Nascondo spinner "+count);
    }
    
})