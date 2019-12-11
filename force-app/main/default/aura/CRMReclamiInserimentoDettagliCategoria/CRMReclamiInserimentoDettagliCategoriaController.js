({
    init:function(cmp,event,helper){
        helper.treeCategories(cmp);
        helper.setGrave(cmp,event,helper);
    },
    	
    seleziona:function(cmp,event,helper){
        event.preventDefault();
      
           var disp = event.getParam('name');
        
        var disposition = JSON.parse(disp);
    
        var categoria = disposition.cat;
        var sel = cmp.find("selected").get("v.value");
        
        if(disposition.nodo.length == 0){
            
            helper.setCategoria(cmp, categoria.Id);

            var root = cmp.get("v.items");
            root[0].expanded = false;
            cmp.set("v.items", root);            
        }
        
        //helper.getValCoda(cmp,event,helper);
        
  		
    },
    
    getCoda :function(cmp,event,helper){
        helper.getValCoda(cmp,event,helper);
    
    }
    
    
})