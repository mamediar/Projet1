({
	onClickToDial : function(component, event, helper) {
		window.addEventListener('load', function() {
        sforce.opencti.onClickToDial({listener: listener});
      });

	},
    init: function(cmp, event, helper) {
        
        
        //helper.handleOutgoingCalls(cmp);
    }
})