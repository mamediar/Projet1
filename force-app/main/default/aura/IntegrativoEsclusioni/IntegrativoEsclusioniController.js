({
    myAction : function(component, event, helper) {

    },
    redirect: function(component) {
      
      var eventToNavigate = $A.get("e.c:eventNavigateToIntervistaPenetrazione");
      eventToNavigate.fire();
    }
})