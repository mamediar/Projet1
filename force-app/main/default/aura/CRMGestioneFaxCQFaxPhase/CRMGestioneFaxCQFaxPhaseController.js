({
    init : function(cmp, event, helper) 
    {
        helper.helperInit(cmp);
    },
    
    redirectToDownload : function(cmp, event, helper)
    {
        var actionName = event.getParam('action');
        var row = event.getParam('row');
        if(row.fileG != '')
        {
            
            
            console.log('********** ACTION : ' + JSON.stringify(row));
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({ 
                "url": '/sfc/servlet.shepherd/version/download/' + row.fileG
            });
            
            urlEvent.fire();
        }
        else
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Attenzione",
                "message": "Report non trovato",
                "type":"Warning"
            });
            toastEvent.fire();
        }
    },
    handleChange : function(cmp, event, helper) 
    {
        helper.helperHandleChange(cmp);
    },
    
    handleClick : function(cmp, event, helper)
    {
        helper.helperClickChange(cmp);
    }
    
    ,
 	SelectedOutSourcer: function (cmp, event) 
    {
        var selectedRows = event.getParam('selectedRows');
        for (var i = 0; i < selectedRows.length; i++){
         	cmp.set('v.selectedOS', selectedRows[i].outsourcer);
        	console.log('SelectedOS :**'+ selectedRows[i].outsourcer);
   		}
    },
    
  	OutsourcerToSent: function (cmp, event, helper) { 
    	var selectedRows = event.getParam('selectedRows');
      //  console.log('selectedRows2  :**'+ selectedRows);
        for (var i = 0; i < selectedRows.length; i++){
         	cmp.set('v.selectedOS2', selectedRows[i].outsourcer);
        	console.log('SelectedOSSent  :**'+ selectedRows[i].outsourcer);
   		}	
    },
    
    sendToOutsourcer: function (cmp, event, helper) { 

    	helper.helpersendToOutsourcer(cmp);
      //  helper.helperClickChange(cmp);
    },
    
    approvaPenali : function (cmp, event, helper) {
	  
        helper.helperApprovaPenali(cmp);    	
    },
    
    generaExcel: function (cmp, event, helper) {
	console.log('PassedOS :**'+ cmp.get("v.selectedOS")); 
        
    	helper.helperGeneraExcel(cmp);
    }

})