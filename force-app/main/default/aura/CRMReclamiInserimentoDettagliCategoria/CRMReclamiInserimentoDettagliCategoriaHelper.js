({

    selectCategoria:function(cmp,name,lv){
        cmp.set('v.categoriaDettagli',null);
        cmp.get('v.categorieMap')['lv'+lv].forEach(function(temp){
            if(temp['Id']==name || temp['External_Id__c']==name){
                cmp.set('v.categoriaDettagli',temp);
            }
        });
        var action=cmp.get('c.getGrave');
        action.setParam('categ',cmp.get('v.categoriaDettagli'));
        action.setParam('societa',cmp.get('v.aziendaSelezionata'));
        action.setCallback(this,function(resp){
        
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.categoriaDettagli',resp.getReturnValue());
              	this.setGrave(cmp, event);
            }
        });
        console.log('getGrave Start');
        $A.enqueueAction(action);
    },
    
    setCategoria :function(cmp, cat){
       
        var action=cmp.get('c.setCategoriaCtrl');
        action.setParam('idCateg',cat);
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.categoriaDettagli',resp.getReturnValue());
                this.setGrave(cmp, event);
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    treeCategories :function(cmp){
         console.log('Richiamo treeCategories');
        var action=cmp.get('c.treeCategories');
        action.setParam('azienda',cmp.get('v.aziendaSelezionata'));
        
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var newItems  = resp.getReturnValue();
               
             
                 var obj= [];
                var temp = {
                    "label" : resp.getReturnValue().label,
                    "name" : resp.getReturnValue().name,
                    "expanded" : resp.getReturnValue().expanded,
                    "items" : resp.getReturnValue().items,
                } 
                 console.log(temp);
                obj.push(temp);
                cmp.set("v.items", obj);
                    
                

                console.log(newItems );
                  console.log('ALBERO');
            }
        });
        
        $A.enqueueAction(action);
    },

    setGrave : function(component,event){

        var categoria = component.get('v.categoriaDettagli');
        var societa = component.get('v.aziendaSelezionata');
        

        var action = component.get('c.getGrave');

        action.setParams({
            categ : categoria,
            societa : societa,
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                component.set('v.isGrave',resp.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getValCoda : function(component,event,helper){


        //component.set('v.codaSelezionata',null);
        //String tipo, String societa, Boolean completo, Boolean delega, Boolean isGrave
        var tipo = component.get('v.descrizioneTipo');
        //var tipo = tipoDettaglio
        var societa = component.get('v.aziendaSelezionata');
        var stato = component.get('v.status');
        var delega = component.get('v.delegaPresente');
        var isGrave = component.get('v.isGrave');        
        var listaCodeFiltrata = component.get('v.listaCodeFiltrata');
        var x = component.get('v.categoriaDettagli')
        
        var action = component.get('c.getValoriCoda');

        action.setParams({
            
            recordId: '',
            societa: societa,
            tipo: tipo,
            categoria: component.get('v.categoriaDettagli'),
            delega_presente:delega
          
        });

        action.setCallback(this,function(response){

            var resp = response.getReturnValue();
            if(response.getState()=='SUCCESS'){
                component.set('v.listaCodeFiltrata',resp);
                this.setGrave(component,event,helper);
            }
            var listaCodeFiltrata2= component.get('v.listaCodeFiltrata');
            this.setGrave(component,event);
        });
        $A.enqueueAction(action);
    }
})