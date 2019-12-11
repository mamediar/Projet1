({
  SearchHelper: function(component, event) {
    
    var codicedealerValue = component.find("codicedealer").get("v.value");
    var campagnaValue = component.find("campagna").get("v.value");
    component.set('v.Result',[]);
    if(codicedealerValue =='' && campagnaValue =='Selezionatutte'){
      this.showToast('Si prega di compilare i campi','Error')
  }
  else{
    var action = component.get("c.fetchCase");
    
    action.setParams({
      codi: codicedealerValue,
      campagna: campagnaValue
    });
    
     action.setCallback(this, function(response) {
      // hide spinner when response coming from server
      //component.find("Id_spinner").set("v.class", "slds-hide");
      var state = response.getState();
      if (state === "SUCCESS") {
        var storeResponse = response.getReturnValue();

        // if storeResponse size is 0 ,display no record found message on screen.
        if (storeResponse.length == 0) {
          component.set("v.Message", true);
          this.showToast('nessun record trovato','Error')
        } else {
          component.set("v.Message", false);
          var btn = component.find("box3");
          btn.set('v.disabled', false);
        }

        // set searchResult list with return value from server.
        component.set("v.Result", storeResponse);
        component.set("v.dataList", storeResponse);
        this.initializePagination(component, storeResponse);
      } else if (state === "INCOMPLETE") {
        alert("Response is Incompleted");
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            alert("Error message: " + errors[0].message);
          }
        } else {
          alert("Unknown error");
        }
      }
    });
    $A.enqueueAction(action); 
  }
  },
  resetHelper: function(component, event, helper) {
    var data = [];
    component.set("v.Result", data);
    component.set("v.dataList", data);
    var btn = component.find("box3");
          btn.set('v.disabled', true);
    component.set("v.caseObj", {'sObjectType':'Case',
                                               'CaseNumber':'',
                                               'CodiceDealer__c':'',
                                              'NumeroPratica__c':'',
                                              'CampaignId__r.Name':''});
  this.initializePagination(component, data);

  },

   deleteSelected : function(component,event,selctedRec){
    var action = component.get("c.delSlctRec");
    action.setParams({"slctRec": selctedRec});
    action.setCallback(this, function(response){
        var state =  response.getState();
        if(state == "SUCCESS"){
           this.showToast('Successfully Deleted..');
           var datas = response.getReturnValue();            
            var existData = component.get("v.Result");
            existData.forEach(function(element, index) {
              if (selctedRec.indexOf(element.Id) != -1) {
                existData.splice(index, 1);
              }
            });
            component.set("v.Result",existData);            
            console.log("Successfully Deleted..");
            console.log("donnee recu", JSON.stringify(datas));
            
        } else if (state=="ERROR") {
            console.log(action.getError()[0].message);
        }
    });
    $A.enqueueAction(action);
    
},
initializePagination: function (component, datas) {
  var pageSize = component.get("v.pageSize");
  component.set("v.start", 0);
  component.set("v.end", pageSize - 1);
  var totalPage = Math.ceil(datas.length / pageSize);
  component.set("v.totalPage", totalPage);
  var pages = [];
  for (var i = 1; i <= totalPage; i++) {
    pages.push(i);
  }
  component.set("v.pages", pages);
  var paginationList = [];
  for (var i = 0; i < pageSize; i++) {
    if (datas.length > i) paginationList.push(datas[i]);
  }
  component.set("v.totalRecord", datas.length);
  component.set("v.dataList", datas);
  component.set("v.Result", paginationList);
  component.set("v.currentPage", 1);
  this.PageDetails(component, paginationList);
},
PageDetails: function (component, recs) {
  var paginationList = [];
  for (var i = 0; i < recs.length; i++) {
    paginationList.push(recs[i]);
  }
  component.set("v.Result", paginationList);
},
showToast: function(message, type) {
  var toastEvent = $A.get("e.force:showToast");
  toastEvent.setParams({
      message: message,
      type: type
  });
  toastEvent.fire();
},

});