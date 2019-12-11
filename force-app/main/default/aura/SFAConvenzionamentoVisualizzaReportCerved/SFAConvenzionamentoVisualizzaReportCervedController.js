({  
   doInit:function(component,event,helper){ 
     var action = component.get("c.getFile");  
     action.setParams({  
       caseId:component.get("v.recordId")  
     });      
     action.setCallback(this,function(response){  
       var state = response.getState();  
       if(state=='SUCCESS'){  
         var fileURL=response.getReturnValue();
         component.set('v.fileURL', fileURL);
         console.log('*****fileURL: '+fileURL);
       } else {
         console.log('*****fileURL NOT SUCCESS');  
       }  
     });  
     $A.enqueueAction(action);  
   },  
    
   OpenFile :function(component,event,helper){
     var fileURL = component.get("v.fileURL"); 
     window.open(fileURL);
     component.set("v.reportOpened",true);
   }
     

     
 })