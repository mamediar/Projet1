({
    helperInit : function(cmp) {
        
       // var today = new Date();
       // var MeseAttuale = today.getMonth()+1;
        var action = cmp.get("c.phaseInit");
        
        action.setCallback(this, function(response)
        {
            console.log("CallBack : " + response.getReturnValue());
            var wrapObject = response.getReturnValue();
            var AnnoAttuale = wrapObject.actualY;
            var MeseAttuale = wrapObject.actualM;
            var arrY = wrapObject.listOptionY;
            var arrM = wrapObject.listOptionM;
            var listWR = wrapObject.listWrapMock;
          //  console.log("CallBack : " + JSON.stringify(wrapObject.listOptionY));
            var options = [];
            var options2 = [];
            var options3 = [];
            
            arrY.forEach(function(obj){
            
            options.push({ label : obj.label, value: obj.value});
         	});                  
            arrM.forEach(function(obj){
            //console.log('*******' + obj.label );
            options2.push({ label : obj.label, value: obj.value});
            });
            
                               
            cmp.set('v.AnnoOption',arrY.reverse());
            cmp.set('v.MeseOption',arrM);
            cmp.set('v.DefAnno',AnnoAttuale);
            var annocombo = cmp.find("AnnoSelezione");
          	var mesecombo = cmp.find("MeseSelezione");
            annocombo.set("v.value",AnnoAttuale);
            mesecombo.set("v.value",MeseAttuale);
            //     cmp.set('v.selectedAnno',AnnoAttuale);
            //     cmp.set('v.selectedMese',MeseAttuale);
    //        console.log('********MESE' + MeseAttuale);
            cmp.set('v.DefMese', MeseAttuale); 
            cmp.set('v.objectListWR',listWR);
                               
        });
        $A.enqueueAction(action);
        
        cmp.set("v.CQPhaseTableColumns", [
            {label: 'AnnoMese', fieldName:'dataFiltro', type:'text',fixedWidth:170 },
            {label: 'Outsourcer',fieldName:'outsourcer', type:'text',fixedWidth:170 },
            {label: '#Fax',fieldName:'count', type:'number',fixedWidth:80 }
        ]);
        
        cmp.set("v.CQExcelTableColumns", [   
            {label: 'Outsourcer',fieldName:'outsourcer', type:'text'},
            //{label: 'Email', fieldName:'email', type:'text'},
            {label: 'Template',fieldName:'template', type:'text'},
            {label: 'File Generato',type:'button', typeAttributes:{label:'Apri',value:{fieldName:'fileG'}}},
            {label: 'Data File Generato',fieldName:'DGenerato', type:'date'}
        ]);
        
    },
    
    helperClickChange: function(cmp)
    {
        var action = cmp.get("c.PopulateTableChange");
            
        console.log('YEAR: ' + cmp.find("AnnoSelezione").get("v.value") + 'MESE: ' + cmp.find("MeseSelezione").get("v.value"));
        
        	action.setParams({
            	"Anno" : cmp.find("AnnoSelezione").get("v.value"),
            	"Mese" : cmp.find("MeseSelezione").get("v.value")
            });
            
        	action.setCallback(this, function(response)
            {
                var wrapObject = response.getReturnValue();
				console.log(JSON.stringify(wrapObject));
                cmp.set('v.objectListDaControllare',wrapObject.listDaControllare);
                cmp.set('v.objectListInviabile',wrapObject.listInviabili);
                cmp.set('v.objectListInviato',wrapObject.listInviati);
                cmp.set('v.objectListContestato',wrapObject.listContestati);
                cmp.set('v.objectListGestito',wrapObject.listRicontrollati);
                
                cmp.set('v.checkCQfax',false);
                cmp.set('v.checkCQfax',true);
                
            });
        	$A.enqueueAction(action);
    },
    helperHandleChange: function (cmp) 
    {    	
        var dAnno  =	cmp.get("v.DefAnno");
        var dMese  =	cmp.get("v.DefMese");
        var annoSelez = cmp.find("AnnoSelezione").get("v.value");
        var meseSelez = cmp.find("MeseSelezione").get("v.value"); 
        
        if((annoSelez == dAnno || annoSelez == null || annoSelez === undefined || annoSelez == "") && meseSelez >= dMese)
        {
            var selA = cmp.find('AnnoSelezione');
            selA.set("v.value",dAnno);
            var selM = cmp.find('MeseSelezione');
            selM.set("v.value",dMese);	
            
        }
        else
        {
            cmp.find("AnnoSelezione").get("v.value");
            cmp.find("MeseSelezione").get("v.value");
           // console.log('*************' + cmp.find("AnnoSelezione").get("v.value"));
        }    
    },
    
    helpersendToOutsourcer: function(cmp) 
    {
        var outSourcerSel = cmp.get("v.selectedOS2");
        console.log("outSourcerSel : " + outSourcerSel);
        var action = cmp.get("c.ExtractOutToSend");
        var outSourc=[];
        
        if (outSourcerSel != null  && outSourcerSel != 'undefined' && outSourcerSel !='')
        {
            outSourc.push(outSourcerSel); 
            console.log("outSourcSingle : " + outSourc);
        }
        else
        {
            var listSourcer = cmp.get("v.objectListInviabile");
            console.log("ù***" + JSON.stringify(listSourcer));
            listSourcer.forEach(function(obj){
                outSourc.push(obj.outsourcer);
            });
            console.log("outSourcAll : " + outSourc);
        }
        
	    action.setParams({
            "outSourc" : outSourc,
            "Anno" : cmp.find("AnnoSelezione").get("v.value"),
            "Mese" : cmp.find("MeseSelezione").get("v.value") 
        });
        
        action.setCallback(this, function(response)
        {
            console.log("CallBack : " + response.getReturnValue());
            var wrapObject = response.getReturnValue();
            var Esito = wrapObject.EsitoUpd;
            var resultsToast = $A.get("e.force:showToast");
            
            if(Esito==false)
            {
                 resultsToast.setParams({ "title": "Error",  "message": "Update Fallito.","type" : "Warning" });
                 resultsToast.fire();
            }
            else
            {
                 resultsToast.setParams({ "title": "Success",  "message": "Case Inviato." ,"type" : "Success"});
                 resultsToast.fire();
            }
        
             this.helperClickChange(cmp);             
         });
       
        $A.enqueueAction(action);
    },
    
    
    helperGeneraExcel : function(cmp) 
    {
        var outSourcerSel = cmp.get("v.selectedOS");
        var outSourc=[];
        console.log("outSourc : " + outSourcerSel);
        var action = cmp.get("c.GeneraReport"); //GeneraReport
        if (outSourcerSel != null  && outSourcerSel != 'undefined' && outSourcerSel !='')
        {
            outSourc.push(outSourcerSel); 
            console.log("outSourcSingle : " + outSourc);
        }
        else
        {
            var listSourcer = cmp.get("v.objectListWR");
            console.log("ù***" + JSON.stringify(listSourcer));
            listSourcer.forEach(function(obj){
                outSourc.push(obj.outsourcer);
            });
            console.log("outSourcAll : " + outSourc);
        }
        
	    action.setParams({
            "outSourc" : outSourc 
        });
        
        action.setCallback(this, function(response)
        {
             
             var wrapObject = response.getReturnValue();
            console.log("CallBack : " + JSON.stringify(wrapObject));
            var toastEvent = $A.get("e.force:showToast");
            if(wrapObject.EsitoUpd)
            {
                toastEvent.setParams({
                    "title": "Successo",
                    "message": "Report Generati",
                    "type":"Success"
                }); 
            }
            else
            {
                
                toastEvent.setParams({
                    "title": "Attenzione",
                    "message": "Errore Generazione Report",
                    "type":"Warning"
                });
                
            }
            toastEvent.fire();
            cmp.set('v.objectListWR',wrapObject.listWrapMock);
            cmp.set('v.checkCQfaxExcel',false);
            cmp.set('v.checkCQfaxExcel',true);  
        });
        $A.enqueueAction(action);
    },
    
    helperApprovaPenali: function(cmp) 
    {
        var outSourcerSel = cmp.get("v.selectedOS");
        console.log("outSourcerS : " + outSourcS);
        var action = cmp.get("c.ExtractEmailOutsource");
        var outSourcS=[];
        if (outSourcerSel != null  && outSourcerSel != 'undefined' && outSourcerSel !='')
        {
            outSourcS.push(outSourcerSel); 
            console.log("outSourcSingle : " + outSourcS);
        }
        else
        {
            var listSourcer = cmp.get("v.objectListWR");
            console.log("ù***" + JSON.stringify(listSourcer));
            listSourcer.forEach(function(obj){
                outSourcS.push(obj.outsourcer);
            });
            console.log("outSourcAll : " + outSourcS);
        }
        action.setParams({
            "outSourcS" : outSourcS
//            "Anno" : cmp.find("AnnoSelezione").get("v.value"),
  //          "Mese" : cmp.find("MeseSelezione").get("v.value")
        });
        action.setCallback(this, function(response)
        {
            
            var wrapObject = response.getReturnValue();
            console.log("CallBack : " + JSON.stringify(wrapObject));
            var toastEvent = $A.get("e.force:showToast");
            if(wrapObject.EsitoUpd)
            {
                toastEvent.setParams({
                    "title": "Successo",
                    "message": "Invio Effettuato",
                    "type":"Success"
                }); 
            }
            else
            {
                
                toastEvent.setParams({
                    "title": "Attenzione",
                    "message": "Errore Invio Email",
                    "type":"Warning"
                });
                
            }
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    }
    
})