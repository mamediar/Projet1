({
    getQueus: function (component, event, helper) {
        var pageSize = component.get("v.pageSize");
        var end=component.get("v.end");
        var action = component.get('c.getQueus'); 
        var resultat;
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### resultat ', JSON.stringify(resultat));
                if (resultat.erreur===false) {
                    //var inputs = component.find('inputSelectQueue');
                    var inputs =resultat.resultat;
                    console.log('inputs', JSON.stringify(inputs));
                    console.log('listQueus', JSON.stringify(resultat.resultat));
                    inputs[0].checked = true;
                    component.set('v.listQueus',inputs);
                    console.log('inputs[0]', JSON.stringify(inputs[0]));
                    this.handleManageContact(component, resultat.resultat[0],pageSize,end);
                }else {
                    this.showToast("","error");
                }
            }else{alert('error'+response.getError());
            console.log(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action); 
    },

    queuSelected : function (component, event, helper) {
        var pageSize = component.get("v.pageSize");
        var end=component.get("v.end");
        var qSelected = event.getSource().get('v.value');
        this.handleManageContact(component, qSelected,pageSize,end);
        //console.log('qSelected '+JSON.stringify(qSelected));
        /*var cmpContact = $A.get("e.c:GUA_QueueToContactEvt"); 
        cmpContact.setParams({
            "queueContact": qSelected
        });
        cmpContact.fire();*/
    },

    handleManageContact  : function(component, queueContact,pageSize,end) {
        //var queueContact = event.getParam("queueContact");
        component.set('v.queueContact',queueContact);
        console.log('queueContact '+JSON.stringify(queueContact));
        var action = component.get('c.getContactCaseByQueue');
        var resultat;
        var contactsCaseList;
        action.setParams({"grp":queueContact,
                          "pageSize":pageSize,
                          "pageNumber":end}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    contactsCaseList= resultat.resultat;
                    var paginationList = [];
                    component.set("v.contactsCaseList", contactsCaseList);
                    component.set("v.initialListContactsCase", contactsCaseList);                   
                    component.set("v.totalSize", contactsCaseList.length);
                    component.set("v.start",0);
                    component.set("v.end",pageSize-1);
                    if(pageSize>contactsCaseList.length){
                        pageSize=contactsCaseList.length;
                    }
                    for(var i=0; i< pageSize; i++) {
                        paginationList.push(contactsCaseList[i]); 
                    }
                    component.set('v.paginationList', paginationList);
                    console.log('paginationList : '+JSON.stringify(paginationList));
                    this.getElementToFilter(component); 
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    },
    first : function(component, event, helper){
        var pageSize = component.get("v.pageSize");   
        var queueContact = component.get('v.queueContact');
        this.handleManageContact(component,queueContact,pageSize,'1');     
        /*var paginationList = [];
        for(var i=0; i< pageSize; i++){
            paginationList.push(contactsCaseList[i]);
        }
        component.set('v.paginationList', paginationList);
        */
    },
    next : function(component, event, helper)   {
        var queueContact  =component.get('v.queueContact');
        var end = component.get("v.end"); 
        var start = component.get("v.start");        
        var pageSize = component.get("v.pageSize");        
        var action = component.get('c.getContactCaseByQueue');
        var resultat;
        var counter = 0;   
        var contactsCaseList;
        action.setParams({"grp":queueContact,
                          "pageSize":pageSize,
                          "pageNumber":end}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    contactsCaseList= resultat.resultat;
                    var paginationList = [];
                    component.set("v.contactsCaseList", contactsCaseList);
                    component.set("v.initialListContactsCase", contactsCaseList);                   
                    component.set("v.totalSize", contactsCaseList.length);
                    if(pageSize>contactsCaseList.length){
                        pageSize=contactsCaseList.length;
                    }
                    for(var i=0; i< pageSize; i++) {
                        paginationList.push(contactsCaseList[i]); 
                        counter ++ ; 
                    }
                    start = start + counter;        
                    end = end + counter;        
                    component.set("v.start",start);        
                    component.set("v.end",end);        
                    component.set('v.paginationList', paginationList);   
                    this.getElementToFilter(component); 
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 

        /*
        var contactsCaseList = component.get("v.contactsCaseList");        
        var end = component.get("v.end");        
        var start = component.get("v.start");        
        var pageSize = component.get("v.pageSize");        
        var paginationList = [];        
        var counter = 0;        
        for(var i=end+1; i<end+pageSize+1; i++) {            
            if(contactsCaseList.length > end)                
            {                
                paginationList.push(contactsCaseList[i]);                
                counter ++ ;                
            }            
        }        
        start = start + counter;        
        end = end + counter;        
        component.set("v.start",start);        
        component.set("v.end",end);        
        component.set('v.paginationList', paginationList);     
          */
    }, 
    previous : function(component, event, helper) {    
        var queueContact  =component.get('v.queueContact');
        var end = component.get("v.end"); 
        var start = component.get("v.start");        
        var pageSize = component.get("v.pageSize");        
        var action = component.get('c.getContactCaseByQueue');
        var resultat;
        var counter = 0;   
        var contactsCaseList;
        console.log(pageSize+' '+start+' '+end);
        action.setParams({"grp":queueContact,
                          "pageSize":pageSize,
                          "pageNumber":start}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    contactsCaseList= resultat.resultat;
                    var paginationList = [];
                    component.set("v.contactsCaseList", contactsCaseList);
                    component.set("v.initialListContactsCase", contactsCaseList);                   
                    component.set("v.totalSize", contactsCaseList.length);
                    if(pageSize>contactsCaseList.length){
                        pageSize=contactsCaseList.length;
                    }
                    for(var i=0; i< pageSize; i++) {
                        if(i > -1)                
                        {                
                            paginationList.push(contactsCaseList[i]);                
                            counter ++;                
                        }           
                        else {                
                            start++;                
                        }  
                    }
                    start = start - counter;        
                    end = end - counter;        
                    component.set("v.start",start);        
                    component.set("v.end",end);        
                    component.set('v.paginationList', paginationList);   
                    this.getElementToFilter(component); 
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
        
    },
    last : function(component, event, helper) {
        var queueContact  =component.get('v.queueContact');
        var end = component.get("v.end"); 
        var start = component.get("v.start");        
        var pageSize = component.get("v.pageSize");        
        var totalSize = component.get("v.totalSize");
        var action = component.get('c.getLastContactCaseByQueue');
        var resultat;
        var counter = 0;   
        var contactsCaseList;
        action.setParams({"grp":queueContact,"pageSize":pageSize}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    contactsCaseList= resultat.resultat;
                    var paginationList = [];
                    component.set("v.contactsCaseList", contactsCaseList);
                    component.set("v.initialListContactsCase", contactsCaseList);                   
                    component.set("v.totalSize", contactsCaseList.length);
                    if(pageSize>contactsCaseList.length){
                        pageSize=contactsCaseList.length;
                    }
                    for(var i=0; i< pageSize; i++) {
                            paginationList.push(contactsCaseList[i]);                
                            counter ++;                
                    }
                    start = start + counter;        
                    end = end +counter;        
                    component.set("v.start",start);        
                    component.set("v.end",end);        
                    component.set('v.paginationList', paginationList);   
                    this.getElementToFilter(component); 
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    
    },
    filterContactCase : function(component, event, helper) {
        component.set("v.isOpenModel", true); 
    },
    closeModel: function(component, event, helper) {
       component.set("v.isOpenModel", false);
       component.set('v.criterion',"");
       component.set('v.campagna',"");
    },
    showFilter: function(component, event, helper) {
        var initialListContactsCase=[];
        initialListContactsCase = component.get("v.initialListContactsCase");
        var pageSize = component.get("v.pageSize");
        var campagna = component.get('v.campagna');
        var criter = component.get('v.criterion');
        var listfilter =[];
        for(var i=0;i<campagna.length;i++){
            var elem= initialListContactsCase.filter(object => object.CampaignId__r.Name.toLowerCase().includes(campagna[i].toLowerCase()));
        	listfilter=listfilter.concat(elem);
        }
        listfilter.sort(this.sortBy(criter, false));
        var paginationList = [];
        var contactsCaseList = component.get('v.contactsCaseList');
        component.set('v.contactsCaseList',listfilter);
        component.set("v.totalSize", contactsCaseList.length);
        component.set("v.start",0);
        component.set("v.end",pageSize-1);
        for(var j=0; j< pageSize; j++) {
            paginationList.push(contactsCaseList[j]); 
        }
        component.set('v.paginationList', paginationList);
        this.closeModel(component,event,helper);
        this.first(component, event, helper);
     },
    getCampagna : function(component, event, helper){
         var listCampagn=[];
        var cmpagn = document.getElementById("campagnaSelected");
        if(cmpagn.selectedIndex){
    		for(var i=0; i<cmpagn.options.length; i++)
    			{
                    if(cmpagn.options[i].selected){
                        listCampagn.push(cmpagn.options[i].value);
                    }
    			}
            component.set('v.campagna',listCampagn);
            console.log('campagna '+component.get('v.campagna'));
        }
     },
   	getCriterion : function(component, event, helper){
        var criter = document.getElementById("criterionSelected");
        if(criter.selectedIndex){
            component.set('v.criterion',criter.options[criter.selectedIndex].value);
            console.log('criterion '+component.get('v.criterion'));
        }
    },
    getElementToFilter : function(component){
        component.set('v.campagnList',[]);
        component.set('v.criterionList',[]); 
        var listeContCase = component.get('v.contactsCaseList');
        var campagnList = component.get('v.campagnList');
        var criterionList = component.get('v.criterionList');

        var i = 0;
        for(i; i<listeContCase.length ; i++) {
            var contCase = '';
            if (listeContCase[i].hasOwnProperty('CampaignId__r')) {
                var campagna = listeContCase[i].CampaignId__r;
                if (campagna.hasOwnProperty('Name')) {
                    contCase = campagna.Name;
                }
            }            
            //var contCase = listeContCase[i].CampaignId__r.Name;
            var ind=campagnList.indexOf(contCase);
            if(ind == -1){
                campagnList.push(contCase);
                //console.log('contCase ','/'+ind+' '+contCase);
            }          
        }
        criterionList= [
            {'val':'Scadenza__c','label':'Scadenza'},
            {'val':'Tentativo__c','label':'Numero tentativi'},
            {'val':'Priority','label':'Priorità'}
        ]
        component.set('v.criterionList',criterionList);
            
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function (x) {
                return primer(x[field])
            } :
            function (x) {
                return x[field]
            };
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    cntSelected : function(component, event, helper){
        var qSelected = event.getSource().get('v.value');
        /*
        var cmpContact = $A.get("e.c:GUA_EventGestionToDettaglioContactEvt"); 
        cmpContact.setParams({
            "contact": contact
        });
        cmpContact.fire();
        */
        var event = $A.get("e.force:navigateToComponent");
    		event.setParams({
        			componentDef : "c:GUA_DettaglioContactCmp",
        			componentAttributes: {
            		contactDetail : qSelected,
                    queueContact : component.get('v.queueContact')
        			}
    		});
    		event.fire();
    },
    handleCaseSearchDealer : function(component, event){
       console.log('############# debug ');
       alert('######### ');
       console.log('########## caseList '+JSON.stringify(event.getParam('caseDealer') ) );
       var casesContact = event.getParam('caseDealer');
       alert('################### ');
       console.log('################  casesContact '+casesContact);
       component.set("v.paginationList",casesContact);
    },
    
    showToast: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },

})