({
  //Load Campagna Picklist
  doInit: function(component, event, helper) {
    var action = component.get("c.getCampName");
    
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var datas = response.getReturnValue().data;
        console.log("donnee recu", datas);
        var arraysOfNames = [];
        datas.forEach(function(element) {
          console.log(element);
          if (!arraysOfNames.includes(element.Name)) {
            arraysOfNames.push(element.Name);
          }
        });
        component.set("v.filterList", arraysOfNames);
        
      } else {
      }
    });
    $A.enqueueAction(action);

  },
  
  Search: function(component, event, helper) {
    var codicedealer = component.find("codicedealer");
    var isValueMissingcod = codicedealer.get("v.validity").valueMissing;
    var campagna = component.find("campagna");
    var isValueMissingCamp = campagna.get("v.validity").valueMissing;

    //if value is missing show error message and focus on field
    if (isValueMissingcod) {
      codicedealer.showHelpMessageIfInvalid();
      codicedealer.focus();
    } else if (isValueMissingCamp) {
      campagna.showHelpMessageIfInvalid();
      campagna.focus();
    } else {
      // else call helper function
      helper.SearchHelper(component, event);
    }
  },
  reset: function(component, event, helper) {
    helper.resetHelper(component, event, helper);
  },
   // For count the selected checkboxes. 
 checkboxSelect: function(component, event, helper) {
  // get the selected checkbox value  
  var selectedRec = event.getSource().get("v.value");
  // get the selectedCount attrbute value(default is 0) for add/less numbers. 
  var getSelectedNumber = component.get("v.selectedCount");
  // check, if selected checkbox value is true then increment getSelectedNumber with 1 
  // else Decrement the getSelectedNumber with 1     
  if (selectedRec == true) {
   getSelectedNumber++;
  } else {
   getSelectedNumber--;
  }
  // set the actual value on selectedCount attribute to show on header part. 
  component.set("v.selectedCount", getSelectedNumber);
 },
 
 // For select all Checkboxes 
 selectAll: function(component, event, helper) {
  //get the header checkbox value  
  var selectedHeaderCheck = event.getSource().get("v.value");
  // get all checkbox on table with "boxPack" aura id (all iterate value have same Id)
  // return the List of all checkboxs element 
  var getAllId = component.find("boxPack");
  // If the local ID is unique[in single record case], find() returns the component. not array   
     if(! Array.isArray(getAllId)){
       if(selectedHeaderCheck == true){ 
          component.find("boxPack").set("v.value", true);
          component.set("v.selectedCount", 1);
       }else{
           component.find("boxPack").set("v.value", false);
           component.set("v.selectedCount", 0);
       }
     }else{
       // check if select all (header checkbox) is true then true all checkboxes on table in a for loop  
       // and set the all selected checkbox length in selectedCount attribute.
       // if value is false then make all checkboxes false in else part with play for loop 
       // and select count as 0 
        if (selectedHeaderCheck == true) {
        for (var i = 0; i < getAllId.length; i++) {
  		  component.find("boxPack")[i].set("v.value", true);
   		 component.set("v.selectedCount", getAllId.length);
        }
        } else {
          for (var i = 0; i < getAllId.length; i++) {
    		component.find("boxPack")[i].set("v.value", false);
   			 component.set("v.selectedCount", 0);
  	    }
       } 
     }  
 
 },

 //For Delete selected records 
 deleteSlctd : function(component,event,helper) {
  var getCheckAllId = component.find("boxPack");
  var selctedRec = [];
  for (var i = 0; i < getCheckAllId.length; i++) {
      
      if(getCheckAllId[i].get("v.value") == true )
      {
          selctedRec.push(getCheckAllId[i].get("v.text")); 
      }
  }
  helper.deleteSelected(component,event,selctedRec);
}
});