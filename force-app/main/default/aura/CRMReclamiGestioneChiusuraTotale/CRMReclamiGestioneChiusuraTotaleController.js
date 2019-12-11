({
    /*
    init : function(cmp,event,helper){
        cmp.set('v.tabChiusura',true);
        helper.setOption(cmp);
        helper.setInitValue(cmp);

        //RESPONSABILITA
        var hasResponsabilita = cmp.get('v.campiCase.Has_Responsabilita__c');

        helper.getCaseResponsabilita(cmp,event,helper);

        var action = cmp.get("c.getCase");
        var tipoReclamo = cmp.get('v.campiCase.Tipo_Reclamo__c');
        
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.abbuonoValue',resp.getReturnValue()['Abbuono_Chiusura__c']);
                cmp.set('v.abbuonoImportoValue',resp.getReturnValue()['Importo_Abbouno_Chiusura__c']); 
                cmp.set('v.rimborsoValue',resp.getReturnValue()['Has_Rimborso_Accordato__c']);
                cmp.set('v.rimborsoImportoValue',resp.getReturnValue()['Rimborso_Accordato_Importo__c']); 
                cmp.set('v.rimborsoCommValue',resp.getReturnValue()['F_Has_Rimborso_Commissioni_Out__c']);
                cmp.set('v.rimborsoImportoCommValue',resp.getReturnValue()['F_Rimborso_Commissioni_Importo_Out__c']); 
                cmp.set('v.rimborsoProvValue',resp.getReturnValue()['F_Has_Rimborso_Provvigioni_Out__c']);
                cmp.set('v.rimborsoImportoProvValue',resp.getReturnValue()['F_Rimborso_Provvigioni_Importo_Out__c']);
                cmp.set('v.rimborsoVarValue',resp.getReturnValue()['F_Has_Rimborso_Varie_Out__c']);
                cmp.set('v.rimborsoImportoVarValue',resp.getReturnValue()['F_Rimborso_Varie_Importo_Out__c']);
                cmp.set('v.rimborsoPremValue',resp.getReturnValue()['F_Has_Rimborso_Assicurativo_Out__c']);
                cmp.set('v.rimborsoImportoPremValue',resp.getReturnValue()['F_Rimborso_Assicurativo_Importo_Out__c']);
                cmp.set('v.rimborsoLegValue',resp.getReturnValue()['F_Has_Rimborso_Spese_Legali_Out__c']);
                cmp.set('v.rimborsoImportoLegValue',resp.getReturnValue()['F_Rimborso_Spese_Legali_Importo_Out__c']);
                cmp.set('v.risarcimentoValue',resp.getReturnValue()['Has_Risarcimento_accordato__c']);
                cmp.set('v.risarcimentoImportoValue',resp.getReturnValue()['Risarcimento_Accordato_Importo__c']);
                cmp.set('v.fondatoValue',resp.getReturnValue()['Has_Fondato__c']);               
                cmp.set('v.allegatiCompletiValue',resp.getReturnValue()['Has_Allegati_Completi__c']);
                cmp.set('v.sicValue',resp.getReturnValue()['Has_SIC__c']);
                cmp.set('v.socAssValue',resp.getReturnValue()['Has_Assicurative__c']);
                cmp.set('v.socRecValue',resp.getReturnValue()['Has_Recupero__c']); 
                cmp.set('v.riscontroValue',resp.getReturnValue()['Attesa_Riscontro_Cliente__c']);
                cmp.set('v.idmValue',resp.getReturnValue()['Has_Invio_Risposta_IDM__c']);
                cmp.set('v.attesaValue',resp.getReturnValue()['Attesa_Assegno__c']);
                
                // Mi prendo i valori delle picklist (accolto, decisione, interventoAutorita) in  questo modo: l'init mi ritorna il developer name delle picklist,
                // vado a crearmi una mappa dove inverto chiave e valore (della mappa iniziale), e mostro la label
                
                //- - - - - -ACCOLTO -- - - - - -
                var mapds = cmp.get('v.accoltoMap');                                          
                var reversedmap = {};
                var list = cmp.get('v.accoltoList');
                
                list.forEach(function(item){                  
                    reversedmap[mapds[item]] = item;
                });
                
                cmp.set('v.accoltoReversedMap', reversedmap);                
                cmp.set('v.accoltoDettagli', reversedmap[resp.getReturnValue()['Accolto__c']]);    
                
                if(reversedmap[resp.getReturnValue()['Accolto__c']])
                    cmp.set('v.accoltoInitData', reversedmap[resp.getReturnValue()['Accolto__c']]);
                else
                    cmp.set('v.accoltoInitData', 'Seleziona');
                // - - - - -FINE ACCOLTO - - - - 
                
                //- - - - - - DECISIONE    - - - - -                
                var mapDecisione = cmp.get('v.decisioneMap');                                          
                var reversedMapDecisione = {};
                var listDecisione = cmp.get('v.decisioneList');
                
                listDecisione.forEach(function(item){                  
                    reversedMapDecisione[mapDecisione[item]] = item;
                });
                
                cmp.set('v.decisioneReversedMap', reversedMapDecisione);                
                cmp.set('v.decisioneDettagli', reversedMapDecisione[resp.getReturnValue()['Decisione__c']]);    
                
                if(reversedMapDecisione[resp.getReturnValue()['Decisione__c']])
                    cmp.set('v.decisioneForInit', reversedMapDecisione[resp.getReturnValue()['Decisione__c']]);
                else
                    cmp.set('v.decisioneForInit', 'Seleziona');               
                // - - - - FINE DECISIONE- - - - -
                
                // - - - - -INTERVENTO - - - - -
                var mapIntervento = cmp.get('v.interventoMap');                                          
                var reversedMapIntervento = {};
                var listIntervento = cmp.get('v.interventoAutList');
                
                listIntervento.forEach(function(item){                  
                    reversedMapIntervento[mapIntervento[item]] = item;
                });
                
                cmp.set('v.interventoReversedMap', reversedMapIntervento);                
                cmp.set('v.interventoAutDettagli', reversedMapIntervento[resp.getReturnValue()['Intervento_Autorita__c']]);    
                
                if(reversedMapIntervento[resp.getReturnValue()['Intervento_Autorita__c']])
                    cmp.set('v.interventoAutDettagliInit', reversedMapIntervento[resp.getReturnValue()['Intervento_Autorita__c']]);
                else
                    cmp.set('v.interventoAutDettagliInit', 'Seleziona'); 
                //- - - -FINE INTERVENTO - - - - -
                
                
                cmp.set('v.newSocRecValue',resp.getReturnValue()['Societa_di_Recupero__c']);
				cmp.set('v.newSocAssValue',resp.getReturnValue()['Societa_Assicurative__c']);                
                cmp.set('v.newSicValue',resp.getReturnValue()['SIC__c']); 
                
                
                
                //mi prendo i valori della datatable in questo modo: mi prendo una mappa di label\ developer name 
                //e ne prendo una con chiave\valore invertiti: in questo modo nell init ricevo il developer name
                //e mostro la label, mentre più avanti seleziono la label e invio all apex il developer name
                
                //- - - - - - Societa di recupero    - - - - -   
                            
                //var recuperoMap = cmp.get('v.recuperoMap');                                          
                //var reversedrecuperoMap = {};
                //var socRecList = cmp.get('v.socRecList');
                //
                //socRecList.forEach(function(item){                  
                //    reversedrecuperoMap[recuperoMap[item]] = item;
                //});
                //
                //cmp.set('v.socRecReversedMap', reversedrecuperoMap);                                               
                //var societaRecupero = resp.getReturnValue()['Societa_di_Recupero__c'];
                //cmp.set('v.socRecInit',societaRecupero);
                //
                //if(societaRecupero){
                //    var societaRecuperolista = societaRecupero.split(';');
                //    var xSocietaRec = [];                            
                //    societaRecuperolista.forEach(function(item){     
                //        xSocietaRec.push(reversedrecuperoMap[[item]]);
                //    });
                //    cmp.set('v.socRecListInit',xSocietaRec);
                //}
                
                
                //- - - - - - Societa di Assicurazioni   - - - - -       
                        
                //var assicurazioniMap = cmp.get('v.assicurazioniMap');                                          
                //var assicurazioniReversedMap = {};
                //var socAssList = cmp.get('v.socAssList');
                //
                //socAssList.forEach(function(item){                  
                //    assicurazioniReversedMap[assicurazioniMap[item]] = item;
                //});
                //
                //cmp.set('v.assicurazioniReversedMap', assicurazioniReversedMap);
                //var societaAssicurazioni = resp.getReturnValue()['Societa_Assicurative__c'];
                //cmp.set('v.socAssInit',societaAssicurazioni);               
                //
                //if(societaAssicurazioni){             
                //    var societaAssicurazioniLista = societaAssicurazioni.split(';');
                //    var xSocietaAss = [];                            
                //    societaAssicurazioniLista.forEach(function(item){     
                //        xSocietaAss.push(assicurazioniReversedMap[[item]]);
                //    });
                //    cmp.set('v.socAssListInit',xSocietaAss);
                //}
                
                //- - - - - - SIC - - - - -        
                     
                //var sicMap = cmp.get('v.sicMap');                                          
                //var sicReversedMap = {};
                //var sicList = cmp.get('v.sicList');
                //
                //sicList.forEach(function(item){                  
                //    sicReversedMap[sicMap[item]] = item;
                //});
                //
                //cmp.set('v.sicReversedMap', sicReversedMap);               
                //var sic = resp.getReturnValue()['SIC__c'];
                //cmp.set('v.sicInit',sic);
                //
                //if(sic){                    
                //    var sicList = sic.split(';');
                //    var xSic = [];                            
                //    sicList.forEach(function(item){     
                //        xSic.push(sicReversedMap[[item]]);
                //    });
                //    cmp.set('v.sicInitList',xSic);
                //}
                
                
                //controllo il tipo reclamo (ripreso codice precedente)
                if(tipoReclamo =='5446' ||tipoReclamo =='5409' || tipoReclamo =='5445'|| tipoReclamo =='5410'){
                    cmp.set('v.isInterventoAutorita',true);
                }
                console.log('success');
            }
            else
                console.log('error');
        });
        $A.enqueueAction(action);
        
    },*/
    init : function(cmp,event,helper){
        cmp.set('v.tabChiusura',true);
        helper.setOption(cmp);
        helper.setInitValue(cmp);

        var action = cmp.get("c.getCase");
        var tipoReclamo = cmp.get('v.campiCase.Tipo_Reclamo__c');
        
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                
                var status = resp.getReturnValue()['Status'];
                var readOnly = (status=='Gestito' || status=='Stampa IDM') ? true : false;
                
                if(readOnly){
                    cmp.set('v.readOnly',readOnly);
                   
                    //helper.getCaseResponsabilita(cmp,event,helper);

                    var abbuonoValue = resp.getReturnValue()['Abbuono_Chiusura__c'];
                    if(abbuonoValue){
                        cmp.set('v.abbuonoValue',resp.getReturnValue()['Abbuono_Chiusura__c']);
                        cmp.set('v.abbuonoImportoValue',resp.getReturnValue()['Importo_Abbouno_Chiusura__c']);
                    }
                    cmp.set('v.abbuonoValues',abbuonoValue);

                    var rimborsoValue = resp.getReturnValue()['Has_Rimborso_Accordato__c'];
                    if(rimborsoValue){
                        cmp.set('v.rimborsoValue',resp.getReturnValue()['Has_Rimborso_Accordato__c']);
                        cmp.set('v.rimborsoImportoValue',resp.getReturnValue()['Rimborso_Accordato_Importo__c']); 
                    }
                    cmp.set('v.rimborsoValues',rimborsoValue);

                    var rimborsoCommValue = resp.getReturnValue()['F_Has_Rimborso_Commissioni_Out__c'];
                    if(rimborsoCommValue){
                        cmp.set('v.rimborsoCommValue',resp.getReturnValue()['F_Has_Rimborso_Commissioni_Out__c']);
                        cmp.set('v.rimborsoImportoCommValue',resp.getReturnValue()['F_Rimborso_Commissioni_Importo_Out__c']);
                    }
                    cmp.set('v.rimborsoCommValues',rimborsoCommValue);

                    var rimborsoProvValue = resp.getReturnValue()['F_Has_Rimborso_Provvigioni_Out__c'];
                    if(rimborsoProvValue){
                        cmp.set('v.rimborsoProvValue',resp.getReturnValue()['F_Has_Rimborso_Provvigioni_Out__c']);
                        cmp.set('v.rimborsoImportoProvValue',resp.getReturnValue()['F_Rimborso_Provvigioni_Importo_Out__c']);
                    }
                    cmp.set('v.rimborsoProvValues',rimborsoProvValue);
                    
                    var rimborsoVarValue = resp.getReturnValue()['F_Has_Rimborso_Varie_Out__c'];
                    if(rimborsoVarValue){
                        cmp.set('v.rimborsoVarValue',resp.getReturnValue()['F_Has_Rimborso_Varie_Out__c']);
                        cmp.set('v.rimborsoImportoVarValue',resp.getReturnValue()['F_Rimborso_Varie_Importo_Out__c']);
                    }
                    cmp.set('v.rimborsoVarValues',rimborsoVarValue);

                    var rimborsoPremValue = resp.getReturnValue()['F_Has_Rimborso_Assicurativo_Out__c'];
                    if(rimborsoPremValue){
                        cmp.set('v.rimborsoPremValue',resp.getReturnValue()['F_Has_Rimborso_Assicurativo_Out__c']);
                        cmp.set('v.rimborsoImportoPremValue',resp.getReturnValue()['F_Rimborso_Assicurativo_Importo_Out__c']);
                    }
                    cmp.set('v.rimborsoPremValues',rimborsoPremValue);

                    var rimborsoLegValue = resp.getReturnValue()['F_Has_Rimborso_Spese_Legali_Out__c'];
                    if(rimborsoLegValue){
                        cmp.set('v.rimborsoLegValue',resp.getReturnValue()['F_Has_Rimborso_Spese_Legali_Out__c']);
                        cmp.set('v.rimborsoImportoLegValue',resp.getReturnValue()['F_Rimborso_Spese_Legali_Importo_Out__c']);
                    }
                    cmp.set('v.rimborsoLegValues',rimborsoLegValue);

                    var risarcimentoValue = resp.getReturnValue()['Has_Risarcimento_accordato__c'];
                    if(risarcimentoValue){
                        cmp.set('v.risarcimentoValue',resp.getReturnValue()['Has_Risarcimento_accordato__c']);
                        cmp.set('v.risarcimentoImportoValue',resp.getReturnValue()['Risarcimento_Accordato_Importo__c']);
                    }
                    cmp.set('v.risarcimentoValues',risarcimentoValue);

                    cmp.set('v.fondatoValue',resp.getReturnValue()['Has_Fondato__c']);  
                    cmp.set('v.fondatoValues',resp.getReturnValue()['Has_Fondato__c']); 

                    cmp.set('v.allegatiCompletiValue',resp.getReturnValue()['Has_Allegati_Completi__c']);
                    cmp.set('v.allegatiCompletiValues',resp.getReturnValue()['Has_Allegati_Completi__c']);

                    cmp.set('v.sicValue',resp.getReturnValue()['Has_SIC__c']);
                    cmp.set('v.sicValues',resp.getReturnValue()['Has_SIC__c']);

                    cmp.set('v.socAssValue',resp.getReturnValue()['Has_Assicurative__c']);
                    cmp.set('v.socAssValues',resp.getReturnValue()['Has_Assicurative__c']);

                    cmp.set('v.socRecValue',resp.getReturnValue()['Has_Recupero__c']);
                    cmp.set('v.socRecValues',resp.getReturnValue()['Has_Recupero__c']); 

                    cmp.set('v.riscontroValue',resp.getReturnValue()['Attesa_Riscontro_Cliente__c']);
                    cmp.set('v.riscontroValues',resp.getReturnValue()['Attesa_Riscontro_Cliente__c']);

                    cmp.set('v.idmValue',resp.getReturnValue()['Has_Invio_Risposta_IDM__c']);
                    cmp.set('v.idmValues',resp.getReturnValue()['Has_Invio_Risposta_IDM__c']);

                    cmp.set('v.attesaValue',resp.getReturnValue()['Attesa_Assegno__c']);
                    cmp.set('v.attesaValues',resp.getReturnValue()['Attesa_Assegno__c']);

                    
                }
                
                // Mi prendo i valori delle picklist (accolto, decisione, interventoAutorita) in  questo modo: l'init mi ritorna il developer name delle picklist,
                // vado a crearmi una mappa dove inverto chiave e valore (della mappa iniziale), e mostro la label
                
                //- - - - - -ACCOLTO -- - - - - -
                var mapds = cmp.get('v.accoltoMap');                                          
                var reversedmap = {};
                var list = cmp.get('v.accoltoList');
                
                list.forEach(function(item){                  
                    reversedmap[mapds[item]] = item;
                });
                
                cmp.set('v.accoltoReversedMap', reversedmap);                
                cmp.set('v.accoltoDettagli', reversedmap[resp.getReturnValue()['Accolto__c']]);    
                
                if(reversedmap[resp.getReturnValue()['Accolto__c']])
                    cmp.set('v.accoltoInitData', reversedmap[resp.getReturnValue()['Accolto__c']]);
                else
                    cmp.set('v.accoltoInitData', 'Seleziona');
                // - - - - -FINE ACCOLTO - - - - 
                
                //- - - - - - DECISIONE    - - - - -                
                var mapDecisione = cmp.get('v.decisioneMap');                                          
                var reversedMapDecisione = {};
                var listDecisione = cmp.get('v.decisioneList');
                
                listDecisione.forEach(function(item){                  
                    reversedMapDecisione[mapDecisione[item]] = item;
                });
                
                cmp.set('v.decisioneReversedMap', reversedMapDecisione);                
                cmp.set('v.decisioneDettagli', reversedMapDecisione[resp.getReturnValue()['Decisione__c']]);    
                
                if(reversedMapDecisione[resp.getReturnValue()['Decisione__c']])
                    cmp.set('v.decisioneForInit', reversedMapDecisione[resp.getReturnValue()['Decisione__c']]);
                else
                    cmp.set('v.decisioneForInit', 'Seleziona');               
                // - - - - FINE DECISIONE- - - - -
                
                // - - - - -INTERVENTO - - - - -
                var mapIntervento = cmp.get('v.interventoMap');                                          
                var reversedMapIntervento = {};
                var listIntervento = cmp.get('v.interventoAutList');
                
                listIntervento.forEach(function(item){                  
                    reversedMapIntervento[mapIntervento[item]] = item;
                });
                
                cmp.set('v.interventoReversedMap', reversedMapIntervento);                
                cmp.set('v.interventoAutDettagli', reversedMapIntervento[resp.getReturnValue()['Intervento_Autorita__c']]);    
                
                if(reversedMapIntervento[resp.getReturnValue()['Intervento_Autorita__c']])
                    cmp.set('v.interventoAutDettagliInit', reversedMapIntervento[resp.getReturnValue()['Intervento_Autorita__c']]);
                else
                    cmp.set('v.interventoAutDettagliInit', 'Seleziona'); 
                //- - - -FINE INTERVENTO - - - - -
                
                
                cmp.set('v.newSocRecValue',resp.getReturnValue()['Societa_di_Recupero__c']);
				cmp.set('v.newSocAssValue',resp.getReturnValue()['Societa_Assicurative__c']);                
                cmp.set('v.newSicValue',resp.getReturnValue()['SIC__c']); 
                
                
                helper.setnewSicValueReadOnly(cmp,event,helper);
                helper.setnewSocAssValueReadOnly(cmp,event,helper);
                helper.setnewSocRecValueReadOnly(cmp,event,helper);
                

                //controllo il tipo reclamo (ripreso codice precedente)
                if(tipoReclamo =='5446' ||tipoReclamo =='5409' || tipoReclamo =='5445'|| tipoReclamo =='5410'){
                    cmp.set('v.isInterventoAutorita',true);
                }
                console.log('success');

                //RESPONSABILITA
                var hasResponsabilita = cmp.get('v.campiCase.Has_Responsabilita__c');
                helper.getCaseResponsabilita(cmp,event,helper);
            }
            else
                console.log('error');
        });
        $A.enqueueAction(action);
        
    },

    salvaReclamo : function(cmp, event, helper) {
        console.log('salvo il reclamo di chiusura totale!');
        // definisco tutti gli auramethod in modo tale da ritornare true se la response è andata a buon fine,
        // altrimenti false. con questo posso gestirmi la gestione degli errori dei vari aura method e controllare
        // dove avviene l'errore.
        var res = true;
        
        
        
        //Prendo le label delle picklist e le trasformo in API name prima di passarle al server
        var mapIntervento = cmp.get('v.interventoMap');
        var interventoDet = cmp.get('v.interventoAutDettagli');    
        var mapDecisione = cmp.get('v.decisioneMap');
        var decisioneDet = cmp.get('v.decisioneDettagli');        
        var mapAccolto = cmp.get('v.accoltoMap');
        var accoltoDet = cmp.get('v.accoltoDettagli');
        
        cmp.set('v.accoltoInput',mapAccolto[accoltoDet]);      
        cmp.set('v.interventoInput',mapIntervento[interventoDet]);
        cmp.set('v.decisioneInput',mapDecisione[decisioneDet]);
        
        //controllo i valori per le datatable...se non controllo e l utente non cambia niente
        //viene selezionato null di default e ciò non va bene
        
        if(cmp.get('v.sicInput')  == -999){            
            cmp.set('v.sicInput',cmp.get('v.sicInit'));
        }
        
        if(cmp.get('v.socAssInput')  == -999){  
            cmp.set('v.socAssInput',cmp.get('v.socAssInit'));
        }
        
        if(cmp.get('v.socRecInput')  == -999){
            cmp.set('v.socRecInput',cmp.get('v.socRecInit'));
        }
        
        var action = cmp.get("c.salvaChiusuraReclamo");       
        action.setParams({
            'recordId' : cmp.get('v.recordId'),
            'isAbbuono' : cmp.get('v.abbuonoValue'),
            'abbuonoImporto' : cmp.get('v.abbuonoImportoValue'),
            'isRimborso' : cmp.get('v.rimborsoValue'),
            'rimborsoImporto' : cmp.get('v.rimborsoImportoValue'),
            'isRimborsoComm' : cmp.get('v.rimborsoCommValue'),
            'rimborsoImportoComm' : cmp.get('v.rimborsoImportoCommValue'),
            'isRimborsoProv' : cmp.get('v.rimborsoProvValue'),
            'rimborsoImportoProv' : cmp.get('v.rimborsoImportoProvValue'),
            'isRimborsoPrem' : cmp.get('v.rimborsoPremValue'),
            'rimborsoImportoPrem' : cmp.get('v.rimborsoImportoPremValue'),
            'isRimborsoVar' : cmp.get('v.rimborsoVarValue'),
            'rimborsoImportoVar' : cmp.get('v.rimborsoImportoVarValue'),
            'isRimborsoLeg' : cmp.get('v.rimborsoLegValue'),
            'rimborsoImportoLeg' : cmp.get('v.rimborsoImportoLegValue'),
            'isRisarcimento' : cmp.get('v.risarcimentoValue'),
            'risarcimentoImportoValue' : cmp.get('v.risarcimentoImportoValue'),
            'isFondato' : cmp.get('v.fondatoValue'),
            'accolto' : cmp.get('v.accoltoInput'),
            'isAllegatiCompleti' : cmp.get('v.allegatiCompletiValue'),
            'isSic' : cmp.get('v.sicValue'),
            'sic' : cmp.get('v.newSicValue'),
            'isSocAss' : cmp.get('v.socAssValue'),
            'socAss' : cmp.get('v.newSocAssValue'),
            'isSocRec' : cmp.get('v.socRecValue'),
            'socRec' : cmp.get('v.newSocRecValue'),
            'isIdm' : cmp.get('v.idmValue'),
            'isRiscontro' : cmp.get('v.riscontroValue'),
            'isAssegno' : cmp.get('v.attesaValue'),
            'decisione' : cmp.get('v.decisioneInput'),
            'autorita' : cmp.get('v.interventoInput')            
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                //alert('Salvataggio Chiusura Avvenuto');
                cmp.set("v.toastMsg", "Salvataggio Chiusura Avvenuto");
                helper.showToastSuccess(cmp);
                res = true;
            }
            else{
                //alert('Ci sono problemi con il salvataggio di chiusura');
                cmp.set("v.toastMsg", "Ci sono problemi con il salvataggio di chiusura");
                helper.showToastError(cmp);
            	res = false;
            }
        });
        
        $A.enqueueAction(action); 
        return res;
    },
    
    //trasformo in boolean tutti i valori dei RadioButton e setto a zero l'importo dei valori
    //numerici corrispondeni qualora si selezioni "No" 
    //(questo perchè non ha senso la casistica: Rimborso? "No", ImportoRimborso : 1000$)
    
    handleAbbuono: function(cmp,event,helper){
        cmp.set('v.abbuonoImportoValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.abbuonoValue', false);
            cmp.set('v.abbuonoValues', false);
            cmp.set('v.abbuonoImportoValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.abbuonoValue', true);
            cmp.set('v.abbuonoValues', true);
        }else{
            cmp.set('v.abbuonoValue', false);
            cmp.set('v.abbuonoValues', 'none');
            cmp.set('v.abbuonoImportoValue',0);
        }

        var x =  cmp.get('v.abbuonoValue');
        var y =  cmp.get('v.abbuonoValues');
        
    },
    
    handleRimborso: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoValue', false);
            cmp.set('v.rimborsoValues', false);
            cmp.set('v.rimborsoImportoValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoValue', true);
            cmp.set('v.rimborsoValues', true);
        }else{
            cmp.set('v.rimborsoValue', false);
            cmp.set('v.rimborsoValues', 'none');
            cmp.set('v.rimborsoImportoValue',0);
        }

        var x =  cmp.get('v.rimborsoValue');
        var y =  cmp.get('v.rimborsoValues');
        
    },
    
    handleRimborsoComm: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoCommValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoCommValue', false);
            cmp.set('v.rimborsoCommValues', false);
            cmp.set('v.rimborsoImportoCommValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoCommValue', true);
            cmp.set('v.rimborsoCommValues', true);

        }else{
            cmp.set('v.rimborsoCommValue', false);
            cmp.set('v.rimborsoCommValues', 'none');
            cmp.set('v.rimborsoImportoCommValue',0);
        }

        var x =  cmp.get('v.rimborsoCommValue');
        var y =  cmp.get('v.rimborsoCommValues');
        

    },
    
    handleRimborsoProv: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoProvValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoProvValue', false);
            cmp.set('v.rimborsoProvValues', false);
            cmp.set('v.rimborsoImportoProvValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoProvValue', true);
            cmp.set('v.rimborsoProvValues', true);

        }else{
            cmp.set('v.rimborsoProvValue', false);
            cmp.set('v.rimborsoProvValues', 'none');
            cmp.set('v.rimborsoImportoProvValue',0);
        }

        var x =  cmp.get('v.rimborsoProvValue');
        var y =  cmp.get('v.rimborsoProvValues');
        
    },
    
    handleRimborsoPrem: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoPremValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoPremValue', false);
            cmp.set('v.rimborsoPremValues', false);
            cmp.set('v.rimborsoImportoPremValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoPremValue', true);
            cmp.set('v.rimborsoPremValues', true);

        }else{
            cmp.set('v.rimborsoPremValue', false);
            cmp.set('v.rimborsoPremValues', 'none');
            cmp.set('v.rimborsoImportoPremValue',0);
        }

        var x =  cmp.get('v.rimborsoPremValue');
        var y =  cmp.get('v.rimborsoPremValues');
        
    },
    
    handleRimborsoVar: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoVarValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoVarValue', false);
            cmp.set('v.rimborsoVarValues', false);
            cmp.set('v.rimborsoImportoVarValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoVarValue', true);
            cmp.set('v.rimborsoVarValues', true);

        }else{
            cmp.set('v.rimborsoVarValue', false);
            cmp.set('v.rimborsoVarValues', 'none');
            cmp.set('v.rimborsoImportoVarValue',0);
        }

        var x =  cmp.get('v.rimborsoVarValue');
        var y =  cmp.get('v.rimborsoVarValues');
        
    },
    
    handleRimborsoLeg: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoLegValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoLegValue', false);
            cmp.set('v.rimborsoLegValues', false);
            cmp.set('v.rimborsoImportoLegValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoLegValue', true);
            cmp.set('v.rimborsoLegValues', true);

        }else{
            cmp.set('v.rimborsoLegValue', false);
            cmp.set('v.rimborsoLegValues', 'none');
            cmp.set('v.rimborsoImportoLegValue',0);
        }

        var x =  cmp.get('v.rimborsoLegValue');
        var y =  cmp.get('v.rimborsoLegValues');
        
    },
    
    handleRisarcimento: function(cmp,event,helper){
        cmp.set('v.risarcimentoImportoValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.risarcimentoValue', false);
            cmp.set('v.risarcimentoValues', false);
            cmp.set('v.risarcimentoImportoValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.risarcimentoValue', true);
            cmp.set('v.risarcimentoValues', true);

        }else{
            cmp.set('v.risarcimentoValue', false);
            cmp.set('v.risarcimentoValues', 'none');
            cmp.set('v.risarcimentoImportoValue',0);
        }

        var x =  cmp.get('v.risarcimentoValue');
        var y =  cmp.get('v.risarcimentoValues');
        
    },
    
    handleFondato: function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.fondatoValue', false);
            cmp.set('v.fondatoValues', false);
        }   
        else if(event.getParam("value") == 'true'){
            cmp.set('v.fondatoValue', true);
            cmp.set('v.fondatoValues', true);

        }else{
            cmp.set('v.fondatoValue', false);
            cmp.set('v.fondatoValues', 'none');
        }

        var x =  cmp.get('v.fondatoValue');
        var y =  cmp.get('v.fondatoValues');
        
    },
    
    handleAllegatiCompleti : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.allegatiCompletiValue', false); 
            cmp.set('v.allegatiCompletiValues', false);  
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.allegatiCompletiValue', true);
            cmp.set('v.allegatiCompletiValues', true);
        }else{
            cmp.set('v.allegatiCompletiValue', false);
            cmp.set('v.allegatiCompletiValues', 'none');
        }

        var x =  cmp.get('v.allegatiCompletiValue');
        var y =  cmp.get('v.allegatiCompletiValues');
        
    },
    
    handleSic : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.sicValue', false);  
            cmp.set('v.sicValues', false);
        } 
        else if(event.getParam("value") == 'true'){
            cmp.set('v.sicValue', true);
            cmp.set('v.sicValues', true);
        }else{
            cmp.set('v.sicValue', false);
            cmp.set('v.sicValue', 'none');
        }

        var x =  cmp.get('v.sicValue');
        var y =  cmp.get('v.sicValues');
        
    },
    
    handleSocAss : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.socAssValue', false); 
            cmp.set('v.socAssValues', false);  
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.socAssValue', true);
            cmp.set('v.socAssValues', true);

        }else{
            cmp.set('v.socAssValue', false);
            cmp.set('v.socAssValues', 'none');
        }

        var x =  cmp.get('v.socAssValue');
        var y =  cmp.get('v.socAssValues');
        
    },
    
    handleSocRec : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.socRecValue', false);
            cmp.set('v.socRecValues', false); 
        }   
        else if(event.getParam("value") == 'true'){
            cmp.set('v.socRecValue', true);
            cmp.set('v.socRecValues', true);

        }else{
            cmp.set('v.socRecValue', false);
            cmp.set('v.socRecValues', 'none');
        }

        var x =  cmp.get('v.socRecValue');
        var y =  cmp.get('v.socRecValues');
        
    },
    
    handleIdmValue : function(cmp,event,helper){
        
        if(event.getParam("value") == 'false'){
            cmp.set('v.idmValue', false); 
            cmp.set('v.idmValues', false);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.idmValue', true);
            cmp.set('v.idmValues', true);

        }else{
            cmp.set('v.idmValue', false);
            cmp.set('v.idmValues', 'none');
        }

        var x =  cmp.get('v.idmValue');
        var y =  cmp.get('v.idmValues');
        
            
    },
    
    handleRiscontroValue : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.riscontroValue', false);
            cmp.set('v.riscontroValues', false);   
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.riscontroValue', true);
            cmp.set('v.riscontroValues', true);

        }else{
            cmp.set('v.riscontroValue', false);
            cmp.set('v.riscontroValues', 'none');
        }

        var x =  cmp.get('v.riscontroValue');
        var y =  cmp.get('v.riscontroValues');
        
    },
    
    handleAttesaValue : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.attesaValue', false); 
            cmp.set('v.attesaValues', false);
        }  
        else if(event.getParam("value") == 'true'){
            cmp.set('v.attesaValue', true);
            cmp.set('v.attesaValues', true);

        }else{
            cmp.set('v.attesaValue', false);
            cmp.set('v.attesaValues', 'none');
        }

        var x =  cmp.get('v.attesaValue');
        var y =  cmp.get('v.attesaValues');
        
    },

    handleDecisione : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.decisioneDettagli', false); 
            
        }  
        else if(event.getParam("value") == 'true'){
            cmp.set('v.decisioneDettagli', true);
           

        }else{
            cmp.set('v.decisioneDettagli', 'none');
        }
        
    },
    
    getSelectedSocRec : function(cmp,event){
        var selectedRows = event.getParam('selectedRows');
        var socRecApiMap = cmp.get('v.recuperoMap');
        var x = '';        
        selectedRows.forEach(function(item){
            x = x + cmp.get('v.recuperoMap')[item[Object.keys(item)]] + ';';
        });
        cmp.set('v.socRecInput',x);        
    },
    
    getSelectedSocAss : function(cmp,event){
        var selectedRows = event.getParam('selectedRows');
        var socAssApiMap = cmp.get('v.assicurazioniMap');        
        var x = '';
        selectedRows.forEach(function(item){
            x = x + cmp.get('v.assicurazioniMap')[item[Object.keys(item)]] + ';';
        });        
        cmp.set('v.socAssInput',x);        
    },
    
    getSelectedSic : function(cmp,event){
        var selectedRows = event.getParam('selectedRows');
        var socSicApiMap = cmp.get('v.sicMap');
        var x = '';        
        selectedRows.forEach(function(item){
            x = x + cmp.get('v.sicMap')[item[Object.keys(item)]] + ';';
        });        
        cmp.set('v.sicInput',x);              
    },    
    
    // funzioni per deselezionare il valore iniziale e non far apparire due volte lo stesso valore nella picklist    
    focusDecisione : function(cmp,event){
        cmp.set('v.decisioneForInit','Seleziona');        
    },
    
    focusAccolto : function(cmp,event){
        cmp.set('v.accoltoInitData','Seleziona');               
    },
    
    focusIntervento : function(cmp,event){
        cmp.set('v.interventoAutDettagliInit','Seleziona');
    },

    makeCaseChiusura : function(cmp, event, helper) {
        var res = {};
        
        //Prendo le label delle picklist e le trasformo in API name prima di passarle al server
        var mapIntervento = cmp.get('v.interventoMap');
        var interventoDet = cmp.get('v.interventoAutDettagli');    
        var mapDecisione = cmp.get('v.decisioneMap');
        var decisioneDet = cmp.get('v.decisioneDettagli');        
        var mapAccolto = cmp.get('v.accoltoMap');
        var accoltoDet = cmp.get('v.accoltoDettagli');
        
        cmp.set('v.accoltoInput',mapAccolto[accoltoDet]);      
        cmp.set('v.interventoInput',mapIntervento[interventoDet]);
        cmp.set('v.decisioneInput',mapDecisione[decisioneDet]);
        
        //controllo i valori per le datatable...se non controllo e l utente non cambia niente
        //viene selezionato null di default e ciò non va bene
        
        if(cmp.get('v.sicInput')  == -999){            
            cmp.set('v.sicInput',cmp.get('v.sicInit'));
        }
        
        if(cmp.get('v.socAssInput')  == -999){  
            cmp.set('v.socAssInput',cmp.get('v.socAssInit'));
        }
        
        if(cmp.get('v.socRecInput')  == -999){
            cmp.set('v.socRecInput',cmp.get('v.socRecInit'));
        }        
        
        res['isAbbuono'] = cmp.get('v.abbuonoValue');                   
        res['abbuonoImporto'] = cmp.get('v.abbuonoImportoValue');
            res['isRimborso'] = cmp.get('v.rimborsoValue');
            res['rimborsoImporto'] = cmp.get('v.rimborsoImportoValue');
            res['isRimborsoComm'] = cmp.get('v.rimborsoCommValue');
            res['rimborsoImportoComm'] = cmp.get('v.rimborsoImportoCommValue');
            res['isRimborsoProv'] = cmp.get('v.rimborsoProvValue');
            res['rimborsoImportoProv'] = cmp.get('v.rimborsoImportoProvValue');
            res['isRimborsoPrem'] = cmp.get('v.rimborsoPremValue');
            res['rimborsoImportoPrem'] = cmp.get('v.rimborsoImportoPremValue');
            res['isRimborsoVar'] = cmp.get('v.rimborsoVarValue');
            res['rimborsoImportoVar'] = cmp.get('v.rimborsoImportoVarValue');
            res['isRimborsoLeg'] = cmp.get('v.rimborsoLegValue');
            res['rimborsoImportoLeg'] = cmp.get('v.rimborsoImportoLegValue');
            res['isRisarcimento'] = cmp.get('v.risarcimentoValue');
            res['risarcimentoImportoValue'] = cmp.get('v.risarcimentoImportoValue');
            res['isFondato'] = cmp.get('v.fondatoValue');
            res['accolto'] = cmp.get('v.accoltoInput');
            res['isAllegatiCompleti'] = cmp.get('v.allegatiCompletiValue');
            res['isSic'] = cmp.get('v.sicValue');
            res['sic'] = cmp.get('v.newSicValue');
            res['isSocAss'] = cmp.get('v.socAssValue');
            res['socAss'] = cmp.get('v.newSocAssValue');
            res['isSocRec'] = cmp.get('v.socRecValue');
            res['socRec'] = cmp.get('v.newSocRecValue');
            res['isIdm'] = cmp.get('v.idmValue');
            res['isRiscontro'] = cmp.get('v.riscontroValue');
            res['isAssegno'] = cmp.get('v.attesaValue');
            res['decisione'] = cmp.get('v.decisioneInput');
            res['autorita'] = cmp.get('v.interventoInput');            
        
        return res;
    },   
    
    makeCaseChiusuraDouble : function(cmp, event, helper) {
        var res = {};
        
        res['abbuonoImporto'] = cmp.get('v.abbuonoImportoValue');
        res['rimborsoImporto'] = cmp.get('v.rimborsoImportoValue');       
        res['rimborsoImportoComm'] = cmp.get('v.rimborsoImportoCommValue');
        res['rimborsoImportoProv'] = cmp.get('v.rimborsoImportoProvValue');   
        res['rimborsoImportoPrem'] = cmp.get('v.rimborsoImportoPremValue');    
        res['rimborsoImportoVar'] = cmp.get('v.rimborsoImportoVarValue');
        res['rimborsoImportoLeg'] = cmp.get('v.rimborsoImportoLegValue');
        res['risarcimentoImportoValue'] = cmp.get('v.risarcimentoImportoValue');
        
        
        return res;
    },
    
    checkImporto :function(component, event){
        var importo = event.getSource().get("v.value")+'';
        if(importo.includes('.')){
            var intero = importo.split('.')[0];
            var decimale = importo.split('.')[1];
            if(decimale.length > 2) decimale = decimale.substring(0,2);
            event.getSource().set("v.value", intero+'.'+decimale);
        }
       
    },
    
    checkCompass : function(component, event, helper){

        var none = 'none';

        var abbuono = component.get("v.abbuonoValue");
        var abbuonoValues = component.get("v.abbuonoValues");
        if(abbuonoValues==none) return 'Completa il campo Abbuono';
        var abbuonoValue= component.get("v.abbuonoImportoValue");
        
        if(abbuono && (abbuonoValue == undefined || abbuonoValue == '' || abbuonoValue <= 0)) return 'Completa il campo Importo Abbuono con un valore positivo';
        
        var rimborso = component.get("v.rimborsoValue");
        var rimborsoValues = component.get("v.rimborsoValues");
        if(rimborsoValues==none) return 'Completa il campo Rimborso';
        var rimborsoValue= component.get("v.rimborsoImportoValue");
        if(rimborso && (rimborsoValue == undefined || rimborsoValue == '' || rimborsoValue <= 0)) return 'Completa il campo Importo Rimborso con un valore positivo';
        
        var commissioni = component.get("v.rimborsoCommValue");
        var commissioniValues = component.get("v.commissioniValues");
        if(commissioniValues==none) return 'Completa il campo Rimborso Commissioni';
        var commissioniValue= component.get("v.rimborsoImportoCommValue");
        if(commissioni && (commissioniValue == undefined || commissioniValue == '' || commissioniValue <= 0)) return 'Completa il campo Importo Rimborso Commissioni con un valore positivo';
        /* 
        var rimborsoProv = component.get("v.rimborsoProvValue");
        var rimborsoProvValues = component.get("v.rimborsoProvValues");
        if(rimborsoProvValues==none) return 'Completa il campo Rimborso provvigioni/accessorie';
        var rimborsoProvValue= component.get("v.rimborsoImportoProvValue");
        if(rimborsoProv && (rimborsoProvValue == undefined || rimborsoProvValue == '')) return 'Completa il campo Importo Rimborso provvigioni/accessorie';
        
        var rimborsoPrem= component.get("v.rimborsoPremValue");
        var rimborsoPremValues = component.get("v.rimborsoPremValues");
        if(rimborsoPremValues==none) return 'Completa il campo Rimborso premio assicurativo';
        var rimborsoPremValue= component.get("v.rimborsoImportoPremValue");
        if(rimborsoPrem && (rimborsoPremValue == undefined || rimborsoPremValue == '')) return 'Completa il campo Importo Rimborso premio assicurativo';
         
        var rimborsoVar= component.get("v.rimborsoVarValue");
        var rimborsoVarValues = component.get("v.rimborsoVarValues");
        if(rimborsoVarValues==none) return 'Completa il campo Rimborso varie';
        var rimborsoVarValue= component.get("v.rimborsoImportoVarValue");
        if(rimborsoVar && (rimborsoVarValue == undefined || rimborsoVarValue == '')) return 'Completa il campo Importo Rimborso varie';
         
        var rimborsoLeg= component.get("v.rimborsoLegValue");
        var rimborsoLegValues = component.get("v.rimborsoLegValues");
        if(rimborsoLegValues==none) return 'Completa il campo Rimborso spese legali';
        var rimborsoLegValue= component.get("v.rimborsoImportoLegValue");
        if(rimborsoLeg && (rimborsoLegValue == undefined || rimborsoLegValue == '')) return 'Completa il campo Importo Rimborso spese legali';
        */
        var risarcimento= component.get("v.risarcimentoValue");
        var risarcimentoValues = component.get("v.risarcimentoValues");
        if(risarcimentoValues==none) return 'Completa il campo Risarcimento';
        var risarcimentoValue= component.get("v.risarcimentoImportoValue");
        if(risarcimento && (risarcimentoValue == undefined || risarcimentoValue == '' || risarcimentoValue <= 0)) return 'Completa il campo Risarcimento con un valore positivo';

        var fondatoValues = component.get("v.fondatoValues");
        if(fondatoValues==none) return 'Completa il campo Fondato';

        var attesaValues = component.get("v.attesaValues");
        if(attesaValues==none) return 'Completa il campo Attesa assegno';

        var allegatiCompletiValues = component.get("v.allegatiCompletiValues");
        if(allegatiCompletiValues!=true) return 'Il campo Allegati completi deve essere impostato su \'Si\'';

        var sicValues = component.get("v.sicValues");
        if(sicValues==none) return 'Completa il campo Sic';
        var sicValue= component.get("v.sicValue");
        var sicSel = component.get("v.newSicValue");
        if(sicValue && (sicSel == undefined || sicSel == '')) return 'Selezionare un valore per Sic';

        var socAssValues = component.get("v.socAssValues");
        if(socAssValues==none) return 'Completa il campo Società assicurative';
        var socAssValue= component.get("v.socAssValue");
        var socSel = component.get("v.newSocAssValue");
        if(socAssValue && (socSel == undefined || socSel == '')) return 'Selezionare un valore per Società assicurative';

        var socRecValues = component.get("v.socRecValues");
        if(socRecValues==none) return 'Completa il campo Società di recupero';
        var socRecValue= component.get("v.socRecValue");
        var socRecSel = component.get("v.newSocRecValue");
        if(socRecValue && (socRecSel == undefined || socRecSel == '')) return 'Selezionare un valore per Società di recupero';

        var respValues = component.get("v.respValues");
        if(respValues==none) return 'Completa il campo Responsabilità';
        var respValue= component.get("v.respValue");
        var respSelected = component.get("v.respSelected");
        if(respValue && (respSelected == undefined || respSelected == '')) return 'Selezionare un valore per responsabilità';

        var idmValues = component.get("v.idmValues");
        if(idmValues==none) return 'Completa il campo Invia risposta IDM';
        var allegatiSelezionati = component.get('v.allegatiSelezionati');
        var selezionati = allegatiSelezionati.length > 0 ? true : false;
        if(idmValues && !selezionati) return 'Selezionare almeno un allegato';

        var campiCase = component.get('v.campiCase');
        var isTipoReclamo5412 = campiCase.Tipo_Reclamo__c == '5412';
        
        if(isTipoReclamo5412){
            //var riscontroValues = component.get("v.riscontroValues");
            //if(riscontroValues==none) return 'Completa il campo Attesa riscontro';
        }        
		
        var codaSelezionata = component.get("v.codaSelezionata");
        var iscodaSelezionata57 = codaSelezionata.DeveloperName == 'DN_57';
        if(iscodaSelezionata57){
            var riscontroValues = component.get("v.riscontroValues");
            if(riscontroValues==none) return 'Completa il campo Attesa riscontro';
        }
        return 'ok';
        
    },

    checkFuturo : function(component, event, helper){

        var none = 'none';
 
        var rimborsoProv = component.get("v.rimborsoProvValue");
        var rimborsoProvValues = component.get("v.rimborsoProvValues");
        if(rimborsoProvValues==none) return 'Completa il campo Rimborso provvigioni/accessorie';
        var rimborsoProvValue= component.get("v.rimborsoImportoProvValue");
        if(rimborsoProv && (rimborsoProvValue == undefined || rimborsoProvValue == '' || rimborsoProvValue <= 0)) return 'Completa il campo Importo Rimborso provvigioni/accessorie con un valore positivo';

        var rimborsoComm= component.get("v.rimborsoCommValue");
        var rimborsoCommValues = component.get("v.rimborsoCommValues");
        if(rimborsoCommValues==none) return 'Completa il campo Rimborso commissioni';
        var rimborsoCommValue= component.get("v.rimborsoImportoCommValue");
        if(rimborsoComm && (rimborsoCommValue == undefined || rimborsoCommValue == '' || rimborsoCommValue <= 0)) return 'Completa il campo Importo Rimborso commissioni con un valore positivo';

        var risarcimento= component.get("v.risarcimentoValue");
        var risarcimentoValues = component.get("v.risarcimentoValues");
        if(risarcimentoValues==none) return 'Completa il campo Risarcimento';
        var risarcimentoValue= component.get("v.risarcimentoImportoValue");
        if(risarcimento && (risarcimentoValue == undefined || risarcimentoValue == '' || risarcimentoValue <= 0)) return 'Completa il campo Importo risarcimento con un valore positivo';

        var rimborsoPrem= component.get("v.rimborsoPremValue");
        var rimborsoPremValues = component.get("v.rimborsoPremValues");
        if(rimborsoPremValues==none) return 'Completa il campo Rimborso premio assicurativo';
        var rimborsoPremValue= component.get("v.rimborsoImportoPremValue");
        if(rimborsoPrem && (rimborsoPremValue == undefined || rimborsoPremValue == '' || rimborsoPremValue <= 0)) return 'Completa il campo Importo Rimborso premio assicurativo con un valore positivo';
         
        var rimborsoVar= component.get("v.rimborsoVarValue");
        var rimborsoVarValues = component.get("v.rimborsoVarValues");
        if(rimborsoVarValues==none) return 'Completa il campo Rimborso varie';
        var rimborsoVarValue= component.get("v.rimborsoImportoVarValue");
        if(rimborsoVar && (rimborsoVarValue == undefined || rimborsoVarValue == '' || rimborsoVarValue <= 0)) return 'Completa il campo Importo Rimborso varie con un valore positivo';
         
        var rimborsoLeg= component.get("v.rimborsoLegValue");
        var rimborsoLegValues = component.get("v.rimborsoLegValues");
        if(rimborsoLegValues==none) return 'Completa il campo Rimborso spese legali';
        var rimborsoLegValue= component.get("v.rimborsoImportoLegValue");
        if(rimborsoLeg && (rimborsoLegValue == undefined || rimborsoLegValue == '' || rimborsoLegValue <= 0)) return 'Completa il campo Importo Rimborso spese legali con un valore positivo';
        
        var fondatoValues = component.get("v.fondatoValues");
        if(fondatoValues==none) return 'Completa il campo Fondato';

        var attesaValues = component.get("v.attesaValues");
        if(attesaValues==none) return 'Completa il campo Attesa assegno';

        var allegatiCompletiValues = component.get("v.allegatiCompletiValues");
        if(allegatiCompletiValues!=true) return 'Il campo Allegati completi deve essere impostato su \'Si\'';

        var sicValues = component.get("v.sicValues");
        if(sicValues==none) return 'Completa il campo Sic';
        var sicValue= component.get("v.sicValue");
        var sicSel = component.get("v.newSicValue");
        if(sicValue && (sicSel == undefined || sicSel == '')) return 'Selezionare un valore per Sic';

        var socAssValues = component.get("v.socAssValues");
        if(socAssValues==none) return 'Completa il campo Società assicurative';
        var socAssValue= component.get("v.socAssValue");
        var socSel = component.get("v.newSocAssValue");
        if(socAssValue && (socSel == undefined || socSel == '')) return 'Selezionare un valore per Società assicurative';

        var socRecValues = component.get("v.socRecValues");
        if(socRecValues==none) return 'Completa il campo Società di recupero';
        var socRecValue= component.get("v.socRecValue");
        var socRecSel = component.get("v.newSocRecValue");
        if(socRecValue && (socRecSel == undefined || socRecSel == '')) return 'Selezionare un valore per Società di recupero';

        var respValues = component.get("v.respValues");
        if(respValues==none) return 'Completa il campo Responsabilità';
        var respValue= component.get("v.respValue");
        var respSelected = component.get("v.respSelected");
        if(respValue && (respSelected == undefined || respSelected == '')) return 'Selezionare un valore per responsabilità';

        var idmValues = component.get("v.idmValues");
        if(idmValues==none) return 'Completa il campo Invia risposta IDM';
        var allegatiSelezionati = component.get('v.allegatiSelezionati');
        var selezionati = allegatiSelezionati.length > 0 ? true : false;
        if(idmValues && !selezionati) return 'Selezionare almeno un allegato';

        var campiCase = component.get('v.campiCase');
        var isTipoReclamo5412 = campiCase.Tipo_Reclamo__c == '5412';
        
        if(isTipoReclamo5412){
            //var riscontroValues = component.get("v.riscontroValues");
            //if(riscontroValues==none) return 'Completa il campo Attesa riscontro';
        }

        var codaSelezionata = component.get("v.codaSelezionata");
        var iscodaSelezionata57 = codaSelezionata!=null ? codaSelezionata.DeveloperName == 'DN_57' : false;
        if(iscodaSelezionata57){
            var riscontroValues = component.get("v.riscontroValues");
            if(riscontroValues==none) return 'Completa il campo Attesa riscontro';
        }
        
        return 'ok';
        
    },
    
    //RESPONSABILITA
    handleResp : function(component, event, helper){
        var accId = component.get('v.campiCase');
        
        if(event.getParam("value") == 'false'){
            component.set('v.respValue', false);
            component.set('v.respValues', false);  
        } 
        else if(event.getParam("value") == 'true'){
            component.set('v.respValue', true);
            component.set('v.respValues', true);
            helper.getResponsabilitaValues2(component,event,helper);

        }else{
            component.set('v.respValue', false);
            component.set('v.respValues', 'none');
        }

        var x =  component.get('v.respValue');
        var y =  component.get('v.respValues');
        
    },

    setResponsabilita : function(component, event, helper){
        var respSelectedTemp = component.get("v.respSelectedTemp");
        

        var search = component.find("searchResp").get("v.value");
        if(search==null||search==undefined||search==''||search=='undefined'){
            component.set("v.respSelectedTemp",[]);
            
            
        }else{
            /*
            var selectedOptionValue = component.get("v.respSelected");
            var respSelectedTemp = component.get("v.respSelectedTemp");
            var addArray = [];
            for(var i=0; i<selectedOptionValue.length; i++){
                addArray.push(selectedOptionValue[i]);
            }

            for(var j=0; j<respSelectedTemp.length; j++){
                if(!addArray.includes(respSelectedTemp[j])){
                    addArray.push(respSelectedTemp[i]);
                }
            }

            respSelectedTemp = addArray;
            component.set("v.respSelectedTemp",addArray);
            */
        }
        var x = component.get("v.respSelectedTemp");
        var y = component.get("v.respSelected");
        
        helper.setResponsabilita(component, event, helper);        
    },

    getResponsabilita : function(component, event, helper){
        var y = component.get("v.respSelectedTemp"); 
        var respSelectedTemp = component.get("v.respSelected");
        
        component.set("v.respSelectedTemp",respSelectedTemp);
        var x = component.get("v.respSelectedTemp");
        
        helper.getResponsabilitaValues2(component, event, helper);        
    },

    //CREATE CASE IDM   
    createCase : function(component, event, helper){
        helper.createCase(component, event, helper);
    }


})