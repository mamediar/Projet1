({    
    setFields : function(cmp){
        
        var initMap = this.getInitMap();
        console.log('setto i campi di chiusura initMap = ' + JSON.stringify(initMap));
        var campiCase = cmp.get('v.campiCase');
        console.log(cmp.get('v.campiCase').Abbuono_Chiusura__c +  ' dddddddd');
        console.log('campi case = ' + JSON.stringify(campiCase));
        Object.keys(initMap).forEach(function(temp){
            console.log('campo = ' + cmp.get('v.campiCase').temp + '\n');
            if(cmp.get('v.' + temp)){
                if(!campiCase[initMap[temp]].toUpperCase().includes('HAS')){
                    cmp.set( 'v.' + temp , campiCase[initMap[temp]]);
                }
                else{
                    cmp.set( 'v.' + temp , !campiCase[initMap[temp]] ? 'No' : 'Si');
                }
            }
        });
        
    
        
    },
    
    checkIfOkHelper:function(cmp){
        var res=true;
        var attrMap={'isChiusuraOk' : 'Chiusura',
                     'isAbbuonoOk'  : 'Abbuono',
                     'isRimborsoOk' : 'Rimborso',
                     'isRimborsoCommOk' : 'Rimborso Commissioni',
                     'isRimborsoProAccOk' : 'Rimborso Provvigioni/Accessorie' ,
                     'isRimborsoPreAssOk' : 'Rimborso Premio Asscurativo ' ,
                     'isRimborsoVarOk' : 'Rimborso Varie',
                     'isRimborsoSpeLegOk' : 'Rimborso Spese Legali',
                     'isRisarcimentoOk' : 'Risarcimento ',
                     'isResponsabilitaOk' :'Responsabilita',
                     'isSicOk':'SIC',
                     'isSocietaAssOk' : 'Societa Assicurative',
                     'isSocietaRecOk' : 'Societa Di Recupero',
                     'isInvioRisIDMOk' :'Invio Risposta Da IDM',
                     'attesaOutputOk' : 'In attesa di riscontro del cliente'};
        var msg='';
        Object.keys(attrMap).forEach(function(temp){
            if(!cmp.get('v.'+temp)){
                res=false;
                msg+=attrMap[temp]+', ';
            }
        });
        cmp.set('v.errorMessage',msg!=''?msg.substring(0,msg.length-2):'');
        return res;
    },
    
    setColumns : function(cmp){
        var arraySic = [];
        cmp.get('v.SicList').forEach(function(item){
            arraySic.push({'column1':item});            
        });                
        cmp.set('v.sicObject',arraySic);
        cmp.set('v.Siccolumns',[
            {label:'SIC',fieldName:'column1',type:'text'}
        ]);        
        var arrayAss = [];
        cmp.get('v.SocietaAssList').forEach(function(item){
            arrayAss.push({'column1':item});            
        });                
        cmp.set('v.assObject',arrayAss);
        cmp.set('v.assColumns',[
            {label:'Assicurazione',fieldName:'column1',type:'text'}
        ]);        
        var arraySoc = [];
        cmp.get('v.SocietaRecList').forEach(function(item){
            arraySoc.push({'column1':item});            
        });                
        cmp.set('v.socObject',arraySoc);
        cmp.set('v.socColumns',[
            {label:'Società',fieldName:'column1',type:'text'}
        ]);
        var arrayresp = [];
        cmp.get('v.ResponsabilitaList').forEach(function(item){
            arrayresp.push({'column1':item});            
        });                
        cmp.set('v.ResponsabilitaObject',arrayresp);
        cmp.set('v.ResponsabilitaColumns',[
            {label:'Responsabilità',fieldName:'column1',type:'text'}
        ]);
    },
    
    buildOutputObj:function(cmp){
        var res={};
        var attrList=['abbuonoOutput','RimborsoOutput','RimborsoCommOutput',
                      'RimborsoProAccOutput','RimborsoPreAssOutput','RimborsoVarOutput',
                      'RimborsoSpeLegOutput','RisarcimentoOutput','FondatoOutput','ResponsabilitaOutput',
                      'AllegatiCompletiOutput','SocietaAssOutput','SocietaRecOutput','InvioRisIDMOutput','attesaOutput','AssegnoOutput'];
        attrList.forEach(function(temp){
            res[temp]=cmp.get('v.'+temp);
        });
        console.log('***************************************************');
        console.log('buildOutputOj = '+ res);
        console.log('buildOutputOj = '+ JSON.stringify(res));
        console.log('***************************************************');
        return res;
    },
    
    getInitMap: function () {
        return  { 'abbuonoSelection' : 'Abbuono_Chiusura__c', 
                 'RimborsoSelection' :'Has_Rimborso__c',
                 'RimborsoCommSelection': 'F_Has_Rimborso_Commissioni_Out__c',
                 'RimborsoProAccSelection':'F_Has_Rimborso_Provvigioni_Out__c',
                 'RimborsoPreAssSelection':'F_Has_Rimborso_Assicurativo_Out__c',
                 'RimborsoVarSelection':'F_Has_Rimborso_Varie_Out__c',
                 'RimborsoSpeLegSelection':'F_Has_Rimborso_Spese_Legali_Out__c',
                 'RisarcimentoSelection':'Has_Risarcimento_accordato__c',
                 'FondatoSelection':'Has_Fondato__c',
                 'ResponsabilitaSelection':'Has_Responsabilita__c',
                 'AllegatiCompletiSelection':'Has_Allegati_Completi__c',
                 'SocietaAssSelection':'Has_Assicurative__c',
                 'SocietaRecSelection':'Has_Recupero__c',
                 'InvioRisIDMSelection':'Has_Invio_Risposta_IDM__c',
                 'SicSelection':'Has_SIC__c',
                 'attesaSelection':'Attesa_Riscontro_Cliente__c',
                 'AssegnoSelection':'Attesa_Assegno__c',
                 'abbuonoValue':'Importo_Abbuono_Richiesta__c',
                 'RimborsoValue':'Rimporto_Rimborso__c',
                 'RimborsoCommValue':'F_Rimborso_Commissioni_Importo_Out__c',
                 'RimborsoProAccValue':'F_Rimborso_Provvigioni_Importo_Out__c',
                 'RimborsoPreAssValue':'F_Rimborso_Assicurativo_Importo_Out__c',
                 'RimborsoVarValue':'F_Rimborso_Varie_Importo_Out__c',
                 'RimborsoSpeLegValue':'F_Rimborso_Spese_Legali_Importo_Out__c',
                 'RisarcimentoValue':'Risarcimento_Accordato_Importo__c'};
    }
    
})