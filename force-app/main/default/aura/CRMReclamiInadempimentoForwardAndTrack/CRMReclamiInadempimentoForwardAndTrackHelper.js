({
    getData : function(component) {
        console.log('init Componente F&T inadempimento');
        var objectId = component.get('v.objectId');        
        var action = component.get("c.getReclamo");
        console.log('reclamoId ' + objectId);
        action.setParams({
            'reclamoId': objectId
        });         
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                component.set('v.reclamo',response.getReturnValue());
                component.set('v.accountId',response.getReturnValue()['AccountId']);
                this.getAccount(component);
                this.getCategoria(component);
                console.log('Success callBack');
            }
            else{
                console.log('uuups la callBack fallisce');
            }
            component.set("v.spinner", false);
        });
        component.set("v.spinner", true);
        $A.enqueueAction(action); 		
    },
    
    getAccount : function(component) {
        console.log('sono nell init dell account');
        var codiceCliente = component.get('v.accountId');
        console.log('accountId =  ' + codiceCliente);
        var action = component.get("c.getCliente");       
        action.setParams({
            'accountId': codiceCliente
        });         
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                component.set('v.cliente',response.getReturnValue());
                console.log('success call back');
                console.log(JSON.stringify(component.get('v.cliente')));
            }
            else
                console.log('uuups la callBack fallisce');
        });
        $A.enqueueAction(action); 		
    },
    
    getToken : function(component) {
        
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            
            if (sParameterName[0] === 'token') { //lets say you are looking for param name - firstName
                sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            }
        }
        
        var action = component.get("c.tokenCTRL");
        
        action.setParam('tokenId',sParameterName[1]);
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                component.set('v.token',response.getReturnValue());
            }
            else{
                console.log('Token fallito');
                console.log(response);
            }
            component.set("v.spinner", false);
        });
        component.set("v.spinner", true);
        $A.enqueueAction(action); 
    },
    
    getCategoria : function(component) {
        var action = component.get("c.getCategoria");
        action.setParam('categoriaId',component.get('v.reclamo')['Categoria_Riferimento__c']);
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                component.set('v.nomeCategoria',response.getReturnValue());
            }
            else{
                console.log('uuups la callBack fallisce');
            }
               component.set("v.spinner", false);
        });
           component.set("v.spinner", true);
        $A.enqueueAction(action); 
    },
    
    loadFiles : function(cmp,event,helper){
        var action = cmp.get("c.getFiles");
        action.setParam('recordId', cmp.get('v.objectId'));
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                console.log('la response di getFiles è = ' + response.getReturnValue());
                cmp.set('v.staticFileList',response.getReturnValue());                
                console.log('staticFiles = '+JSON.stringify(cmp.get('v.staticFileList'))); 
                //cmp.set('v.quantitaFile', cmp.get('v.staticFileList').length);
                //console.log('ci sono ' + cmp.get('v.quantitaFile') + ' files');
            }   
            else{
                console.log('uuups la callBack fallisce');
            }
            cmp.set("v.spinner", false);
        });
        cmp.set("v.spinner", true);
        $A.enqueueAction(action);        
    }
})