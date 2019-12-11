/**
 * @File Name          : PV1763VariazioneAnagraficaGestioneHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 4/11/2019, 16:54:00
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-18 14:01:00   Andrea Vanelli     Initial Version
**/
({
    doInitHelper : function(cmp, event, helper) {
        var parent = cmp.get("v.parent");
        parent.set('v.messaggiErrore',""); 
        
        console.log("case: " + JSON.stringify(cmp.get('v.theCase')));
        //eseguo solo se ho un cliente selezionato e una subtype: necessari per eseguire i controlli sulla fattibilità della variazione

        //vado a verificare i dati del cliente per dare gli alert informativi a schermo
        console.log('userp: : ' +  JSON.stringify(parent.get("v.userData")));
        console.log('BoOp: : ' +  JSON.stringify(parent.get("v.userData.user.Branch_Or_Office__c")));

        var action=cmp.get('c.init');
        action.setParams({
            "theCase" : cmp.get("v.theCase"),
            "branch_or_office" : parent.get("v.userData.user.Branch_Or_Office__c")
        });   
        action.setCallback(this,function(response){
            if(response.getState()=='SUCCESS'){
                //qui mettere codice se c'è altro da fare in caso di SUCCESS
                //parent.set('v.isErroreBloccante',response.getReturnValue().isErroreBloccante);
                //parent.set('v.messaggiErrore',response.getReturnValue().messaggiErrore);
                console.log("response.getReturnValue() : " + JSON.stringify(response.getReturnValue()));
                cmp.set("v.isBO",response.getReturnValue().isBO);
                console.log('isBo : ', cmp.get("v.isBO"));
                cmp.set("v.messaggioPrint",response.getReturnValue().messaggioPrint);
                cmp.set("v.praticheDaRetrocedereList",response.getReturnValue().praticheDaRetrocedere);
                cmp.set("v.carteAttiveList",response.getReturnValue().carteAttive);
            }else{
                cmp.get("v.parent").showToast(response,"","");
            }
        });
        $A.enqueueAction(action);
    },


    save: function (cmp, event, helper) {
        var parent = cmp.get("v.parent");
        parent.set('v.messaggiErrore','');
        cmp.set("v.errorMessage", "");
        

        //controllo se prevista consegna carte
        if(cmp.find("riconsegnaCarte") != undefined){ //esiste il markup
            var carteSelezionateSize = cmp.find("carteAttiveList").getSelectedRows().length;
            if(!cmp.find("riconsegnaCarte").checkValidity()){	//auraMethod checkValidity
                cmp.find("riconsegnaCarte").showHelpMessageIfInvalid();
                parent.set('v.messaggiErrore',parent.get("v.messaggiErrore") + "Indicare se deve essere creata la richiesta di riconsegna carte<br/>");
            }else if(cmp.get("v.riconsegnaCarte") == 'true' && carteSelezionateSize==0){ //true
                //verifico che sia stata selezionata almeno una carta
                    parent.set('v.messaggiErrore',parent.get("v.messaggiErrore") + "Selezionare almeno una carta.<br/>");
            }else if(cmp.get("v.riconsegnaCarte") == 'false' && carteSelezionateSize>0){ //false
                //verifico se è stata selezionata comunque una carta    
                parent.set('v.messaggiErrore',parent.get("v.messaggiErrore") + "Carte selezionate con flag a NO : deselezionare le carte o impostare il flag a SI.<br/>");
            }
        }

        if(parent.get("v.messaggiErrore") == ""){
            cmp.get("v.parent").methodShowWaitComponent(); 
          var action = cmp.get('c.saveCase');
            var carteDaRitirare="";
            var praticheRetrocesse="";
            var appoString="";
            if(cmp.find("carteAttiveList") != undefined){
                for(var i=0;i<cmp.find('carteAttiveList').getSelectedRows().length;i++){
                    appoString = appoString  + cmp.find('carteAttiveList').getSelectedRows()[i].numPratica + ", ";
                }
                if(appoString != ""){
                    carteDaRitirare = "<br>*** A CURA DELLA FILIALE ***<br>";
                    carteDaRitirare = carteDaRitirare + "A seguito del cambio intestazione, e necessario farsi consegnare e tagliare le carte :<br>";
                    carteDaRitirare = carteDaRitirare + appoString;
                    carteDaRitirare = carteDaRitirare + "ed inserire in CRM (per l'Ufficio Customer Service) la richiesta di post-vendita di Duplicato Carta per la riemissione della tessera con il nominativo corretto<br> ";
                }
            }
            if(cmp.find("praticheDaRetrocedereList") != undefined){
                appoString = "";
                for(var i=0;i<cmp.find('praticheDaRetrocedereList').getSelectedRows().length;i++){
                    appoString = appoString + cmp.find('praticheDaRetrocedereList').getSelectedRows()[i].numPratica + ", ";
                }
                if(appoString != ""){
                    praticheRetrocesse = "Pratiche retrocesse: " + appoString + "<br>";
                }
            }
            action.setParam('form',
                {
                    "newStatus": cmp.get('v.newStatus'),
                    "note": cmp.get("v.note"),
                    "attachmentList" : cmp.get('v.allegati') ,
                    "carteDaRitirare" : carteDaRitirare,
                    "praticheRetrocesse" : praticheRetrocesse,
                    "userData" : parent.get('v.userData')
                }
            );
            action.setParam('theCase', cmp.get("v.theCase"));
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                if (response.getState() == 'SUCCESS') {
                    //qui mettere codice se c'è altro da fare in caso di SUCCESS
                    cmp.get("v.parent").showToast(response,"","");                    
                }
                else if (response.getState() === "ERROR") {
                    cmp.get("v.parent").showToast(response,"","");                    
                }
                cmp.get("v.parent").methodHideWaitComponent();
            });
            $A.enqueueAction(action);
                
        }
        
    },    

})