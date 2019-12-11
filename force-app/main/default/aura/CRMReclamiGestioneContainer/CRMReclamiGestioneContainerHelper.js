({
    loadCustomData:function(cmp,helper){
        this.getHasEditAccess(cmp);      
        cmp.set('v.isFrode',cmp.get('v.campiCase')['Is_Frode__c']);
        var action=cmp.get('c.loadCustomDataApex');
        action.setParam('c',cmp.get('v.campiCase'));
        //differenziare compass e futuro/mbc
        console.log('check1');
        if(cmp.get('v.campiCase')['Referenced_Company__c']=='Compass'){
            action.setParam('a',cmp.get('v.campiAccountCliente'));
            console.log('check1.1');
            var s = JSON.stringify(cmp.get('v.campiAccountCliente'));
            
        }
        else{
            action.setParam('f',cmp.get('v.campiAccountCliente')); 
            console.log('check1.2');
            console.log(cmp.get('v.campiAccountCliente'));
        }
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                helper.buildPageBodyAttributes(cmp,resp.getReturnValue(),helper);
                cmp.set('v.isAccountClienteLoaded',true); 
                var cas = cmp.get("v.currentCase");
            } 
            else{ 
                console.log('check3');
                console.log(resp.getError());
                cmp.set('v.serviceError',true);
            }
        });
        $A.enqueueAction(action);
        console.log('check2');
    },
    
    refreshDaServer : function(cmp,event){
        
        var action=cmp.get('c.getCase');
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                //Stato
                var caseObj = resp.getReturnValue();
                cmp.set("v.status", caseObj.Status);
                cmp.set('v.campiCase.Status','F&T Sent');
            }
            this.hideSpinner(cmp);
        });
        //this.showSpinner(cmp);
       // $A.enqueueAction(action);
        
    },
    
    getHasEditAccess:function(cmp){
        var actionEditAccess=cmp.get('c.hasEditAccess');
        actionEditAccess.setParam('caseId',cmp.get('v.recordId'));
        actionEditAccess.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set("v.hasEditAccess", resp.getReturnValue());
            }
            this.hideSpinner(cmp);
        });
        this.showSpinner(cmp);
        $A.enqueueAction(actionEditAccess);
    },
    
    buildPageBodyAttributes:function(cmp,inputObj,helper){
        var cCase=cmp.get('v.campiCase');
        
        //Ricerca Richiesta
        var cliente=inputObj['cliente'];
        cliente['SFId']=cmp.get('v.campiAccountCliente')['Id'];
        cmp.set('v.clienteSelezionatoContainer',cliente);
        cmp.set('v.praticaSelezionataContainer',inputObj['pratica']?inputObj['pratica']:inputObj['praticaFuturo']);
        
        //Header
        cmp.set('v.categoriaDettagli',inputObj['categoria']);
        console.log('CRMReclamiGEstioneContainerHelper categoriaDettagli :::::> ' + cmp.get('v.categoriaDettagli'));
        cmp.set('v.codaSelezionata',inputObj['codaSelezionata']);
        cmp.set('v.oldQueue',inputObj['codaSelezionata']);
        cmp.set('v.status',cCase['Status']);
        if(cmp.get('v.campiCase.Referenced_Company__c')=='MBCredit Solutions'){
            cmp.set('v.areaDettagli',inputObj['tipo']['Area__c']);
        }
        cmp.set('v.tipoDettagli',cCase['Tipo_Reclamo__c']);
        
        cmp.set('v.delegaPresente',cCase['Delega_Presente__c'] ? 'Si' : 'No');
        cmp.set('v.reclamoCompleto',cCase['Reclamo_Completo__c'] ? 'Si' : 'No');
        cmp.set('v.accessoDati',cCase['Has_Acceso_Dati__c'] ? 'Si' : 'No');
        
        //Dettagli
        cmp.set('v.dataComunicazione',cCase['DataSegnalazione__c']);
        cmp.set('v.dataRicezione',cCase['Data_Ricezione__c']);
        cmp.set('v.dataRicezioneIDM',cCase['Data_Ricezione_IDM__c']);
        
        //Data Decisione
        cmp.set('v.dataDecisione',cCase['Data_Decisione__c']);
        //Assegnato
        cmp.set('v.utenteGruppoAssegnato',cCase['Owner_User__c']);
        
        
        cmp.set('v.dataCaricamento',cCase['CreatedDate']);
        cmp.set('v.scadenzaReclamo',cCase['Scadenza_Reclamo__c']);
        cmp.set('v.attribuzioneReclamo',helper.getAttribuzioneReclamo(cmp,cCase['Attribuzione__c']));
        
        //Mittenti
        cmp.set('v.mittentiList',inputObj['mittenti']);
        
        //Allegati
        //cmp.set('v.fileList',inputObj['allegati']);
        
        
        //modalita invio 
        cmp.set('v.modalitaInvioDettagli',inputObj['modalitaInvio']);
        
        //stage Inadempimento
        cmp.set('v.inadempimentoStage', inputObj['stageInadempimento'] ? inputObj['stageInadempimento'] : 'Step 0 – End' );
        
    },
    
    getAttribuzioneReclamo:function(cmp,attrValues){
        var res=[];
        if(attrValues){
            res=attrValues.split(';');
        }
        return res;
    },
    
    checkIfOk:function(cmp,helper){
        var res=true;
        res=helper.checkHeader(cmp);
        console.log('header? = '+res);
        console.log('dettagli? = '+helper.checkDettagli(cmp));
        console.log('mittenti? = '+helper.checkMittenti(cmp));
        console.log('allegati? = '+helper.checkAllegati(cmp));
        console.log('inadempimento = ' +  helper.checkInadempimento(cmp));
        if(res){
            res=helper.checkDettagli(cmp);
        }
        if(res){
            res=helper.checkCliente(cmp);
        }
        if(res){ 
            res=helper.checkMittenti(cmp);
        }
        if(res){
            res=helper.checkAllegati(cmp);
        }
        /*
        if(res && cmp.get('v.campiCase')['Referenced_Company__c']=='Compass'){
            res=helper.checkInadempimento(cmp);
        }
         */
        return res;
    },
    
    checkHeader:function(cmp){/*
        var res=cmp.get('v.isHeaderOk');
        if(!res){
            cmp.set('v.errorMessage',"Controllare i seguenti campi nell'intestazione: "+cmp.get('v.headerMessage'));
        }*/
        var res = true;
        return res;
    },
    
    checkDettagli:function(cmp){
        if(!cmp.get('v.dettagliOutput')){
            cmp.set('v.errorMessage','Controllare il tab Dettagli');
            return false;
        }
        var res=cmp.get('v.isDettagliOk');
        var s = cmp.get('v.dettagliMessage');
        if(!res){
            cmp.set('v.errorMessage',"Controllare i seguenti campi nel tab 'Dettagli': "+s);
        }
        return res;
    },
    
    checkCliente:function(cmp){
        var res=true;
        /*
        if(!cmp.get('v.clienteSelezionatoContainer')){
            res=false;
            cmp.set('v.errorMessage','Per salvare il reclamo è necessario inserire un cliente');
        }
        //TODO: Da sistemare nel caso di Contatto Sconosciuto
        else if(cmp.get('v.aziendaSelezionata')!='MBCredit Solutions' && !cmp.get('v.praticaSelezionataContainer')){
            res=false;
            cmp.set('v.errorMessage','Per salvare il reclamo è necessario selezionare una pratica');
        }
        */
        return res;
    },
    
    checkMittenti:function(cmp){
        var res=true;
        /*
        if(!cmp.get('v.mittentiList') || cmp.get('v.mittentiList').length<=0){
            res=false;
            cmp.set('v.errorMessage','Per salvare il reclamo è necessario inserire almeno un mittente');
        }
		*/        
        return res;
    },
    
    checkAllegati:function(cmp){
        var res=cmp.get('v.fileList').length>0;
        if(!res){
            cmp.set('v.errorMessage','Inserire almeno un Allegato.');
        }
        return res;
    },
    
    checkInadempimento:function(cmp){
        if( cmp.get('v.isInadempimento') ){
           
            return res;
        }
    },
    
    rebuildDettagliOutputObjHelper:function(cmp){ 
        console.log('rebuildDettagliOutputObjHelper ' + JSON.stringify(cmp.get('v.dettagliOutput')));
        var dettagliOut=cmp.get('v.dettagliOutput');
        var headerOut=cmp.get('v.headerOutput');
        var inadempimentoOut=cmp.get('v.inadempimentoOutput');
        var aggiuntiviOut = ! cmp.get('v.outputObjGestione')? null : cmp.get('v.outputObjGestione')["dettagliOutputObj"]["aggiuntiviOutput"];
        var res={};
        // res['currentCase'] = cmp.get('v.campiCase');
        res['chiusuraOutput'] = cmp.get('v.chiusuraOutput'); 
        res['sezInadempimentoOutput'] = inadempimentoOut;
        
        /*  
       * DA MODIFICARE  */
        res['sezInadempimentoOutput']['stageInadempimento'] = cmp.get('v.inadempimentoStage') ? cmp.get('v.inadempimentoStage')  : '';
        //res['sezInadempimentoOutput']['filiale'] = cmp.get('v.filiale') ? cmp.get('v.filiale') : '' ;
        res['sezInadempimentoOutput']['FT_Sent'] = cmp.get('v.FTSent') ? cmp.get('v.FTSent') : 0;
        res['sezInadempimentoOutput']['FT_Received'] = cmp.get('v.FTReceived') ? cmp.get('v.FTReceived') : 0 ;
        res['sezInadempimentoOutput']['gravitaDettagli'] = cmp.get('v.inadempimentoGravita') ? cmp.get('v.inadempimentoGravita') : '' ;
       
        
        
        // res['aggiuntiviOutput'] = cmp.get('v.aggiuntiviOutput');
        // res['contattoPrecedente'] = !cmp.get('v.outputObjGestione') ? null : cmp.get('v.outputObjGestione')["dettagliOutputObj"]["contattoPrecedente"];
        //console.log('CRMReclamiGestioneCOnatinerHelper CHIUSURAOUTPUT:::::::::::::> ' + cmp.get('v.chiusuraOutput'));
        //console.log('CRMReclamiGestioneCOnatinerHelper AGGIUNTIVIOUTPUT:::::::::::::> ' + cmp.get('v.aggiuntiviOutput'));
        res=this.buildHeaderOutput(res,headerOut,dettagliOut,inadempimentoOut);
        if(dettagliOut){
            res=this.buildRadioOutput(res,dettagliOut);
            res['attribuzioneReclamo']=dettagliOut['attribuzioneReclamo'];
        }
        if(cmp.get('v.descrizioneTipo').includes('Assicurazione')){
            res=this.buildAggiuntiviOutput(res,aggiuntiviOut);
        }
        res['codaSelezionata']=cmp.get('v.codaSelezionata');
        //res['contattoPrecedente']=;
        //console.log('Output Object = '+JSON.stringify(res));
        cmp.set('v.dettagliOutputObj',res);
    },
    
    buildHeaderOutput:function(res,headerOut,dettagliOut,inadempimentoOut){
        
        var headerList=['accessoDati','areaDettagli','categoriaDettagli','dataComunicazione',
                        'delegaPresente','tipoDettagli'];
        var dettagliList=['dataComunicazione','dataDecisione','dataRicezione','dataRicezioneIDM'];
        var inadempimentoList=['reclamoCompleto','isGrave'];
        res['headerOutput']={};
        headerList.forEach(function(temp){
            res['headerOutput'][temp]=headerOut[temp];
        });
        if(dettagliOut){
            dettagliList.forEach(function(temp){
                res['headerOutput'][temp]=dettagliOut[temp];
            });
        }
        if(inadempimentoOut){
            inadempimentoList.forEach(function(temp){
                res['headerOutput'][temp]=inadempimentoOut[temp];
            });
        }
        
        return res;
    },
    
    buildRadioOutput:function(res,dettagliOut){
        var comuniList=['abbuonoOutput','risarcimentoOutput','rimborsoOutput','standaloneOutput'];
        var futuroList=['commissioniOutput','provvAccOutput','premioAssOutput',
                        'varieOutput','speseLegeliOutput'];
        res['radioOutput']={};
        res['radioOutput']['comuniOutput']={};
        res['radioOutput']['futuroOutput']={};
        
        // res['radioOutput']['standaloneOutput']={};
        comuniList.forEach(function(temp){
            res['radioOutput']['comuniOutput'][temp]=dettagliOut[temp];
        });
        futuroList.forEach(function(temp){
            res['radioOutput']['futuroOutput'][temp]=dettagliOut[temp];
        });
        // res['radioOutput']['rimborsoOutput']=dettagliOut['rimborsoOutput'];
        //res['radioOutput']['standaloneOutput']=dettagliOut['standaloneOutput'];
        return res;
    }, 
    
    
    buildAggiuntiviOutput:function(res,aggiuntiviOut){
        res['aggiuntiviOutput']={};
        res['aggiuntiviOutput']=aggiuntiviOut;
        return res;
    }, 
    
    salvaReclamoHelper:function(cmp,helper){
        console.log('--------------------------------------------------------------------------------------');
        console.log('-- - Controller JS : CRMReclamiGestioneContainerHelper -- - salvaReclamoHelper - --'); 
        console.log('OUTPUTJSON GESTIONE (SALVARECLAMOHELPER) = ' + JSON.stringify(helper.makeInput(cmp)) );
        
        var action=cmp.get('c.salvaReclamoApex');
        var isQueueChanged;
        var oldQueue = cmp.get('v.oldQueue').DeveloperName;
        var newQueue = cmp.get('v.dettagliOutputObj')['codaSelezionata'].DeveloperName;
        var allFieldMap = helper.makeInput(cmp);
        
        var gravita = cmp.get("v.gravitaDettagli");
        
        if ( oldQueue == newQueue ){
            isQueueChanged = false;
        }
        else{
            isQueueChanged=true;
        }
        
        if (cmp.get('v.isInadempimento')){
            this.cambiamentoGravita(cmp,cmp.get('v.recordId'),gravita,cmp.get('v.inadempimentoStage') ) ;
        }
        
        action.setParam('isQueueChanged', isQueueChanged);
        
        action.setParam('inputJson',JSON.stringify(allFieldMap));
        
        action.setParam('societa', cmp.get('v.campiCase')['Referenced_Company__c']);
        
        action.setParam('fileList',cmp.get('v.fileList'));
        
        if(cmp.get('v.reclamoSelezionato') == null){
            helper.getCurrentReclamo(cmp);
        }
        
        action.setParam('reclamoSelezionato', cmp.get('v.reclamoSelezionato'));
        
        action.setParam('recordId', cmp.get('v.recordId') ) ;
        
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                this.showToast(cmp, 'Salvataggio', 'success','Salvataggio effettuato con successo');
                this.getHasEditAccess(cmp);
            }
            else{
                this.showToast(cmp, 'Successo', 'error','Errore nel salvataggio dei dati');
            }
        });
        $A.enqueueAction(action);
        //helper.IDMFunction (cmp, allFieldMap);
        
    },
    
    makeInput:function(cmp){
        var res={};
        
        //CONTATTOPRECEDENTE AGGIUNTIVIOUTPUT CHIUSURAOUTPUT
        console.log('dettagliOutputObj = ' + JSON.stringify(cmp.get('v.dettagliOutputObj')));
        var attrList=['dettagliOutputObj','clienteSelezionatoContainer','praticaSelezionataContainer',
                      'mittentiList','isSconosciuto'];
        attrList.forEach(function(temp){
            /* if(temp == 'isSconosciuto'){
                res['isSconosciuto'] =  !cmp.get('v.outputObjGestione')  ? 
                    null : 
                !cmp.get('v.outputObjGestione')['isSconosciuto'] ?
                    false : cmp.get('v.outputObjGestione')["isSconosciuto"];
                return;
            }*/
            res[temp]=cmp.get('v.'+temp); 
        }); 
        
        
        
        //TO DELETE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! prova per riempire correttamente i campi
        res['dettagliOutputObj']['contattoPrecedente'] = 'Filiale';
        
        res['dettagliOutputObj']['aggiuntiviOutput'] = {'trattabile':'Trattabile',
                                                        'tipoProdottoVita':'Tipo Prodotto Vita',
                                                        'tipoProdottoDanni':'Tipo Prodotto Danni',
                                                        'areaAziendale':'Area Aziendale',
                                                        'tipoProponente':'Tipo Proponente',
                                                        'areaGeograficaProponente':'Area Geografica Proponente',
                                                        'tipoReclamante':'Tipo Reclamante'};
        res['isSconosciuto'] = 'false';
        
        res['currentCase'] = cmp.get('v.campiCase');
        
        return res;
    },
    
    getCurrentReclamo : function(cmp){
        var action = cmp.get("c.getReclamo");
        action.setParam('recordId', cmp.get('v.recordId'));
        action.setCallback(this,function(resp){            
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.reclamoSelezionato',resp.getReturnValue());
            }            
        });
        
        $A.enqueueAction(action);
    },
    
    IDMFunction : function(cmp, allFieldMap){
        var action = cmp.get('c.hasIDMResponse');
        action.setParams({'data' : allFieldMap,
                          'allegatiSelezionati' : cmp.get('v.allegatiIDMChiusura'),
                          'societa': cmp.get('v.campiCase')['Referenced_Company__c']});
        action.setCallback(this,function(response){
            if (response.getState() == 'SUCCESS'){
                
            }
        });
        $A.enqueueAction(action);
    },
    
    showInadempimento : function (cmp,isDelegaPresente, isGrave, codaSelezionata) {
        
        var azienda=cmp.get('v.campiCase')['Referenced_Company__c'];
        var res = false;  // da IMPOSTARE A FALSE. per ora impostato sempre a TRUE per verificare le logiche di Inadempimento
        console.log('azienda = ' + azienda + ' delegaPresente = ' + isDelegaPresente + ' isGrave = ' + isGrave + ' codaSel = ' + codaSelezionata);
        if(azienda == 'Compass'){
            if (isDelegaPresente && isGrave && codaSelezionata.DeveloperName == 'DN_57'){
                res = true;
                // return res;
            }
            //else 
            // return res;
        }
        
        return res;
    },  
    
    cambiamentoGravita : function (cmp,recordId, gravita, inadempStage){
        var action = cmp.get('c.cambiamentoGravitaChatterFandT');
        action.setParams({'recordId' : recordId,  
                          'gravita' :gravita,
                          'inadempimentoStage' : inadempStage,
                          'societa': cmp.get('v.campiCase')['Referenced_Company__c'] });
        action.setCallback(this,function(response){
            if (response.getState()== 'SUCCESS'){
                console.log('success Inadempimento cambiamento gravita');
            }
        });
        $A.enqueueAction(action);
        
    }, 
    
    salvaPlus : function(cmp,event,helper){
        if(cmp.get("v.utenteGruppoAssegnato")){
            var action = cmp.get('c.salvaPlusApex');
            action.setParams({'recordId' : cmp.get("v.recordId"),  
                              'utenteGruppoAssegnato' :cmp.get("v.utenteGruppoAssegnato")
                             });
            action.setCallback(this,function(response){
                if (response.getState()== 'SUCCESS'){
                    console.log('success utenteGruppoAssegnato');
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    salvaDettagli : function(cmp,event,helper){
        var action = cmp.get("c.salvaDettagliApex");
        action.setParams({
            'recordId' : cmp.get('v.recordId'),
            'dataComunicazione' : cmp.get('v.dataComunicazione'),
            'dataRicezione' : cmp.get('v.dataRicezione'),
            'dataRicezioneIDM' : cmp.get('v.dataRicezioneIDM'),
            'standAloneSelection' : cmp.get('v.standAloneSelection'),
            'rimborsoValue' : cmp.get('v.rimborsoValue'),
            'rimborsoSelection' : cmp.get('v.rimborsoSelection'),
            'abbuonoValue' : cmp.get('v.abbuonoValue'),
            'abbuonoSelection' : cmp.get('v.abbuonoSelection'),
            'risarcimentoValue' : cmp.get('v.risarcimentoValue'),
            'risarcimentoSelection' : cmp.get('v.risarcimentoSelection'),
            'modalitaInvioDettagli' : cmp.get('v.modalitaInvioDettagli')            
        });
        
        action.setCallback(this,function(response){
            if (response.getState()== 'SUCCESS'){
                this.showToast(cmp, 'Salvataggio', 'success','Salvataggio effettuato con successo');
            }
            else
                this.showToast(cmp, 'Salvataggio', 'error','Errore nel salvataggio dati');
        });
        $A.enqueueAction(action);
    },
    
    makeDettagli : function(cmp,event,helper){
        var res = {};
        res['dataComunicazione'] = cmp.get('v.dataComunicazione');
        res['dataRicezione'] = cmp.get('v.dataRicezione');
        res['dataRicezioneIDM'] = cmp.get('v.dataRicezioneIDM');
        res['standAloneSelection'] = cmp.get('v.standAloneSelection');
        res['modalitaInvioDettagli'] = cmp.get('v.modalitaInvioDettagli');
        res['risarcimentoSelection'] = cmp.get('v.risarcimentoSelection');
        res['rimborsoSelection'] = cmp.get('v.rimborsoSelection');
        res['abbuonoSelection'] = cmp.get('v.abbuonoSelection');
        res['utenteGruppoAssegnato'] = cmp.get("v.utenteGruppoAssegnato");
        
        return res;        
        
    },
    
    makeDettagliDouble : function(cmp,event,helper){
        var res = {};
        
        res['abbuonoValue'] = cmp.get('v.abbuonoValue');
        res['risarcimentoValue'] = cmp.get('v.risarcimentoValue');
        res['rimborsoValue'] = cmp.get('v.rimborsoValue');
        
        return res;     
    },
    
    //si rende necessario per l'asincronicità implicita del recorData e dei vari render dei componenti
    getAss : function(cmp,event,helper){
        var action = cmp.get("c.checkTipoReclamo");
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setCallback(this,function(response){
            if (response.getState()== 'SUCCESS'){
                cmp.set('v.initAss',response.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    },
    
    saveAttachmentsAndMittenti : function(cmp){
        var action = cmp.get("c.saveFilesAndMittenti");
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setParam('fileList',cmp.get('v.fileList'));
        action.setParam('mittentiList',cmp.get('v.mittentiList'));
        action.setCallback(this,function(response){
            if (response.getState()== 'SUCCESS'){
                
                
            }
            else
                this.showToast(cmp, 'Errore Salvataggio', 'error', 'allegati e mittenti non salvati');
        });
        $A.enqueueAction(action);
        
    },
    
    checkResponse : function(resp){
        var x = '';
        var y = '';
        var z = '';
        
        if(resp['Case'] == 0){
            x = 'Reclamo Salvato';
            
            if(resp['Attachment'] != 0){
                y = ', ma non sono riuscito a salvare gli allegati';
                
                if(resp['Mittenti'] != 0)
                    z = ' e i mittenti!';
            }
            else if(resp['Mittenti'] != 0)
                z = ', ma non sono riuscito a salvare i mittenti';
            
        }
        else
            x = 'Problemi con il salvataggio del Reclamo';
        
        
        var mess = x+y+z;
        this.showToast(null, 'Salvataggio','success',mess);
        console.log(resp);
        
    },
    
    showToast : function(component, title, type, message ) {
        var toastEvent = $A.get("e.force:showToast"); 
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
            
        });
        toastEvent.fire();
    },
    
    showSpinner : function(cmp) {
        var i = cmp.get("v.spinner");
        i++;
        cmp.set("v.spinner", i);
    },
    
    hideSpinner : function(cmp) {
        var i = cmp.get("v.spinner");
        i--; 
        cmp.set("v.spinner", i);
    },
    refresh : function(cmp, event, helper){
        console.log('Intercetto Evento');
        var dettagli = cmp.find("ReclamiDettagli");
        // if(dettagli!=undefined) dettagli.refresh();
        var risposta = cmp.find("CRMReclamiGestioneRispostaContainerComponent");
        if(risposta!=undefined){
            console.log('Refresho la lettera Risposta');
            risposta.refresh();
        }        
       /*var inadempimento = cmp.find('Inadempimento');
        alert(inadempimento);
        if(inadempimento!=undefined){
            inadempimento.refresh();
            
        } */
        var chiusura = cmp.find("chiusura");
        //if(chiusura!=undefined) chiusura.refresh();
        var cronologiaEventi = cmp.find("CronologiaEventi");
        if(cronologiaEventi!=undefined) cronologiaEventi.refresh();
        var gestioneHeader = cmp.find("gestioneHeader");
        if(gestioneHeader!=undefined) gestioneHeader.refresh();
        
        //Refresh Allegati
        this.getAttachment(cmp,event,helper);
        
    },
 

    refreshAllegati : function(cmp){
        var action = cmp.get("c.refreshAllegatiCtrl");
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setCallback(this,function(response){
            if(response.getState()== 'SUCCESS'){
                var resp = response.getReturnValue();
                
                if(resp.length>0){
                    var list = [];
                    for(var i=0; i<resp.length; i++){
                        var urlFile = '';
                        if(resp[i].Description != 'undefined' && resp[i].Description != null && resp[i].Description != '' && resp[i].Description != undefined){
                            var str = resp[i].Description;
                            var res = str.split("=");
                            urlFile = res[1]; 
                        }
                        var obj = {
                            Name : resp[i].Name,
                            Body : resp[i].Body,
                            Description : resp[i].Description,
                            ContentType : resp[i].ContentType,
                            CreatedDate : resp[i].CreatedDate,
                            ParentId : resp[i].ParentId,
                            Url : urlFile
                        }
                        list.push(obj); 
                    }
                    cmp.set('v.allegatiIDM',list);
                }
            }
            else  this.showToast(cmp, 'Errore Caricamento', 'error', 'Non sono riuscito a caricare gli allegati');
            this.hideSpinner(cmp);
        });
        this.showSpinner(cmp);
        $A.enqueueAction(action);
    },

    creaCopiaReclamoIDM : function(component, event, helper){
        
        var exists = component.get('v.idmValueChiusura');
        var chiusuraTotale = component.find('Chiusura');
        if(exists && chiusuraTotale!=null && chiusuraTotale!=undefined){
            chiusuraTotale.creaReclamoIDM();
        }else{
            return;
        }

    },
    
    getIsCloned : function(component, event, helper){
        
        var isCloned = component.get('v.isCloned');
        var recodId = component.get('v.recordId');
        var action = component.get('c.checkRecordCloned');
        
        action.setParams({
            caseId : recodId
        });
        
        action.setCallback(this,function(response){
            if(response.getState()== 'SUCCESS'){
                var resp = response.getReturnValue();

                component.set('v.isCloned', resp);
            }
            
        });
        $A.enqueueAction(action);
    },

    getAttachment : function(component, event, helper){
        
        var recodId = component.get('v.recordId');
        var action = component.get('c.getFile');
        
        action.setParams({
            caseId : recodId
        });
        
        action.setCallback(this,function(response){
            if(response.getState()== 'SUCCESS'){
                var resp = response.getReturnValue();
                
                if(resp.length>0){
                    var list = [];
                    for(var i=0; i<resp.length; i++){
                        var urlFile = '';
                        if(resp[i].Description != 'undefined' && resp[i].Description != null && resp[i].Description != '' && resp[i].Description != undefined){
                            var str = resp[i].Description;
                            var res = str.split("=");
                            urlFile = res[1]; 
                        }
                        var obj = {
                            Name : resp[i].Name,
                            Body : resp[i].Body,
                            Description : resp[i].Description,
                            ContentType : resp[i].ContentType,
                            CreatedDate : resp[i].CreatedDate,
                            ParentId : resp[i].ParentId,
                            Url : urlFile
                        }
                        list.push(obj); 
                    }
                    component.set('v.fileList',list);
                }
                //component.set('v.allegatiIDM', resp);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    getAttachmentIDM : function(component, event, helper){
        
        var recodId = component.get('v.recordId');
        var action = component.get('c.getFile');
        
        action.setParams({
            caseId : recodId
        });
        
        action.setCallback(this,function(response){
            if(response.getState()== 'SUCCESS'){
                var resp = response.getReturnValue();
                if(resp.length>0){
                    var list = [];
                    for(var i=0; i<resp.length; i++){
                        var urlFile = '';
                        if(resp[i].Description != 'undefined' && resp[i].Description != null && resp[i].Description != '' && resp[i].Description != undefined){
                            var str = resp[i].Description;
                            var res = str.split("=");
                            urlFile = res[1]; 
                        }
                        var obj = {
                            Name : resp[i].Name,
                            Body : resp[i].Body,
                            Description : resp[i].Description,
                            ContentType : resp[i].ContentType,
                            CreatedDate : resp[i].CreatedDate,
                            ParentId : resp[i].ParentId,
                            Url : urlFile
                        }
                        list.push(obj); 
                    }
                    component.set('v.allegatiIDM',list);
                }
                //component.set('v.allegatiIDM', resp);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    isFrode : function(cmp){
        var isFrode = cmp.get("v.isFrode");
        var categoriaDettagli = cmp.get('v.categoriaDettagli');
        var recordId = cmp.get('v.recordId');
        var societa =  cmp.get('v.campiCase.Referenced_Company__c');
       
            var action = cmp.get('c.isFrodeCTRL');
            
            action.setParams({
                categoria : categoriaDettagli.External_Id__c,
                societa : societa,
                recordId : recordId
            });
            
            action.setCallback(this,function(response){
                if(response.getState()== 'SUCCESS'){
                    if(response.getReturnValue() != null){
                       
                        if(response.getReturnValue()){
                         
                            cmp.set('v.campiCase.Status','F&T Sent');
                            cmp.set('v.status', 'F&T Sent');
                            cmp.set('v.isFrode', true);
                            cmp.set('v.campiCase.Is_Frode__c',true);
                        }
                        else{
                            cmp.set('v.isFrode', false);
                            cmp.set('v.campiCase.Is_Frode__c',false);
                        }
                    }

                }
                else alert('errore');
                this.hideSpinner(cmp);
            });
            	this.showSpinner(cmp);
              $A.enqueueAction(action);
        
    },
    
    isInadempimento : function(cmp){
        var isInadempimento = cmp.get("v.isInadempimento");
        if(!isInadempimento) return;
        var recordId = cmp.get('v.recordId');
		var action = cmp.get('c.isInadempimentoChangeStatusCTRL');
            
            action.setParams({
                stageInadempimento : cmp.get("v.inadempimentoStage"),
                recordId : recordId
            });
            
            action.setCallback(this,function(response){
                if(response.getState()== 'SUCCESS'){
                    if(response.getReturnValue() != null){
                       
                        if(response.getReturnValue()){
                         
                            cmp.set('v.campiCase.Status','F&T Sent');
                            cmp.set('v.status', 'F&T Sent');
                        
                        }
                       
                    }

                }
                else alert('errore');
                this.hideSpinner(cmp);
            });
            	this.showSpinner(cmp);
              $A.enqueueAction(action);
        
    },
    showToastSuccess: function(component) {
        component.find('notifLib').showToast({
            "title": "Success",
            "message": component.get("v.toastMsg"),
            "variant": "success"
        });
    },
    
    showToastError: function(component) {
        component.find('notifLib').showToast({
            "title": "Error",
            "message": component.get("v.toastMsg"),
            "variant": "error"
        });
    },

    getValueDecisione:  function(cmp,event,helper){
        
        var dettagli = cmp.find("ReclamiDettagli");
        if(dettagli != undefined){
            
            dettagli.getDecisione(cmp);
        } 
    },
    checkReclamoReadOnly:  function(cmp,event,helper){
        
        var action = cmp.get('c.isReclamoReadOnly');
        var recordId = cmp.get('v.recordId');

        action.setParams({
            caseId : recordId
        });
        action.setCallback(this,function(response){
            if(response.getState()== 'SUCCESS'){
                cmp.set('v.reclamoReadOnly',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

    }

})