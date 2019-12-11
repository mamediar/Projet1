({
    setFields : function(cmp){
        var cCase = cmp.get('v.campiCase');
        cmp.set('v.rimborsoSelection',cCase['Has_Rimborso__c']?'Si':'No');
        cmp.set('v.standAloneSelection',cCase['Stand_Alone__c']?'Si':'No');
        cmp.set('v.rimborsoValue',cCase['Importo_Rimborso__c']);
    },
    
    checkIfOkHelper:function(cmp){
        var res=true;
        var attrMap={'isRadioButtonsComuniOk':cmp.get('v.comuniErrorMsg')};
        var msg='';
        if(cmp.get('v.aziendaSelezionata')!='Futuro'){
            attrMap['isRimborsoOk']='Rimborso';
        }
        if(cmp.get('v.aziendaSelezionata')=='Futuro'){
            attrMap['isRadioButtonsFuturoOk']=cmp.get('v.futuroErrorMsg');
        }
        if(cmp.get('v.aziendaSelezionata')=='Compass'){
            attrMap['isStandaloneOk']='Stand Alone';
        }
        Object.keys(attrMap).forEach(function(temp){
            console.log('checking '+temp);
            if(!cmp.get('v.'+temp)){
                res=false;
                msg+=attrMap[temp]+', ';
            }
        });
        cmp.set('v.errorMessage',msg!=''?msg.substring(0,msg.length-2):'');
        return res;
    },
    
    buildOutputObj:function(cmp){
        var res={};
        var attrList=['rimborsoOutput','standaloneOutput','futuroOutput','comuniOutput'];
        attrList.forEach(function(temp){
            res[temp]=cmp.get('v.'+temp);
        });
        return res;
    }
})