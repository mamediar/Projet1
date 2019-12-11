({
    initHelper:function(cmp){
        var date=new Date();
        var d=date.getDate();
        var m=date.getMonth()+1;
        var y=date.getFullYear();
        var today=y+'-'+m+'-'+d;
        cmp.set('v.today',today);
    },
    
    buildTipoValues:function(cmp){
        var cacheList=cmp.get('v.listaValoriTipoCache');
        cmp.set('v.listaValoriTipo',[]);
        var resList=[];
        cacheList.forEach(function(temp){
            var tempList=temp['Descrizione__c'].split(' ');
            if(tempList[tempList.length-1]==cmp.get('v.areaDettagli')){
                resList.push(temp);
            }
        });
        cmp.set('v.listaValoriTipo',resList);
    },
    
    buildOutputObj:function(cmp){
        var res={};
        var attrList=['tipoDettagli','dataComunicazione','dataRicezione','dataRicezioneIDM',
                      'delegaPresente','accessoDati','categoriaDettagli','areaDettagli',
                      'dataDecisione','modalitaInvioDettagli','isGrave'];
        if(cmp.get('v.isGrave')){
            attrList.push('reclamoCompleto');
        }
        attrList.forEach(function(temp){
            if(['accessoDati','reclamoCompleto','delegaPresente','isGrave'].includes(temp)){
                res[temp]=cmp.get('v.'+temp)=='true';
            }
            res[temp]=cmp.get('v.'+temp);
        });
        return res;
    },
    
    checkValuesHelper:function(cmp,helper){
        var res=true;
        res=helper.checkIfCompiled(cmp);
        if(res){
            res=helper.checkDatesValue(cmp,helper);
        }
        return res;
    },
    
    checkIfCompiled:function(cmp){
      
        var attrMap={'tipoDettagli':'Tipo','dataComunicazione':'Data Comunicazione',
                     'dataRicezione':'Data Ricezione','dataRicezioneIDM':'Data Ricezione IDM',
                     'delegaPresente':'Delega Presente','accessoDati':'Accesso ai Dati',
                     'modalitaInvioDettagli':'Modalità Invio'};
        var msg='';
        if(cmp.get('v.aziendaSelezionata')=='MBCredit Solutions'){
            attrMap['areaDettagli']='Area';
        }
        if(cmp.get('v.isGrave')){
            attrMap['reclamoCompleto']='Reclamo Completo';
        }
        if(cmp.get('v.showDecisione')){
            attrMap['dataDecisione']='Data Decisione';
        }
        var res=true;

        Object.keys(attrMap).forEach(function(temp){
            if(!cmp.get('v.'+temp)){
                res=false;
                msg+=attrMap[temp]+', ';
            }
        });
        cmp.set('v.errorMessage',msg!=''?msg.substring(0,msg.length-2):'');
        return res;
    },
    
    checkDatesValue:function(cmp,helper){
        var res=true;
        var today=cmp.get('v.today');
        var dataComunicazione=cmp.get('v.dataComunicazione');
        var dataRicezione=cmp.get('v.dataRicezione');
        var dataRicezioneIDM=cmp.get('v.dataRicezioneIDM');
        var dataDecisione=cmp.get('v.dataDecisione');
        res=dataComunicazione<=today;
        res=dataRicezione<=today;
        res=dataRicezione>=dataComunicazione;
        if(cmp.get('v.tipoDettagli')=='Decisione' || cmp.get('v.tipoDettagli')=='Decisione CM' || cmp.get('v.tipoDettagli')=='Decisione NPL'){
            res=dataDecisione<=today;
        }
        return res;
    },
    
    getCurrentModalita : function(cmp){
        console.log('modalita init');
        var action = cmp.get('c.getModalita');
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                console.log('res = ' + resp.getReturnValue);
                cmp.set('v.modalitaInvioDettagli',resp.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    aggiornaCoda:function(cmp,event,helper){
        var cmpEvent = cmp.getEvent("aggiornaDettagli");
        if(cmpEvent!=undefined) cmpEvent.fire();
        

    }
})