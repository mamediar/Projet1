({
	init : function(cmp, event, helper) 
    {
		cmp.set('v.columns',[
            {label:'Barcode',fieldName:'Barcode__c',type:'text',initialWidth:200},
            {label:'Flag Accollo',fieldName:'FlagAccollo__c',type:'number',initialWidth:200},
            {label:'Stato',fieldName:'',type:'text',cellAttributes:{iconName:{fieldName:'IconFormula__c'},iconPosition:'left'}}
        ]);
        var action=cmp.get("c.returnContracts");
        action.setParams({'lottoId':cmp.get('v.lotto.Id')});
        action.setCallback
        (
            this,
            function(response){
                if (response.getState() == 'SUCCESS'){                    
                	var result = response.getReturnValue();
                    if(result!=null && result!=undefined){
                        var lotto = cmp.get('v.lotto.BranchId__c');
                        var contratti = result;
                        var contrattidaprocessare = [];
                        var contrattiprocessati = [];
                        var contrattievidenziati = [];
                        var contrattinonprocessati = [];
                        console.log("-----------" + lotto);
                        console.log("HEREEEEEEEE + " + lotto);
                        for(var i=0;i<contratti.length;i++)
                        {
                          //  console.log("son qui" + i);
                            if(contratti[i]['WorkStatus__c'] == '1'  || contratti[i]['WorkStatus__c'] =='401' || contratti[i]['WorkStatus__c'] =='404')
                            {
                                if(parseInt(lotto) >= 700 &&  parseInt(lotto) <= 799)
                                {
                                    console.log('sono qua dentro if');
                                    if(contratti[i]['q_allyes__c'])
                                    {
                                        contrattiprocessati.push(contratti[i]);      
                                    }
                                    else
                                    {
                                        contrattievidenziati.push(contratti[i]);
                                        contrattinonprocessati.push(contratti[i]);
                                    }
                                }
                                else if(contratti[i]['WorkStatus__c'] =='401' || contratti[i]['WorkStatus__c'] =='404' )
                                {
                                    contrattievidenziati.push(contratti[i]);
                                    contrattinonprocessati.push(contratti[i]);
                                }
                                else
                                {
                                    contrattiprocessati.push(contratti[i]);
                                }
                            }
                            else
                            {
                                contrattidaprocessare.push(contratti[i]);
                                contrattinonprocessati.push(contratti[i]);
                            }
                        cmp.set('v.contractList',contratti);
                    	cmp.set('v.countContract',contratti.length);
                        cmp.set('v.contractfromprocessed',contrattidaprocessare);    
                        cmp.set('v.contractfromevident',contrattievidenziati);  
                        cmp.set('v.countContractProcessed',contrattiprocessati.length + contrattievidenziati.length);
                        cmp.set('v.countMissingContract',contrattidaprocessare.length);
                        cmp.set('v.contractfordatatable',contrattinonprocessati);
                        console.log(contrattievidenziati);    
                    }
                }
            }
           }
        );
        $A.enqueueAction(action);
       
    	},
        
        checkBarcode:function(cmp,event,helper){
        var navigate = cmp.get('v.navigateFlow');
        cmp.set('v.checkEndActivity',false);    
       	var Controllo = /^[a-z,A-Z]{2}\d{12}$/;
        var tempInput=event.getParam('barCode');
        cmp.set('v.checkError',false);
        cmp.set('v.checkTrovato',false);
        cmp.set('v.checkMessage',false);
        var list = (cmp.get("v.contractList") != null) ? cmp.get("v.contractList") : [];
       	console.log(list);
        var isIn=false;
        if(Controllo.test(tempInput))
        {
            for(var i=0;i<list.length && !isIn;i++)
            {
                //console.log(list[i]);
                if(list[i]['Barcode__c']==tempInput)
                {
                    cmp.set('v.contratto',list[i]);
                    isIn=true;
                }
            }
            
            cmp.set('v.barcodeCartella',tempInput);
            cmp.set('v.isIn',isIn);
            navigate("NEXT");
            
        }
        else
        {
            cmp.set('v.checkError',true);
    	}
    },
    
    endActivity:function(cmp,event,helper)
    {
        var navigate = cmp.get('v.navigateFlow'); 
        cmp.set('v.checkEndActivity',true);
        navigate("NEXT");       
    }       
    
    
    
})