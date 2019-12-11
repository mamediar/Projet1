({
	checkLengthField : function(component, event, helper) {

        var change = event.getSource().get("v.name");
        if(change==='cap'){
            var val = component.find("cap").get('v.value');
            if(val.length > 5){
                var comp = component.find("cap");
                comp.set('v.value',val.substring(0,5));
            }
        }else if(change==='telFisso'){
            var val = component.get('v.telefonoCasa');
            if(val.length > 11){
                //var comp = component.get('v.telefonoCasa');
                component.set('v.telefonoCasa',val.substring(0,11));
            }
        }else if(change==='telCell'){
            var val = component.get('v.telCellulare');
            if(val.length > 10){
                //var comp = component.get('v.telCellulare');
                component.set('v.telCellulare',val.substring(0,10));
            }

        }

	},
	
	checkEmail : function(component, event,helper){
        
        var email = component.get("v.email");
        if(!this.isBlank(email)){
            var pos = email.lastIndexOf(".");
            var dominio = email.substring((pos+1));
            console.log('DOMINIO -> '+dominio);
            if(dominio==="com" || dominio==="it" || dominio==="org"){
                return true;
            }else{
                return false;
            }
        }else{
            return true;
        }
		
	},
    
    showPopupError: function(component) {
        component.find('notifLib').showNotice({
            "header": "Attenzione!",
            "message": component.get("v.popMsg"),
            "variant": "error"
        });
    },

    isBlank : function(x){
        
        if(x === '' || x === null || x === undefined){
            return true;
        }else{
            return false;
        }
        
    },
    showToastError: function(component) {
        component.find('notifLib').showToast({
            "title": "Error",
            "message": component.get("v.toastMsg"),
            "variant": "error"
        });
    }
})