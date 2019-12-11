({
    setFields : function(cmp){
        var cCase = cmp.get('v.campiCase');
        cmp.set('v.abbuonoSelection',cCase['Abbuono_Richiesta__c']?'Si':'No');
        cmp.set('v.risarcimentoSelection',cCase['']?'Si':'No');
        cmp.set('v.abbuonoValue',cCase['Importo_Abbuono_Richiesta__c']);
        cmp.set('v.risarcimentoValue',cCase['']);
    },
    
	checkIfOkHelper:function(cmp){
        var res=true;
        var attrMap={'isAbbuonoOk':'Abbuono','isRisarcimentoOk':'Risarcimento'};
        var msg='';
        Object.keys(attrMap).forEach(function(temp){
            if(!cmp.get('v.'+temp)){
                res=false;
                msg+=attrMap[temp]+', ';
            }
        });
        console.log('AbbuonoTest: '+msg+' - '+ attrMap);
        cmp.set('v.errorMessage',msg!=''?msg.substring(0,msg.length-2):'');
        return res;
    },
    
    buildOutputObj:function(cmp){
        var res={};
        var attrList=['abbuonoOutput','risarcimentoOutput'];
        attrList.forEach(function(temp){
            res[temp]=cmp.get('v.'+temp);
        });
       console.log('AbbuonoTest2: '+res);  
        return res;
    }
})