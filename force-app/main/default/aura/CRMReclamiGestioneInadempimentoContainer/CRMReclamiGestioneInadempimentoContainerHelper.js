({
    initHelper : function(cmp) {
        cmp.set('v.isLoading',true);
        var action=cmp.get('c.getInitValues');
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                //cmp.set('v.stageInadempimentoList',resp.getReturnValue()['stageInadempimentoList']);
                //cmp.set('v.stageInadempimento',resp.getReturnValue()['stageInadempimentoList'][0]);

                var respMap = resp.getReturnValue();
                var stageInademOptions = cmp.get('v.stageInademOptions');
                for (var key in respMap) {
                    var obj = {};
                    obj.label = key;
                    obj.value = respMap[key];
                    stageInademOptions.push(obj);
                }
                cmp.set('v.stageInademOptions', stageInademOptions);
                
               // cmp.set('v.stageInadempimento',cmp.get('v.campiCase')['Stage_Inadempimento__c']);
                cmp.set('v.isOk',this.checkIfOk(cmp));
                cmp.set('v.output',this.buildOutputObject(cmp));
                cmp.set('v.isLoading',false);
            }
        });
        $A.enqueueAction(action);
    },
    
    checkIfOk:function(cmp){
        var attrMap={'gravitaDettagli':'Gravità Reclamo', 'isReclamoCompletoOk':'Reclamo Completo',
                     'stageInadempimento':'Stage Inadempimento'};
        console.log();
        var res=true;
        /*
        var msg='';
        Object.keys(attrMap).forEach(function(temp){
            if(!cmp.get('v.'+temp)){
                res=false;
                msg+=attrMap[temp]+', ';
            }
        });
        cmp.set('v.errorMessage',msg=='' ? msg : msg.substring(0,msg.length-2));
        */
        return res;
    },
    
    buildOutputObject:function(cmp){
        var attrList=['gravitaDettagli','stageInadempimento','reclamoCompletoOutput','FTSent','FTReceived','filiale'];
        var res={};
        attrList.forEach(function(temp){
            res[temp]=cmp.get('v.'+temp);
        });
        return res;
    },
    
    buildInputCompleto : function (cmp) {
        var res = {};
        res['selection']=cmp.get('v.reclamoCompletoSelection');
        //res['value']=null;
        res['value']=cmp.get('v.reclamoCompletoSelection') == 'Si' ? true : false;
        return res;
    },

    getCurrentValues : function(cmp){
        
        var action=cmp.get('c.getCurrentValue');
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setCallback(this,function(resp){
            var state = resp.getState();
            if(state=='SUCCESS'){               
                console.log('originale = '+cmp.get('v.campiCase')['Stage_Inadempimento__c']);
                if (cmp.get('v.campiCase')['Stage_Inadempimento__c']) {
                    cmp.set('v.stageInadempimento',resp.getReturnValue()['stage']);
                    //cmp.set('v.stageInadempimentoOld',resp.getReturnValue()['stage']);
                }
                
                cmp.set('v.FTSent',resp.getReturnValue()['FAndTSent']);
                cmp.set('v.FTReceived',resp.getReturnValue()['FAndTReceived']);
                cmp.set('v.gravitaDettagliOld',resp.getReturnValue()['disposition']);
                cmp.set('v.ReclamoCompletoValue',resp.getReturnValue()['completo']);
                cmp.set('v.filiale',resp.getReturnValue()['filiale']);
                console.log(resp.getReturnValue());
                console.log('gr = ' + cmp.get('v.gravitaDettagli'));
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    setOption : function(cmp,event) {
        cmp.set('v.radioOptions', [
            {label: 'Si', value: true},           
            {label: 'No', value: false}
        ]);       
    },
})