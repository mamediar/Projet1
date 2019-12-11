({
    init:function(cmp,event,helper){
        var reclamoCompleto = cmp.get("v.reclamoCompleto");
        if(reclamoCompleto == null)cmp.set("v.reclamoCompleto", false);
        helper.init(cmp, event);
    },
    
    setCoda : function(cmp,event,helper){
        helper.setCodaIniziale(cmp, event);
    },
    
    changeQueue : function(cmp,event,helper){
        var codaTemp = cmp.get('v.codaTemp');
        cmp.set("v.codaSelezionata", codaTemp);
     	helper.setOwner(cmp, codaTemp.DeveloperName);
        
    }
    
})