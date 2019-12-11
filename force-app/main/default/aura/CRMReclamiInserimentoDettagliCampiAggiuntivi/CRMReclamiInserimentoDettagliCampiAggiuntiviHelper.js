({
    buildInitValues:function(cmp,cCase){
        cmp.set('v.tipoProdottoVita',cCase['Tipo_Prodotto_Vita__c']);
        cmp.set('v.tipoProdottoDanni',cCase['Tipo_Prodotto_Danni__c']);
        cmp.set('v.areaAziendale',cCase['Area_Aziendale__c']);
        cmp.set('v.tipoProponente',cCase['Tipo_Proponente__c']);
        cmp.set('v.areaGeograficaProponente',cCase['Area_Geo_Proponente__c']);
        cmp.set('v.tipoReclamante',cCase['Tipo_Reclamante__c']);
    },
    
    getAttrMap:function(){
        return {'trattabile':'Trattabile',
                'tipoProdottoVita':'Tipo Prodotto Vita',
                'tipoProdottoDanni':'Tipo Prodotto Danni',
                'areaAziendale':'Area Aziendale',
                'tipoProponente':'Tipo Proponente',
                'areaGeograficaProponente':'Area Geografica Proponente',
                'tipoReclamante':'Tipo Reclamante'};
    },
    
    handleChangeHelper:function(cmp,helper){
        var attrMap=this.getAttrMap();
        cmp.set('v.isOk',helper.checkIfOk(cmp,attrMap));
        cmp.set('v.output',helper.buildOutputObj(cmp,Object.keys(attrMap)));
    },
    
    checkIfOk:function(cmp,attrMap){
        var res=true;
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
    
    buildOutputObj:function(cmp,attrList){
        var res={};
        attrList.forEach(function(temp){
            res[temp]=cmp.get('v.'+temp);
        });
        return res;
    },
    
    initIfGestione : function(cmp){
        console.log('sono nel helper di aggiuntivi');
        var action=cmp.get('c.initGestione')
        action.setParam('recordId',cmp.get('v.campiCase')['Id']);
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
               
                cmp.set('v.tipoProdottoVita',resp.getReturnValue()['prodVita']);
                //cmp.set('v.tipoProdottoVitaInit',resp.getReturnValue()['prodVita']);
                
                console.log('prod vita = ' + resp.getReturnValue()['prodVita']);
				cmp.set('v.tipoProdottoDanni',resp.getReturnValue()['prodDanni']);
                cmp.set('v.areaAziendale',resp.getReturnValue()['areaAz']);
                cmp.set('v.tipoProponente',resp.getReturnValue()['prop']);
                cmp.set('v.areaGeograficaProponente',resp.getReturnValue()['areaProp']);
                cmp.set('v.tipoReclamante',resp.getReturnValue()['recl']);
                
                console.log('response = ' + JSON.stringify(resp.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    }
})