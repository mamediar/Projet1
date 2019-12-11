({
    setOption : function(cmp,event) {
        cmp.set('v.radioOptions', [
            {label: '-None-', value: 'none'},
            {label: 'Si', value: true},           
            {label: 'No', value: false}
        ]);  

        cmp.set('v.columns', [
            { label: 'Selezionate', fieldName: 'label', type: 'text' }
        ]);

    },
    
    setInitValue : function(cmp,event,helper){
        console.log('init di chiusura');  
        var action=cmp.get('c.getInitValues');        
        var tipoReclamo = cmp.get('v.campiCase.Tipo_Reclamo__c');
        action.setParam('idcase',cmp.get('v.campiCase'));       
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){                
                cmp.set('v.accoltoMap',resp.getReturnValue()['accolto']);               
                cmp.set('v.accoltoList',Object.keys(cmp.get('v.accoltoMap')));
                var accolto = cmp.get('v.accoltoList');
                if(accolto.length>0){
                    var obj = [];
                    for(var i=0; i<accolto.length; i++){
                        var item={
                            "label" : accolto[i],
                            "value" : accolto[i]
                        }
                        obj.push(item);
                    }
                }
                cmp.set('v.accoltoList',obj);
                
                console.log('list accolto = ' + cmp.get('v.accoltoList'));
                console.log('accoltoMap = ' + cmp.get('v.accoltoMap'));
                
                cmp.set('v.decisioneMap',resp.getReturnValue()['decisione']);
                cmp.set('v.decisioneList',Object.keys(cmp.get('v.decisioneMap')));

                var decisione = cmp.get('v.decisioneList');
                if(decisione.length>0){
                    var obj = [];
                    for(var i=0; i<decisione.length; i++){
                        var item={
                            "label" : decisione[i],
                            "value" : decisione[i]
                        }
                        obj.push(item);
                    }
                }
                cmp.set('v.decisioneList',obj);
                
                cmp.set('v.interventoMap',resp.getReturnValue()['intervento']);
                cmp.set('v.interventoAutList',Object.keys(cmp.get('v.interventoMap')));
                
                cmp.set('v.assicurazioniMap',resp.getReturnValue()['assicurazioni']);
                cmp.set('v.socAssList',Object.keys(cmp.get('v.assicurazioniMap')));
                
                cmp.set('v.recuperoMap',resp.getReturnValue()['recupero']);
                cmp.set('v.socRecList',Object.keys(cmp.get('v.recuperoMap')));
                
                cmp.set('v.sicMap',resp.getReturnValue()['sic']);
                cmp.set('v.sicList',Object.keys(cmp.get('v.sicMap')));
                
                this.setDataTable(cmp,event,helper);         
            }
        });
        
        $A.enqueueAction(action); 
        /*
        var action2=cmp.get('c.getResponsabilita');
        action2.setParam('recordId',cmp.get('v.recordId'));
         action2.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){  
                cmp.set('v.responsabilitaList',resp.getReturnValue());
                console.log('resp = ' + resp.getReturnValue());
                
            }
        });
 
        $A.enqueueAction(action2);
        
        */        
    },
    setnewSicValueReadOnly : function(component, event, helper){

        var socRecValue = component.get('v.newSicValue');
        var map = component.get('v.sicList');
        var newSicValueReadOnly = component.get('v.newSicValueReadOnly');
        
        
        var s = '';
        if(socRecValue!=null && socRecValue!=undefined){
            socRecValue.split(';').forEach(function(item){
                var element = map[item];
                if(element!=undefined){
                    newSicValueReadOnly.push(element);
                }
            });
            var obj = [];
            for(var i = 0; i<newSicValueReadOnly.length;i++){
                var item = {
                    "label" : newSicValueReadOnly[i]
                }
                obj.push(item);
            }

            component.set('v.newSicValueReadOnly',obj);
        }

    },

    setnewSocAssValueReadOnly : function(component, event, helper){

        var socRecValue = component.get('v.newSocAssValue');
        var map = component.get('v.socAssList');
        var newSocAssValueReadOnly = component.get('v.newSocAssValueReadOnly');
        
        
        var s = '';
        if(socRecValue!=null && socRecValue!=undefined){
            socRecValue.split(';').forEach(function(item){
                var element = map[item];
                if(element!=undefined){
                    newSocAssValueReadOnly.push(element);
                }
            });
            var obj = [];
            for(var i = 0; i<newSocAssValueReadOnly.length;i++){
                var item = {
                    "label" : newSocAssValueReadOnly[i]
                }
                obj.push(item);
            }

            component.set('v.newSocAssValueReadOnly',obj);
        }

    },
    setnewSocRecValueReadOnly : function(component, event, helper){

        var socRecValue = component.get('v.newSocRecValue');
        var map = component.get('v.socRecList');
        var newSocRecValueReadOnly = component.get('v.newSocRecValueReadOnly');
        
        
        var s = '';
        if(socRecValue!=null && socRecValue!=undefined){
            socRecValue.split(';').forEach(function(item){
                var element = map[item];
                if(element!=undefined){
                    newSocRecValueReadOnly.push(element);
                }
            });
            var obj = [];
            for(var i = 0; i<newSocRecValueReadOnly.length;i++){
                var item = {
                    "label" : newSocRecValueReadOnly[i]
                }
                obj.push(item);
            }

            component.set('v.newSocRecValueReadOnly',obj);
        }

    },
    
    setDataTable : function(cmp,event,helper){
        /*
        var arrayresp = [];
        cmp.get('v.ResponsabilitaList').forEach(function(item){
            arrayresp.push({'column1':item});            
        });                
        cmp.set('v.ResponsabilitaObject',arrayresp);
        cmp.set('v.ResponsabilitaColumns',[
            {label:'Responsabilità',fieldName:'column1',type:'text'}
        ]);
        */
        
        var arraySic = [];
        cmp.get('v.sicList').forEach(function(item){
            arraySic.push({'column1':item});            
        });                
        cmp.set('v.sicData',arraySic);
        cmp.set('v.sicColumns',[
            {label:'SIC',fieldName:'column1',type:'text'}
        ]); 
        
        var arraySocAss = [];
        cmp.get('v.socAssList').forEach(function(item){
            arraySocAss.push({'column1':item});            
        });                
        cmp.set('v.socAssData',arraySocAss);
        cmp.set('v.socAssColumns',[
            {label:'Società assicurazione',fieldName:'column1',type:'text'}
        ]);
        
        var arraySocRec = [];
        cmp.get('v.socRecList').forEach(function(item){
            arraySocRec.push({'column1':item});            
        });                
        cmp.set('v.socRecData',arraySocRec);
        cmp.set('v.socRecColumns',[
            {label:'Società di recupero',fieldName:'column1',type:'text'}
        ]);        
    },

    getCaseResponsabilita : function(component, event, helper){

        var hasResp = component.get('v.respValue');
        var idCase = component.get('v.recordId');
        var action = component.get('c.getHasResponsabilita');
        var readOnly = component.get('v.readOnly');

        action.setParams({
            idCase : idCase
        });

        action.setCallback(this,function(response){

            var x = response.getState();
            
            
            if(response.getState() === 'SUCCESS'){
                var resp = response.getReturnValue();
                if(readOnly){
                    component.set("v.respValue",resp);
                    component.set("v.respValues",resp);
                    this.getResponsabilitaValues(component,event,helper);
                }

                
                if(resp){
                    this.setResponsabilitaValues(component,event,helper);
                    //this.getResponsabilitaValues2(component,event,helper);
                }else{
                    //this.getResponsabilitaValues(component,event,helper);
                }
            }else{
                //this.getResponsabilitaValues(component,event,helper);
            }
            
        });
        $A.enqueueAction(action);



    },

    setResponsabilitaValues : function(component, event, helper){

        var societa = component.get('v.campiCase.Referenced_Company__c');
        var idCase = component.get('v.recordId');
        var action = component.get('c.setValoriResponsabilita');
        
        action.setParams({
            societa : societa,
            idCase : idCase
        });

        action.setCallback(this,function(response){

            var respList = response.getReturnValue();
            
            if(response.getState() === 'SUCCESS'){
                var str=[];
                var str2=[];
                var readOnly = component.get('v.readOnly');

                if(readOnly){
                    for(var j=0; j<respList.length; j++){

                        var s = respList[j].Name__c;
                        var lngth = [];
                        lngth = s.split(' ');

                        if(lngth.length>3){

                            var finalStr = '';
                            var ptint = parseInt((lngth.length/2));
                            
                            for(var i = 0; i < lngth.length; i++){
                            
                                if(i < ptint){
                                    finalStr+= lngth[i] +' ';
                                }else if(i == ptint){
                                    finalStr+= lngth[i] +'\n';
                                }else{
                                    finalStr+= lngth[i] +' ';
                                }
                            }

                            respList[j].Name__c = finalStr;

                        }

                        var item = {
                            "label": respList[j].Name__c,
                            "value": respList[j].Id,
                        };
                        str.push(item);
                        str2.push(item.Name__c);
                    }

                }else{

                    for(var j=0; j<respList.length; j++){
                        var item = respList[j].Id;
                       
                        str.push(item);
                    }
                }
                /*
                for(var i=0; i<respList.length; i++){
                    str.push(respList[i].Id);
                }*/
                component.set('v.respSelected',str);
                component.set('v.respSelectedReadOnly',str2);
                
                

            }
            //this.getResponsabilitaValues(component, event, helper);

        });
        $A.enqueueAction(action);

    },

    getResponsabilitaValues : function(component, event, helper){

        console.log('@@@ take responsabilities');
        var respSelected = component.get('v.respSelected');
        var societa = component.get('v.campiCase.Referenced_Company__c');
        
        var hasResp = component.get('v.respValue');
        
        var action = component.get('c.getResponsabilita');
        
        action.setParams({
            societa : societa,
            respSelected : respSelected
        });

        action.setCallback(this,function(response){

            var respList = response.getReturnValue();
            
            if(response.getState() === 'SUCCESS'){
                var obj = [];
                /*for(var i=0; i<respList.length; i++){
                    var item = {
                        "label": respList[i].Name__c,
                        "value": respList[i].Id,
                    };
                    obj.push(item);
                }*/

                for(var j=0; j<respList.length; j++){

                    var s = respList[j].Name__c;
                    var lngth = [];
                    lngth = s.split(' ');
                    
                    if(lngth.length>3){

                        var finalStr = '';
                        var ptint = parseInt((lngth.length/2));
                        
                        for(var i = 0; i < lngth.length; i++){
                        
                            if(i < ptint){
                                finalStr+= lngth[i] +' ';
                            }else if(i == ptint){
                                finalStr+= lngth[i] +'\n';
                            }else{
                                finalStr+= lngth[i] +' ';
                            }
                        }

                        respList[j].Name__c = finalStr;

                    }

                    var item = {
                        "label": respList[i].Name__c,
                        "value": respList[i].Id,
                    };
                    obj.push(item);

                }


                component.set('v.responsabilitaList',obj);
                
                component.set('v.respSelected',null);
                component.set('v.respSelected',respSelected);
                var g = component.get('v.respSelected');
                
                
                var str = [];
                var readOnly = component.get('v.readOnly');

                if(readOnly){
                    /*for(var i=0; i<respSelected.length; i++){
                        var item = {
                            "label": respSelected[i].Name__c,
                            "value": respSelected[i].Id,
                        };
                        str.push(item);
                    }*/

                    for(var j=0; j<respSelected.length; j++){

                        var s = respSelected[j].Name__c;
                        var lngth = [];
                        lngth = s.split(' ');

                        if(lngth.length>3){
                            var finalStr = '';
                            var ptint = parseInt((lngth.length/2));
                            
                            for(var i = 0; i < lngth.length; i++){
                            
                                if(i < ptint){
                                    finalStr+= lngth[i] +' ';
                                }else if(i == ptint){
                                    finalStr+= lngth[i] +'\n';
                                }else{
                                    finalStr+= lngth[i] +' ';
                                }
                            }

                            respSelected[j].Name__c = finalStr;

                        }

                        var item = {
                            "label": respSelected[j].Name__c,
                            "value": respSelected[j].Id,
                        };
                        str.push(item);
                    }

                }else{

                    for(var j=0; j<respSelected.length; j++){
                        var item = respSelected[j].Id;
                       
                        str.push(item);
                    }
                }
                
                component.set('v.respSelected',str);
                var h = component.get('v.respSelected');
                
            }


        });
        $A.enqueueAction(action);


    },
    
    setResponsabilita : function(component, event, helper){
        var selectedOptionValue = event.getParam("value");
        var respSelectedTemp = component.get("v.respSelectedTemp");
        

        var isSearch = false;
        var search = component.find("searchResp").get("v.value");
        var addArray = [];
        if(search!=null && search!=undefined && search!='' && search!='undefined' && search!=""){
            isSearch=true;
            var respSelected = component.get("v.respSelected");
            
            
            for(var i=0; i<selectedOptionValue.length; i++){
                addArray.push(selectedOptionValue[i]);
            }

            for(var j=0; j<respSelectedTemp.length; j++){
                if(!addArray.includes(respSelectedTemp[j])){
                    addArray.push(respSelectedTemp[j]);
                }
            }

            selectedOptionValue = addArray;

        }else{

            for(var i=0; i<selectedOptionValue.length; i++){
                for(var j=0; j<respSelectedTemp.length; j++){
                    if(selectedOptionValue[i]==respSelectedTemp[j]){
                        selectedOptionValue.splice(i, 1);
                        respSelectedTemp.splice(j, 1);
                    }
                }
            }
            selectedOptionValue = selectedOptionValue.concat(respSelectedTemp);
             
        }
        /*
        for(var i=0; i<selectedOptionValue.length; i++){
            for(var j=0; j<respSelectedTemp.length; j++){
                if(selectedOptionValue[i]==respSelectedTemp[j]){
                    selectedOptionValue.splice(i, 1);
                    respSelectedTemp.splice(j, 1);
                }
            }
        }
        selectedOptionValue = selectedOptionValue.concat(respSelectedTemp);
         */

        component.set('v.respSelectedTemp',selectedOptionValue);
        //component.set("v.respSelected",selectedOptionValue);


        var idCase = component.get('v.recordId');
        var accId = component.get('v.campiCase').AccountId;
        var r = component.get("v.respSelected");
        
        /*
        var array = selectedOptionValue;
        var str = "";
        if(array.length>0){
            for(var i in array){
                console.log(array[i]);
                str=str+array[i]+";";
            }
        }
        
        component.set("v.respSelected",str);*/
        //component.set('v.values', str);

        var action = component.get('c.createRecordResponsabilita');

        action.setParams({
            idCase : idCase,
            accId : accId,
            respSelected : selectedOptionValue
        });

        action.setCallback(this,function(response){

            var respList = response.getReturnValue();
            //component.set("v.respSelected",respList);
            this.setResponsabilitaValues(component, event, helper);


        });
        $A.enqueueAction(action);
    },

    getResponsabilitaValues2 : function(component, event, helper){

        console.log('@@@ take responsabilities');
        var respValueToFound = component.get('v.respValueToFound');
        var respValueToFound = component.find("searchResp").get("v.value");
        

        //if(respValueToFound==null||respValueToFound==undefined||respValueToFound==''||respValueToFound=='undefined'||respValueToFound==' '){
            //this.setResponsabilitaValues(component, event, helper);
            //return;
        //}else{

            var societa = component.get('v.campiCase.Referenced_Company__c');
                    
            var action = component.get('c.getResponsabilitaSearched');

            action.setParams({
                societa : societa,
                respValueToFound : respValueToFound
            });

            action.setCallback(this,function(response){

                var respList = response.getReturnValue();
                
                if(response.getState() === 'SUCCESS'){
                    var obj = [];
                    /*for(var i=0; i<respList.length; i++){
                        var item = {
                            "label": respList[i].Name__c,
                            "value": respList[i].Id,
                        };
                        obj.push(item);
                    }*/

                    for(var j=0; j<respList.length; j++){

                        var s = respList[j].Name__c;
                        var lngth = [];
                        lngth = s.split(' ');

                        if(lngth.length>3){
                            var finalStr = '';
                            var ptint = parseInt((lngth.length/2));
                            
                            for(var i = 0; i < lngth.length; i++){
                            
                                if(i < ptint){
                                    finalStr+= lngth[i] +' ';
                                }else if(i == ptint){
                                    finalStr+= lngth[i] +'\n';
                                }else{
                                    finalStr+= lngth[i] +' ';
                                }
                            }

                            respList[j].Name__c =  finalStr; 
                        }
                        var item = {
                            "label": respList[j].Name__c,
                            "value": respList[j].Id,
                        };
                        obj.push(item);
                        
                    }

                    component.set('v.responsabilitaList',obj);

                    this.setResponsabilitaValues(component, event, helper);
                    /*
                    component.set('v.respSelected',null);
                    component.set('v.respSelected',respSelected);
                    var g = component.get('v.respSelected');
                    
                    
                    var str = []
                    for(var j=0; j<respSelected.length; j++){
                        var item = respSelected[j].Id;
                    
                        str.push(item);
                    }
                    
                    component.set('v.respSelected',str);
                    var h = component.get('v.respSelected');
                    */
                }


            });
            $A.enqueueAction(action);
        //}

    },

    //CREATE CASE IDM 
    createCase : function(component, event, helper){

        var idCase = component.get('v.recordId');
        var selectedFile = component.get('v.allegatiSelezionati');
        var action = component.get('c.createRecordCaseIDM');
        
        action.setParams({
            idCase : idCase,
            selectedFile : selectedFile
        });

        action.setCallback(this,function(response){
            var resp = response.getState();
            if(resp === 'SUCCESS'){
                var status = response.getReturnValue();
                if(status!=null){
                    component.set('v.status',status);
                }
                console.log('case copied successfully');
            }else{
                console.log('error on copy case');
            }

        });
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
    }

    
})