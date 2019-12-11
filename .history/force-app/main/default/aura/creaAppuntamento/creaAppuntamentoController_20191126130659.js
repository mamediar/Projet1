({
    doInit: function (component, event, helper) {
        /**
         *  <aura:attribute type="Boolean" name="isValueNome" default="false" />
    <aura:attribute type="Boolean" name="isValueCognome" default="false" />
    <aura:attribute type="Boolean" name="isValueSesso" default="false" />
    <aura:attribute type="Boolean" name="isValueProvincia" default="false" />
    <aura:attribute type="Boolean" name="isValueComune" default="false" />
    <aura:attribute type="Boolean" name="isValueDateNacita" default="false" />
    <aura:attribute type="Boolean" name="isValueCF" default="false" />
    component.set('v.isValueNome',true);
    component.set('v.isValueCognome',true);
    component.set('v.isValueSesso',true);
    component.set('v.isValueProvincia',true);
    component.set('v.isValueComune',true);
    component.set('v.isValueDateNacita',true);
    component.set('v.isValueCF',true);
         */
        var idCliente= component.get("v.idCliente");
        if(idCliente!==""){
            helper.getCliente(component,idCliente);
            component.set("v.existClient",true);
        }else{
            helper.crontrolleDataNascita(component, event, helper);
            helper.getProvinceAndComune(component, event, helper);
        }
        helper.getProductsInteressato(component, event, helper);
        component.set('v.mapMarkers',[ 
            {
                location: {
                City: component.get("v.center"),
            },
            title: 'Italia'
            }]);
    },
    choiceProdottoInteresse:function(component,event,helper){
        helper.choiceProdottoInteresse(component,event,helper);
    },
    controlDateNascita :function(component,event,helper){
        console.log('#################### controle Date Nascita');
        component.set('v.isValueCF',false);  
        helper.controlDateNascita(component,event,helper);
    },
    continuCA1: function (component, event, helper) {
        var cf = component.get('v.cliente.Codice_Fiscale__pc');
        if(cf==null||cf.length!=16){
            helper.showToast('non valida Codice Fiscale','error');
            document.getElementById("idConfermaClient").disabled = true; 
        }else{
            var pattern = /^[a-zA-Z]{6}[0-9]{2}[a-zA-Z][0-9]{2}[a-zA-Z][0-9]{3}[a-zA-Z]$/;
            if (cf.search(pattern) == -1)
            {
                console.log(' cf error');
                helper.showToast('non valida Codice Fiscale','error');
                document.getElementById("idConfermaClient").disabled = true; 
            }else{
                helper.getValueCliente(component);
                helper.checkOperatorFiliale(component, event, helper);
            }
        }
        
    },
    calculCF: function (component, event, helper) {
        var inValidDateNascita = component.get('v.inValidDateNascita');
        if(inValidDateNascita==false){
            component.set('v.cliente.Codice_Fiscale__pc','');
            helper.getValueCliente(component);
        var calculCodFis= component.get("v.calculCodFis");
        if(calculCodFis==true){
            helper.calculCodiceFiscale(component);
        }else{
            helper.showToast("completa tutti i campi obbligatori", "error");
        }
        }else{
            helper.showToast("Errore del date nascita", "error");
        }
    },
    continuCA2: function(component,event,helper){
       
    },
    continuCA3: function(component,event,helper){
        helper.continuCreaAppuntamento2(component, event, helper);
    }, 
    step1Indietro :function(component){
        component.set("v.showStep2", false);
        component.set("v.showStep1", true);
        component.set('v.inValidDateNascita',false);
        component.set('v.showListFiliale',false);
    },
    goContinuCA2: function (component,event,helper) {
        var filialeId = component.get("v.filialeId");
        if(filialeId==""){
        	component.set("v.showStep3", false);
            component.set("v.showStep2", true);
            component.set("v.showListFiliale",false);
        }
        else{
            component.set("v.showStep3", false);
        	component.set("v.showStep1", true);
            component.set('v.testCondition',false);
            
           //document.getElementById("idConfermaClient").disabled = false;
        	//helper.resetValueProdotto(component,event,helper);

        /* 
        var indexProdoto=  component.get("v.indexProdoto");
        document.getElementById("indexProdoto").options[indexProdoto].selected=true;
        console.log('indexProdoto '+indexProdoto);*/
        }
        
    },
    acivityDatetime: function(component,helper){
        helper.controlleActivityDate(component);
    },
    continuCA4: function (component, event, helper) {
        component.set("v.openmodel",true);
    },
    validForm: function (component, event, helper) {
        helper.continuCreaAppuntamento3(component,event,helper);
    },
    closeModal: function (component, event, helper) {
        component.set('v.openmodel',false);
        helper.showToast("la creazione dell'appuntamento è stata annullata","warning");
    },
    goIndietro3: function (component) {
        component.set("v.recapitulate", false);
        component.set("v.showStep3", true);
        
    },
    choiceComune : function(component,event,helper){
        component.set('v.isValueCF',false); 
        helper.getComuneCastale(component,event,helper);
    },
    searchFiliale : function(component,event,helper) {
        //helper.getListFiliale(component);
        var comune = component.get("v.comune");
         var center = String(component.get("v.comune")) ;
        //  component.set("v.center", center);
         console.log('################ ccenter  '+center);
        var indirizzo = component.get("v.indirizzo");
        var provincia = component.get("v.provincia");
        var action = component.get('c.getFiliales');
        var resultat;
        var prodotto = component.get("v.nameDetaglioProdotto");
        action.setParams({"societa": comune,
                           "utenteEsterno": indirizzo,
                           "utenteInterno": provincia,
                           "prodotoName" : prodotto}); 
        action.setCallback(this, function (response) {
            console.log('kkkk ');
            if (response.getState() === "SUCCESS") {
                console.log('kkkk ');
                resultat = response.getReturnValue();
                console.log('kkkk '+ JSON.stringify(resultat));
                if(resultat.listFiliale){
                    component.set("v.showListFiliale",true);
                    console.log('### resultat ', JSON.stringify(resultat));
                    console.log('### resultat listFiliale ', resultat.listFiliale);
                    console.log('### resultat listFillocationiale ', resultat.result);
                    component.set("v.listFiliale",resultat.listFiliale);
                    component.set("v.mapMarkers",resultat.result);
                    component.set('v.mapCenter', {
                        location: {
                        Country: 'Italia'
                    }
                    });
                }else{
                    component.set("v.showListFiliale",false);
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                        message: 'nessuna filiale nel comune',
                        type: 'error'
                        });
        
                    toastEvent.fire();
                }
                
                // set map markers title  
                //component.set('v.markersTitle', 'Google Office locations.');
            }
            else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    filialeSelected :function(component,event,helper){
        var eventSelectecd = event.getSource().get('v.value');
        helper.checkDisponibleDesk(component,eventSelectecd);
    },
    checkCondition: function(component,event,helper){
        var testCondition= document.getElementById("checkbox-unique-id-71");
                        
        var cf = component.get('v.cliente.Codice_Fiscale__pc');
        if(cf==null||cf.length!=16){
            helper.showToast('non valida Codice Fiscale','error');
            document.getElementById("idConfermaClient").disabled = true; 
        }else{

            var pattern = /^[a-zA-Z]{6}[0-9]{2}[a-zA-Z][0-9]{2}[a-zA-Z][0-9]{3}[a-zA-Z]$/;
            if (cf.search(pattern) == -1)
            {
                console.log(' cf error');
                helper.showToast('non valida Codice Fiscale','error');
                document.getElementById("idConfermaClient").disabled = true; 
                testCondition.checked=false;
            }else{
                console.log(' cf ok');
                helper.getValueCliente(component);
                var idCliente= component.get("v.idCliente");
                if(idCliente!=""){
                    component.set('v.inValidDateNascita',false);
                }
                var filialeId = component.get('v.filialeId');
                if(filialeId!==""){
                     component.set('v.inValidDateNascita',false);
                } 
                var testCondition= document.getElementById("checkbox-unique-id-71");
        
                var inValidDateNascita = component.get('v.inValidDateNascita');
                //console.log('checkedCondition '+checkedCondition);
                console.log('inValidDateNascita '+inValidDateNascita);
                var cf= component.get('v.cliente.Codice_Fiscale__pc');
                var nome=component.get('v.cliente.FirstName');
                var cognome=component.get('v.cliente.LastName');
                var prodot=component.get('v.newEvent.Prodotto__c');
                var cliente =component.get("v.cliente");
                var proIntCli= component.get("v.newEvent.Product__c");
                var sessoCli= component.get("v.sesso");
                var dNascita= component.get("v.cliente.Data_Nascita__c");
                console.log('cliente '+JSON.stringify(cliente)+' inValidDateNascita// '+inValidDateNascita);
                if(idCliente!=""||filialeId!=""){
                    if(prodot==''||proIntCli==''){
                        document.getElementById("idConfermaClient").disabled = true;   
                        helper.showToast('completa tutti i campi obbligatori','error');
                        testCondition.checked=false;
                    }else{
                        document.getElementById("idConfermaClient").disabled = false;   
                    }
                }else{
                    if(inValidDateNascita==true||cf==''||nome==''||cognome==''||prodot==''||sessoCli==''||
                    proIntCli==''||dNascita==''){
                        document.getElementById("idConfermaClient").disabled = true;
                        helper.showToast('completa tutti i campi obbligatori','error');
                        var testCondition= document.getElementById("checkbox-unique-id-71");
                        testCondition.checked=false;
                    }
                    else{
                        if(testCondition.checked==true){
                            document.getElementById("idConfermaClient").disabled = false;                                
                        }else{
                            document.getElementById("idConfermaClient").disabled = true;   
                                                         
                        } 
                    }
                }
            }
        }
    },
    controlDateEvent : function(component,event,helper){
        helper.controldateEvent(component,event,helper);
    },
    choiceHoure : function(component,event,helper){
        helper.choiceHoure(component,event,helper);
    },
    isRefreshed: function(component, event, helper) {
        //location.reload();
    },
    closeModifica : function(component){
        component.set('v.openmodelModifica',false);
    },
    closeMessageError : function(component){
        component.set('v.alertMessage',false);
    },
    changeCF : function(component){
        var testCondition= document.getElementById("checkbox-unique-id-71");
        testCondition.checked=false;
        document.getElementById("idConfermaClient").disabled = true;   
        component.set('v.cliente.Codice_Fiscale__pc','');
        component.set('v.isValueCF',false);        
    },
    checkCF : function(component){
        var testCondition= document.getElementById("checkbox-unique-id-71");
        testCondition.checked=false;
        document.getElementById("idConfermaClient").disabled = true;   
        component.set('v.isValueCF',false);        
    },
    /*forzaCodiceFiscale : function(component,event,helper){
        var cf = component.get('v.cliente.Codice_Fiscale__pc');
        if(cf==null||cf.length!=16){
            helper.showToast('non valida Codice Fiscale','error');
            document.getElementById("idConfermaClient").disabled = true; 
        }else{
            var pattern = /^[a-zA-Z]{6}[0-9]{2}[a-zA-Z][0-9]{2}[a-zA-Z][0-9]{3}[a-zA-Z]$/;
            if (cf.search(pattern) == -1)
            {
                console.log(' cf error');
                helper.showToast('non valida Codice Fiscale','error');
                document.getElementById("idConfermaClient").disabled = true; 
            }else{
                console.log(' cf ok');
                //document.getElementById("idConfermaClient").disabled = false; 
            }
        }
    }    
    */
})