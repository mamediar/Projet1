({
  selectStatus : function(component, event, helper) {
    var attachments = component.get('v.attachments');
    var selectedItem = event.currentTarget;
    var index = selectedItem.dataset.index;
    var value = selectedItem.value;
    console.log('index >>>', index);
    console.log('index >>>', selectedItem);
    console.log('index >>>', selectedItem.value);
    attachments[index].Status__c = value;
  },
    updateStatus : function(component,event, helper) {
      helper.updateStato(component);
  },
  setStatus : function(component, event, helper) {
    var selectedItem = event.getSource().get('v.value');
    component.set('v.selectedStatus', selectedItem);
    console.log('selectedItem >>>', selectedItem);
  },
  updateIscritto : function(component,event, helper) {
    helper.updateIscrittos(component);
  },
})