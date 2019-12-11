({
	NavigateAdministrationCliente : function(component, event, helper){
       helper.AdministrationClienteHelper(component, event, helper);
    },
    NavigateAdministrationAgente : function(component, event, helper){
        helper.AdministrationAgenteHelper(component, event, helper);
     },
	GetYears:function(component, event, helper) {

		helper.GetYearsHelper(component, event, helper);
},
currentMonth: function(component){
var monthNames = new Array("Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno",
"Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre");
var maDate=new Date();
var month=monthNames[maDate.getMonth()];
component.set("v.currentMonth",month);
}
})