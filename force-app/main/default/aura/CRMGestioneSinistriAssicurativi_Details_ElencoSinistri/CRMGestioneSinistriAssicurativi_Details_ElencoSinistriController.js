({
    downloadExcel : function(component, event, helper) {
       
        var stato = component.find('stato').get('v.value');
        var pratica =   component.find('numPratica').get('v.value');
        if(  stato === undefined ){
            stato = '';
        }
        if(  pratica === undefined || pratica ===''){
            pratica = -1;
        }
        console.log('location.hostname',  window.location.hostname);
        window.open('https://'+window.location.hostname+'/apex/SinistriAssicurativiElencoSinistri?stato='+stato+'&pratica='+pratica+'&parDisp=E');
    },
    doFilter : function(component, event, helper) {
        var spinner = component.find("spinnerSearch");
       $A.util.removeClass(spinner, "slds-hide");
       $A.util.addClass(spinner, "slds-show");
        var stato= component.find('stato').get('v.value');
        var pratica= component.find('numPratica').get('v.value');
       
        helper.doFilter(component, event, helper);
         
    //    $A.util.removeClass(spinner, "slds-show");
    //    $A.util.addClass(spinner, "slds-hide" );
    },
    init : function(component, event, helper) {
        var spinner = component.find("spinnerSearch");
       $A.util.removeClass(spinner, "slds-hide");
       $A.util.addClass(spinner, "slds-show");
        var stato= component.find('stato').get('v.value');
        var pratica= component.find('numPratica').get('v.value');
       
        helper.doFilter(component, event, helper);
   
    },
      downloadPreconvalidaRtf : function(component, event, helper) {
           var id = event.target.id;
      
        var stato = component.find('stato').get('v.value');
        var pratica =   component.find('numPratica').get('v.value');
        if(  stato === undefined ){
            stato = '';
        }
        if(  pratica === undefined || pratica ===''){
            pratica = -1;
        }
        console.log('location.hostname',  window.location.hostname);
        window.open('https://'+window.location.hostname+'/apex/SinistriAssicurativiLetteraPreconvalida?stato='+stato+'&pratica='+pratica+'&parDisp=L&id='+id);
    },
      downloadAmmortamentoRtf : function(component, event, helper) {
           var id = event.target.id;

        var stato = component.find('stato').get('v.value');
        var pratica =   component.find('numPratica').get('v.value');
        if(  stato === undefined ){
            stato = '';
        }
        if(  pratica === undefined || pratica ===''){
            pratica = -1;
        }
        console.log('location.hostname',  window.location.hostname);
        window.open('https://'+window.location.hostname+'/apex/SinistriAssicurativiPianoAmmortamento?stato='+stato+'&pratica='+pratica+'&parDisp=A&id='+id);
    }
})