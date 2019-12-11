({
	fetchTypePicklist : function(component){
                var action1 = component.get("c.getPicklistvalues");
                action1.setParams({
                    'objectName': component.get("v.ObjectName"),
                    'field_apiname':'Contratto1__c',
                    'nullRequired': false 
                });
                action1.setCallback(this, function(a) {
                    var state = a.getState();
                    if (state === "SUCCESS"){
                        component.set("v.Domanda1Picklist", a.getReturnValue());
                    } 
                });
                $A.enqueueAction(action1);
                   var action2 = component.get("c.getPicklistvalues");
                action2.setParams({
                    'objectName': component.get("v.ObjectName"),
                    'field_apiname':'Secci1__c',
                    'nullRequired': false
                });
                action2.setCallback(this, function(a) {
                    var state = a.getState();
                    if (state === "SUCCESS"){
                        component.set("v.Domanda2Picklist", a.getReturnValue());
                    }
                });
                $A.enqueueAction(action2);
                var action3 = component.get("c.getPicklistvalues");
                action3.setParams({
                                    'objectName': component.get("v.ObjectName"),
                                    'field_apiname':'Precontratto1__c',
                                    'nullRequired': false
                                });
                action3.setCallback(this, function(a) {
                                    var state = a.getState();
                                    if (state === "SUCCESS"){
                                        component.set("v.Domanda3Picklist", a.getReturnValue());
                                    }
                                });
                $A.enqueueAction(action3);
                var action4 = component.get("c.getPicklistvalues");
                action4.setParams({
                                    'objectName': component.get("v.ObjectName"),
                                     'field_apiname':'Questionario_assicurativo1__c',
                                     'nullRequired': false
                                    });
                action4.setCallback(this, function(a) {
                                     var state = a.getState();
                                     if (state === "SUCCESS"){
                                         component.set("v.Domanda4Picklist", a.getReturnValue());
                                     }
                  });
                $A.enqueueAction(action4);
                var action5 = component.get("c.getPicklistvalues");
                action5.setParams({
                                    'objectName': component.get("v.ObjectName"),
                                    'field_apiname':'Contratto_Assicurazione__c',
                                    'nullRequired': false
                });
                action5.setCallback(this, function(a) {
                                   var state = a.getState();
                                   if (state === "SUCCESS"){
                                       component.set("v.Domanda5Picklist", a.getReturnValue());
                                   }
                });
                $A.enqueueAction(action5);
                var action6 = component.get("c.getPicklistvalues");
                action6.setParams({
                                    'objectName': component.get("v.ObjectName"),
                                   'field_apiname': 'Documenti_Assicurazione1__c',
                                   'nullRequired': false
                });
                action6.setCallback(this, function(a) {
                                   var state = a.getState();
                                   if (state === "SUCCESS"){
                                       component.set("v.Domanda6Picklist", a.getReturnValue());
                                   }
                                               });
                $A.enqueueAction(action6);
                var action7 = component.get("c.getPicklistvalues");
                    action7.setParams({ 'objectName': component.get("v.ObjectName"),
                                     'field_apiname': 'Soddisfazione_Cliente1__c',
                                     'nullRequired': false
                    });
                    action7.setCallback(this, function(a) {
                                                       var state = a.getState();
                                                       if (state === "SUCCESS"){
                                                           component.set("v.Domanda7Picklist", a.getReturnValue());
                                                       }
                   });
               $A.enqueueAction(action7);
        
               var action8 = component.get("c.getPicklistvalues");
                   action8.setParams({
                        'objectName': component.get("v.ObjectName"),
                        'field_apiname': 'COM_Filiale_Posta__c',
                        'nullRequired': false
                    });
                    action8.setCallback( this, function (a) 
                    {
                            var state = a.getState();
                            if (state === "SUCCESS") 
                            {
                                component.set("v.Domanda8Picklist", a.getReturnValue());
                            }
                    });
               $A.enqueueAction(action8);
    },
    checkifEmpty:function(list){
        var index = 0;
        list.forEach( function( value)
        {
             if (value === '--Selezionare--') 
             {
                index++;
             }
        });
        if( index > 0 )return true;
        return false;
    },
    showToast : function(message, type){
        	var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            	message: message,
                type : type
            });
            toastEvent.fire();
    },
    checkDomandaAggiuntiva: function( component ){
        var index = 0;
        //Domanda1
        var select1  = document.getElementById("domanda1");
        var Domanda1 = select1.options[select1.selectedIndex].value; 
        if( Domanda1 === 'No' /*|| Domanda1 === 'Non Ricorda'*/ )
        {
            index++;
        }
        
        if( index > 0 )return true;
        return false;    
    },
    checkDomandaAggiuntivaObbligatoria: function( component , event ){
        var DomandaAggiuntivaBoolean = component.get("v.RenderFilialiPostaQuestion");
        if (DomandaAggiuntivaBoolean === true) 
        {
            var ValoreFilialePosta = document.getElementById("domanda8");
            var SelectValoreFilialePosta = ValoreFilialePosta.options[ValoreFilialePosta.selectedIndex].value;
            if( SelectValoreFilialePosta === '--Selezionare--' )
            {
                return true;
                /*
                helper.showToast('Completare l\'intervista selezionando la domanda aggiuntiva ', 'ERROR');
                return;*/
            }
            return false;
        }
        return false;
    },
    checkDomandeCompilate: function( component , event )
    {  
        //Get risposte
        var select = document.getElementById("domanda1");
        var Contratto = select.options[select.selectedIndex].value;
        select = document.getElementById("domanda2");
        var Secci = select.options[select.selectedIndex].value;
        select = document.getElementById("domanda3");
        var Precontratto = select.options[select.selectedIndex].value;
        var select = document.getElementById("domanda7");
        var Soddisfazione_Cliente= select.options[select.selectedIndex].value;
       
        //Get Notes
        var NoteContratto                   = component.find('NomeDomanda1').get('v.value');
        var NoteSecci                       = component.find('NomeDomanda2').get('v.value');
        var NotePrecontratto                = component.find('NomeDomanda3').get('v.value');
        var NoteSoddisfazioneCliente        = component.find('NomeDomanda4').get('v.value');
        
        var Count_Positivi = 0;
        var Count_Negativi = 0;

        var listRes = [];
        listRes.push(Contratto);
        listRes.push(Secci);
        listRes.push(Precontratto);
        listRes.push(Soddisfazione_Cliente);
        return this.checkifEmpty(listRes);
      
    }

})