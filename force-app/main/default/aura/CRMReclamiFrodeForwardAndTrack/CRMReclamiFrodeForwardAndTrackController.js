({
    
    init : function(cmp, event, helper) {
        console.log('sono nell init');
      
        if (cmp.get("v.pageReference")) {
            cmp.set('v.objectId', cmp.get("v.pageReference").state.c__objectid);
        }
          helper.setFirmaDigitale(cmp);
            helper.getData(cmp);   
            //helper.loadFiles(cmp);
       
    },
    
    isFrodeAccertata : function (cmp, event, helper){
        cmp.set('v.frodeAccertata',event.getParam("value"));
        console.log(cmp.get('v.frodeAccertata'));
    },
    
    isTestoStandard : function (cmp, event, helper){
        var checkTesto = event.getParam("value");
        cmp.set('v.testoStandard',checkTesto);
     
        
        if(checkTesto == 'Si'){
            cmp.set('v.isTesto',true);
            helper.loadStandardTest(cmp);
        }
        else
            cmp.set('v.isTesto',false);
    },
    
    isTestoStandardValue : function (cmp, event, helper){
        cmp.set('v.testoStandardValue', event.getParam("value"));
        console.log(cmp.get('v.testoStandardValue'));
    },
    
    inviaRisposta : function(cmp, event, helper){ 
       

        var selezioneFrode = cmp.get('v.frodeAccertata');
        var selezioneTestoStd = cmp.get('v.testoStandard');
        var testoStandard;
        var std = cmp.find("standardTxt");
        if(std)std.get('v.value'); 
        var sure = cmp.get('v.showModal');
        

        if(selezioneFrode!=null && selezioneTestoStd!=null ){
            
            if(selezioneTestoStd=='Si' && testoStandard=='Seleziona'){
                alert('Selezionare un testo standard.');
                return;
            }
            
        }else{
            alert('Compilare i campi obbligatori contrassegnati con l\'asterisco(*).');
            return;
        }

        cmp.set('v.showModal',true);
		        
    },

    invia : function(cmp,event,helper){
        helper.inviaRispostaDefinitiva(cmp, event, helper);
    },

    goBack : function(cmp,event,helper){
        cmp.set('v.showModal',false);
    },

    
    handleChanges : function(cmp,event,helper){
        console.log('testo standar key ' + cmp.get('v.testoStandardValue'));        
        cmp.set('v.messaggio',cmp.get('v.listaMessaggi')[cmp.get('v.testoStandardValue')]);
        console.log('il messaggio è ' + cmp.get('v.messaggio'));
    },
    
    inserisciTestoStandard : function(cmp, event, helper){
        helper.inserisciTestoStandard(cmp, event);
    },
    
    isFileChange : function(cmp,event,helper){
         
    },
    
    OpenFile :function(component,event,helper){
        console.log('tento di aprire il file!');
     var rec_id = event.currentTarget.id; 
        console.log('id = ' + rec_id);
     var openFile = $A.get('e.lightning:openFiles');
         console.log('navEvt? = ' + openFile);
     openFile.fire({ 
       recordIds: [rec_id]  
     });  
   },
    
     OpenFiless :function(component,event,helper){  
     var rec_id = event.currentTarget.id;  
     $A.get('e.lightning:openFiles').fire({ //Lightning Openfiles event    
       recordIds: [rec_id] //file id  
     });  
   },  
    
    createRecord : function (component, event, helper) {
        /*
        console.log('tento di aprire il file!');
    var navEvt = $A.get("e.force:navigateToSObject");
    console.log('navEvt? = ' + navEvt);
    navEvt.setParams({
      "recordId": cmp.get('v.idf'),
    });
    navEvt.fire();
    */
                        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get('v.idf')
        });
        navEvt.fire();
    },
    
    handleOpenFiles: function(cmp, event, helper) {
		alert('Opening files: ' + event.getParam('recordIds').join(', ') 
			+ ', selected file is ' + event.getParam('selectedRecordId')); 
	},
    
    makeUrl:function(cmp){
    cmp.set('v.url','URLFOR($Action.Attachment.Download, ' + cmp.get('v.idf') + ')');
    }


})