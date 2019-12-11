({
    init : function(cmp, event, helper) {
        helper.setOptions(cmp);
        helper.loadQueueMailFax(cmp);
        helper.loadProductsHelper(cmp);
        helper.loadConfigsHelper(cmp);
        helper.getCategorieHelper(cmp);
        helper.isPrelavorazioneEnabled(cmp);
        cmp.set('v.isTaskDuplicated', false);
        cmp.set('v.isLoading', false);
    },
    
    loadCategorie : function (cmp,event,helper) {
        helper.filtroTipoPratica(cmp);
        helper.loadCategorieHelper(cmp);
    },
    
    outcomeHandler : function(cmp, event, helper){
        var outcome = event.getSource().get('v.value');
        var inoltroValue = cmp.get('v.inoltroValue');
        var buttonItem = cmp.find('confermaSmistamentoButtonContainer');
        var inoltroItem = cmp.find('inoltroContainer');
        var gestioneItem = cmp.find('gestioneContainer');    
        var esitoValue = cmp.find('esitoItem').get('v.value');
        var optIndex = outcome.split( ';' ) [1]
        var scelta = helper.getOptions()[ optIndex ];
        cmp.set('v.sceltaEsito', esitoValue );  
        switch ( scelta.tipo ) {
            case 'ok'      : cmp.set('v.esitoSize', '6');
                if(gestioneItem) helper.rollShow(gestioneItem.getElement());
                if(inoltroItem) helper.sideHide(inoltroItem.getElement()); 
                if(buttonItem) helper.sideHide(buttonItem.getElement()); 
                break;
            case 'ko'      : cmp.set('v.esitoSize', '6');
                if(gestioneItem) helper.rollHide(gestioneItem.getElement());
                if(inoltroItem) helper.sideHide(inoltroItem.getElement()); 
                if(buttonItem) helper.sideShow(buttonItem.getElement()); break;
            case 'inoltro' : cmp.set('v.esitoSize', '4');
                if(buttonItem) helper.sideShow(buttonItem.getElement()); break;
                break;
            default        : console.log('DEFAULT');
        }

    },
    
    showButton : function(cmp, event, helper){
        var buttonItem = cmp.find('confermaSmistamentoButtonContainer');
        if(buttonItem) helper.sideShow(buttonItem.getElement());
    },
    
    upshot : function(cmp, event , helper){
        var caseId = cmp.get('v.recordId');       
        var scelta = cmp.get('v.esitoValue').split( ';' ) [1]
        var toast = $A.get('e.force:showToast');
        helper.chooseDisposition( cmp, helper.getOptions()[ scelta ] );
    },
    
    createTask : function(cmp, event, helper){
        helper.createTaskHelper(cmp,event,helper);
    },
    
    handleText : function(cmp, event, helper){
        var presaVisioneText = cmp.find('presaVisioneText').getElement();
        $A.util.removeClass(presaVisioneText, 'slds-text-color_error');
        $A.util.removeClass(presaVisioneText, 'slds-text-heading_medium');
    },
    
    getFiltroPratica : function(cmp,event,helper){
        helper.filtroTipoPratica(cmp);
    },
    
    closeTab : function(){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
    }
})