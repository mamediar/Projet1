({
	aggiungiFilUffHelper:function(cmp,mitData){
        if(mitData){
          
            console.log(mitData);
            var MittenteList = cmp.get('v.mittentiList');
           
            var checkDuplicate = false; 
            if(MittenteList == null ||  MittenteList == '')
        	{
                var action=cmp.get('c.makeMittentePrincipale');
            }
            else{
            	var action=cmp.get('c.makeMittente');
                for(var i = 0; i < MittenteList.length; i++)
                {
                	if(MittenteList[i]['Name__c'] == (mitData.First_Name__c+' '+mitData.Last_Name__c))
                    {
                        checkDuplicate = true;
                        break;
                    }
                }
            }
            
            if(checkDuplicate==false)
            {    
                action.setParam('m',mitData);
                action.setCallback(this,function(resp){
                    if(resp.getState()=='SUCCESS'){
                        var mitList=cmp.get('v.mittentiList');
                        mitList.push(resp.getReturnValue());
                        cmp.set('v.mittentiList',mitList);
                    }
                });
                $A.enqueueAction(action);
            }
            else{
                cmp.set("v.toastMsg", "Filiale/Ufficio già inserito");
            	this.showToastError(cmp);
            }
        }
        else{
            cmp.set("v.toastMsg", "Filiale/Ufficio non selezionato");
            this.showToastError(cmp);
            //alert('Filiale/Ufficio non selezionato.');
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