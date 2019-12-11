({
	doInit : function(component, event, helper) {
		helper.doInit(component, event); 
	},
    
    TipoChange : function(component, event, helper) 
    {
        helper.TipoChange(component,event);
    },
    
   GeneraCover : function(component, event, helper) 
    {
		helper.CheckDati(component,event);
      //  helper.CreaCover(component,event);
    },
    CreaNuovo : function(component,event,helper)
    {
        helper.RicaricaPaginaInserimento(component,event);
    }
    
})