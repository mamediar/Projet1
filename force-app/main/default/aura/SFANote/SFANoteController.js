({
    /*handleSaveRecord: function(component, event, helper) {

        component.find("noteEditor").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' +
                           JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));},*/

    reload : function(component, event, helper) {
      component.find("noteEditor").reloadRecord(true);
    },

    launchEvent : function(component, event, helper) {
      var event = $A.get("e.c:SFANoteEvent");
      event.setParams({
        "note": component.get("v.simpleNote.Note__c")
      });
      event.fire();
    }
})