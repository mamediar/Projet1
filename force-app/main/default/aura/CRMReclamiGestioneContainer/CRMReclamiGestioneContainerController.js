({
    init:function(cmp,event,helper){
        if(cmp.get('v.dettagliMessage')==undefined){ 
            cmp.set('v.isDettagliOk',true);
        }

        helper.getAss(cmp);
        helper.getAttachmentIDM(cmp,event,helper);
        helper.getAttachment(cmp,event,helper);
        helper.getIsCloned(cmp,event,helper);
        //helper.getValueDecisione(cmp,event,helper);
        helper.checkReclamoReadOnly(cmp,event,helper);
    },
    
    handleCaseUpdated:function(cmp,event,helper){
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED"){
            var azienda=cmp.get('v.campiCase')['Referenced_Company__c'];
            cmp.set('v.accountClienteId',azienda=='Compass' ? cmp.get('v.campiCase')['AccountId'] : cmp.get('v.campiCase')['Account_Futuro_MBCS__c']);

            cmp.set('v.isCaseLoaded',true);
        }
        else{
         
        }
    },
    
    handleAccountUpdated:function(cmp,event,helper){
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED"){
            console.log('Account loaded');
            helper.loadCustomData(cmp,helper);
        }
    },
    
    rebuildDettagliOutputObj:function(cmp,event,helper){  
        
        console.log('//*/*//*/*/*/');
        console.log('avviamento rebuild');
        console.log('/*/*/*/*/*/');
        //helper.rebuildDettagliOutputObjHelper(cmp);
        
    },

    salvaReclamoAuraMethod : function(cmp,event,helper){
      //Inadempimento
             var inadempimento = cmp.find('Inadempimento')
        if (inadempimento != undefined){
           helper.isInadempimento(cmp);
           var x =  inadempimento.salvaReclamoInadempimento();
            if(!x){
              helper.showToast(cmp, 'Errore Salvataggio', 'error', 'Completare il tab inadempimento');
                return;
            }
       
        }

        //Fine Inadempimento
        //Boris Inizio: Salvo la lettera di risposta
        var rispostaContainer = cmp.find("CRMReclamiGestioneRispostaContainerComponent");
    
        if(rispostaContainer != undefined && rispostaContainer != null){
            var letteraRisposta = rispostaContainer.find("LetteraRispostaComponent");
            if(letteraRisposta!=null && letteraRisposta!= undefined){
                letteraRisposta.save();
            }
        }
        //Boris Fine: Salvo la lettera di risposta
        
        
        var coda = cmp.get("v.codaSelezionata");
       
        var json = JSON.stringify(coda);
   
        //Controllo Coda
        
        if(coda == null || coda == undefined || coda == ''){
           helper.showToast(null, 'Salvataggio','error','Devi selezionare una coda');
            return ;
        }
        
        //Controllo Modalità Invio
        
        var invio = cmp.get('v.modalitaInvioDettagli');
        console.log('/###########################/');
        console.log(invio);
         if(invio == null || invio == undefined || invio == 'Selezionare Modalità'){
            
           helper.showToast(null, 'Salvataggio','error','Devi selezionare la modalità di invio');
            return ;
        }
        //Controllo Stato
        var stato = cmp.get('v.status');
        
        if(stato == ''){
              helper.showToast(null, 'Salvataggio','error','Devi selezionare lo stato del Reclamo');
            return;
        }
        
        //Controllo Data Ricezione e Data Ricezione IDM
       	var dataRicez = new Date(cmp.get("v.dataRicezione"));
        var dataRicezIDM = new Date(cmp.get("v.dataRicezioneIDM"));
        var dataComun = new Date(cmp.get("v.dataComunicazione"));
        var today = new Date();
      
      
        
        var risValue = cmp.get("v.rimborsoValue");
        
        
        var caseHeader;
        var gestioneHeader = cmp.find("gestioneHeader");
        if(gestioneHeader != undefined) caseHeader = gestioneHeader.salvaReclamoGestioneHeader();

        
        var cChiusuraDouble = {};
        var cChiusura = {};
        if(cmp.get('v.tabChiusura')){
            var chiusura = cmp.find("Chiusura");
           
            if(chiusura!=null&&chiusura!=undefined){
                cChiusura = chiusura.makeChiusura();
                cChiusuraDouble = chiusura.makeCaseChiusuraDouble();
                //FIX Radio Button con relativi importi

                var azienda = cmp.get('v.campiCase');
                var aziendaSelezionata = azienda.Referenced_Company__c;

                var isValid = 'ko';

                if(aziendaSelezionata == 'Compass'){
                    isValid = chiusura.checkCompass();
                }else if(aziendaSelezionata == 'Futuro'){
                    isValid = chiusura.checkFuturo();
                }else{
                    isValid = chiusura.checkCompass();
                }

                if(isValid != 'ok') {
                    helper.showToast(cmp, 'Errore', 'error', 'Errore '+isValid);
                    return
                }
            }
        }
        
        var cAggiuntivi = {};                
        if(cmp.get('v.initAss') && cmp.get('v.initAggiuntivi')){
            var salvaReclamoCampiAggiuntivi = cmp.find("salvaReclamoCampiAggiuntivi");
            var cAggiuntivi = salvaReclamoCampiAggiuntivi.salvaReclamoCampiAggiuntivi();
        }
        var oldInadempimentoGravita = cmp.get('v.isInadempimento');
        var newInadempimentoGravita = cmp.get('v.inadempimentoGravita') == 'Uff Legale - Grave' ? true : false;
        var isGraveToNonGrave = false;
        if (cmp.get('v.isInadempimento')){
            if ( oldInadempimentoGravita && !newInadempimentoGravita ){
                isGraveToNonGrave = true;
                helper.cambiamentoGravita(cmp,cmp.get('v.recordId'),isGraveToNonGrave,cmp.get('v.inadempimentoStageOld') ) ;
            } else if(! oldInadempimentoGravita && newInadempimentoGravita){
                isGraveToNonGrave= false;
                helper.cambiamentoGravita(cmp,cmp.get('v.recordId'),isGraveToNonGrave,cmp.get('v.inadempimentoStageOld') ) ;
            }
        } 
    
        

        if (!cmp.get('v.isDettagliOk')) {
            //alert(cmp.get('v.dettagliMessage'));
            cmp.set("v.toastMsg", 'Campi vuoti o non validi: '+cmp.get('v.dettagliMessage'));
            helper.showToastError(cmp);
        }else{
            var action= cmp.get("c.salvaReclamoTotale");
            action.setParams({
                'recordId' : cmp.get('v.recordId'),
                'caseHeader' : caseHeader,
                'cChiusura' : cChiusura,
                'cChiusuraDouble' : cChiusuraDouble,
                'caseDettagli' : helper.makeDettagli(cmp),
                'caseDettagliDouble' : helper.makeDettagliDouble(cmp),
                'cAggiuntivi' : cAggiuntivi,
                'isInadempimento' : cmp.get('v.isInadempimento'),
                'stageInadempimento' : cmp.get('v.inadempimentoStage')
            });
            action.setParam('fileList',cmp.get('v.fileList'));
            action.setParam('mittentiList',cmp.get('v.mittentiList'));
            action.setParam('cCliente',cmp.get('v.clienteSelezionatoContainer'));
  
 
            action.setCallback(this,function(resp){
                if(resp.getState()=='SUCCESS'){    
                    //helper.checkResponse(resp.getReturnValue());
                    helper.creaCopiaReclamoIDM(cmp,event,helper);
                    var mappa = resp.getReturnValue();
                    if(mappa.Status != undefined && mappa.Status == '1005'){
                        cmp.set("v.status", 'F&T Sent');
                        cmp.set('v.campiCase.Status','F&T Sent');
                    }
                    helper.refresh(cmp,event, helper);

                    if(cmp.get('v.tabChiusura')){
                        var chiusura = cmp.find("Chiusura");
                        if(chiusura!=null&&chiusura!=undefined){
                            chiusura.refresh();
                        }
                    }
                    helper.refreshDaServer(cmp, event);
					  helper.showToast(cmp, 'Salvataggio', 'success','Salvataggio effettuato con successo');
                } 
                else{    
                    var error = resp.getError();
                    var msg = error[0].message;
                    
                    //alert('Problemi col salvataggio del reclamo...'+msg);
                    cmp.set("v.toastMsg", "Problemi col salvataggio del reclamo...");
                    helper.showToastError(cmp);

                }
                helper.hideSpinner(cmp);
            });
             helper.showSpinner(cmp); 
            $A.enqueueAction(action);
        }
        
       helper.isFrode(cmp);
      
        


    },
    
    checkInitAss : function(cmp,event,helper){    
        cmp.get('v.listaAss').forEach(function(temp){
            if(temp == cmp.get('v.tipoDettagliContainerTipo'))
                cmp.set('v.initAss', true);
            else
                cmp.set('v.initAss', false);                
        });
    },
    
    refresh : function(cmp, event, helper){
        
        helper.refresh(cmp,event, helper);
    },
    
    isInadempimento : function(cmp){
        var isGrave = cmp.get("v.isGrave");
        var delega = cmp.get("v.delegaPresente");
        var coda =  cmp.get("v.codaSelezionata");
        
        var isInadempimento = isGrave && delega == 'Si' && coda.DeveloperName == 'DN_57';
        cmp.set("v.isInadempimento", isInadempimento);
        
    },
    
    refreshDaServer : function(cmp, event, helper){
        helper.refreshDaServer(cmp, event);
    },

    prova: function(cmp, event, helper){
        
        //var label=event.getSource().get('v.label');
        //
        //if(label=='Tipo'){
            var tipo = cmp.get('v.tipoDettagliContainerTipo');
            cmp.set('v.tipoName',tipo);
            var x = cmp.get('v.tipoName');
            
        //}else if(label=='Data Decisione:'){
            var data = cmp.get('v.dataDecisione');
            if(data!=null && data!=undefined){
                cmp.set('v.dataDecisione',data);
                var y = cmp.get('v.dataDecisione');
                
            }
            
        //}

        var tabDettagli = cmp.find("ReclamiDettagli");
        if(tabDettagli!=null && tabDettagli!=undefined){
            
            tabDettagli.reload();
        }
        
        var accessoDati = cmp.get('v.accessoDati');
        
        if(accessoDati){
            var gestioneHeader = cmp.find("gestioneHeader");
            if(gestioneHeader!=null && gestioneHeader!=undefined){
                
                gestioneHeader.setScadenza();
            }
        }
        
        
        
    },
    
    refreshCorrispondenza : function(cmp){
       var corrispondenza = cmp.find("reclamiCorrispondenza");
        if(corrispondenza!=undefined){
           
            corrispondenza.refresh();
        }   
    },
    
    refreshRisposta : function(cmp){
       var risposta = cmp.find("CRMReclamiGestioneRispostaContainerComponent");
        if(risposta!=undefined){
            console.log('Refresho la lettera Risposta');
            risposta.refresh();
        }   
    }
 })