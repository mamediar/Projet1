({
	init : function(component, event, helper) {
		helper.doInit(component, event);
    helper.loadPDFUtenze(component, event);
    helper.listUtenze(component, event);
  },
  processActivity : function(component, event, helper){
		helper.processActivity(component, event);
  }
})