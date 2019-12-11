({
    setFields : function(cmp){
        var cCase = cmp.get('v.campiCase');
        cmp.set('v.commissioniSelection',cCase['F_Has_Rimborso_Commissioni_In__c']?'Si':'No');
        cmp.set('v.provvAccSelection',cCase['F_Has_Rimborso_Provvigioni_In__c']?'Si':'No');
        cmp.set('v.premioAssSelection',cCase['F_Has_Rimborso_Assicurativo_In__c']?'Si':'No');
        cmp.set('v.varieSelection',cCase['F_Has_Rimborso_Varie_In__c']?'Si':'No');
        cmp.set('v.speseLegaliSelection',cCase['F_Has_Rimborso_Spese_Legali_In__c']?'Si':'No');
        cmp.set('v.commissioniValue',cCase['F_Rimborso_Commissioni_Importo_In__c']);
        cmp.set('v.provvAccValue',cCase['F_Rimborso_Provvigioni_Importo_In__c']);
        cmp.set('v.premioAssValue',cCase['F_Rimborso_Assicurativo_Importo_In__c']);
        cmp.set('v.varieValue',cCase['F_Rimborso_Varie_Importo_In__c']);
        cmp.set('v.speseLegaliValue',cCase['F_Rimborso_Spese_Legali_Importo_In__c']);
    },
    
    checkIfOkHelper:function(cmp){
        var res=true;
        var attrMap={'isRimborsoCOk':'Rimborso Commissioni',
                     'isRimborsoPOk':'Rimborso Provvigioni/Accessorie',
                     'isRimborsoPremiomOk':'Rimborso Premio Assicurativo',
                     'isRimborsoVOk':'Rimborso Varie',
                     'isRimborsoSOk':'Rimborso Spese Legali'};
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
    
    buildOutputObj:function(cmp){
        var res={};
        var attrList=['commissioniOutput','provvAccOutput','premioAssOutput',
                      'varieOutput','speseLegaliOutput'];
        attrList.forEach(function(temp){
            res[temp]=cmp.get('v.'+temp);
        });
        return res;
    }
})