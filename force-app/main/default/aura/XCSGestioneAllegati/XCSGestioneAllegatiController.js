({
    init:function(cmp,event,helper){

        var cloned = cmp.get('v.isCloned');
        helper.showSpinner(cmp, event);
        var columns = [];

        if(cloned){

            columns=[
                 {'label':'Data','fieldName':'ContentType','type':'text'},
                {'label':'Nome','fieldName':'Url','type':'url',typeAttributes: { label: { fieldName: 'Name' }, target:'_blank'}},
                {'label':'Creato','fieldName':'ContentType','type':'text'}//,
                //{'label':'','type': 'button','typeAttributes':{'label':'Stampa/Download','name':'print','title':"Click per stampare l'allegato"},cellAttributes: { alignment: 'right' }}
            ];


        }else{
            
            //columns=[{'label':'Nome','fieldName':'Name','type':'text'}];
            columns=[
                 {'label':'Data','fieldName':'ContentType','type':'text'},
                {'label':'Nome','fieldName':'Url','type':'url',typeAttributes: { label: { fieldName: 'Name' }, target:'_blank'}}
            
            ];
            if(cmp.get('v.canDelete')){
                columns.push({'label':'','type': 'button','typeAttributes':{'label':'Delete','name':'delete','title':"Click per eliminare l'allegato"},cellAttributes: { alignment: 'right' }});
            }
            
        }

        cmp.set('v.columns',columns);
        helper.hideSpinner(cmp, event);
        

    },
    /*
    addFile:function(cmp,event,helper){
        //Controllo il num di allegati B.T.
        
        var numAlleg = cmp.get("v.fileList");
        if(numAlleg.length >= 5){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Errore inserimento",
                "type" : "Error",
                "message": "Puoi inserire al massimo 5 allegati"
            });
            toastEvent.fire();
            
            return;
            
        }
        
        var file=(event.getParam('files'))[0];
        console.log('@@@ file: '+file);
        var list=[];
        var previousList=cmp.get('v.fileList');
        var r=new FileReader();
        
        r.onload=(function(file){
            return function(e){
                var numFile =   cmp.get("v.identAllegato");
                var content=e.target.result;
                console.log('@@@ content: '+content);
                var fileToAdd={};
                
                fileToAdd['Body']=(content.split('base64,')[1]);
                fileToAdd['Name']=file.name;
                fileToAdd['ContentType']=file.type;
                fileToAdd['Description']=file.Description;
                fileToAdd['CreatedDate']=file.CreatedDate;
                if(file.Description != 'undefined' && file.Description != null && file.Description != '' && file.Description != undefined){
                    var str = file.Description;
                    var res = str.split("=");
                    fileToAdd['Url']=res[1]; 
                }else{

                }
                	
                var j = 1;
                var temp=fileToAdd['Name'];
                for(var i=0;i<previousList.length;){
                    console.log(fileToAdd['Name'] +' - '+ previousList[i].Name)
                    if(temp == previousList[i].Name){
                        temp = j+'_'+fileToAdd['Name'];
                        j++; i=0;
                    }
                    else i++;
                }
                fileToAdd['Name'] = temp;
                
                for(var i=0;i<previousList.length;i++){
                    
                    list.push(previousList[i]);
                }
                list.push(fileToAdd);
                
                cmp.set('v.fileList',list);
                helper.hideSpinner(cmp, event);
            };
        })(file);
        r.readAsDataURL(file);
        helper.showSpinner(cmp, event);
    },*/
    
    addFile:function(cmp,event,helper){
        //Controllo il num di allegati B.T.
        
        var numAlleg = cmp.get("v.fileList");
        /*if(numAlleg.length >= 5){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Errore inserimento",
                "type" : "Error",
                "message": "Puoi inserire al massimo 5 allegati"
            });
            toastEvent.fire();
            return;            
        }*/
        
        var file=(event.getParam('files'))[0];
        console.log('@@@ file: '+file);
        
        var list=[];
        var previousList=cmp.get('v.fileList');
        var r=new FileReader();
        
        r.onload=(function(file){
            return function(e){
                var numFile =   cmp.get("v.identAllegato");
                var content=e.target.result;
                console.log('@@@ content: '+content);
                //var list = [];
                //for(var i=0; i<resp.length; i++){
                var urlFile = '';
                if(file.Description != 'undefined' && file.Description != null && file.Description != '' && file.Description != undefined){
                    var str = file.Description;
                    var res = str.split("=");
                    urlFile = res[1]; 
                }else{
                    //urlFile = file.name;
                    urlFile = window.location.href;
                    console.log('CURRENT URL JAVASCRIPT: '+window.location.href);
                }
                var obj = {
                    Name : file.name,
                    Body : (content.split('base64,')[1]),
                    Description : file.Description,
                    ContentType : file.ContentType,
                    CreatedDate : file.CreatedDate,
                    ParentId : file.ParentId,
                    Url : urlFile
                }
                //list.push(obj); 
                //}
                
                	
                var j = 1;
                var temp=file.name;
                for(var i=0;i<previousList.length;){
                    console.log(file.name +' - '+ previousList[i].Name)
                    if(temp == previousList[i].Name){
                        temp = j+'_'+file.name;
                        j++; i=0;
                    }
                    else i++;
                }
                obj.Name = temp;
                
                for(var i=0;i<previousList.length;i++){
                    list.push(previousList[i]);
                }
                list.push(obj);
                
                cmp.set('v.fileList',list);
                cmp.set('v.numberAttach',list.length);
                helper.hideSpinner(cmp, event);
            };
        })(file);
        r.readAsDataURL(file);
        helper.showSpinner(cmp, event);
    },

    selectAllegati : function(cmp,event,helper){
        var allegatiSel = cmp.find('attachmentTable');
        
        allegatiSel = allegatiSel.getSelectedRows();
        console.log(allegatiSel);
        if(allegatiSel.length>0){
            cmp.set('v.allegatiSelezionati',allegatiSel);
            for(var i=0 ; i<allegatiSel.length; i++){
                if(allegatiSel[i].Description == 'undefined' || allegatiSel[i].Description == null || allegatiSel[i].Description == ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Attenzione",
                        "type" : "warning",
                        "message": "Alcuni allegati non sono associati al reclamo pertanto non è possibile inviarli; salvare il reclamo per procedere con l'invio."
                    });
                    toastEvent.fire();
                    var list=[];
                    cmp.get('v.fileList').forEach(function(temp){
                        temp;
                        
                        //if(temp.Description!=idDocument){
                        list.push(temp);
                        //}
                    });
                    
                    cmp.set('v.fileList',list);
                    cmp.set('v.numberAttach',list.length);
                    list = [];
                    cmp.set('v.allegatiSelezionati',[]);
                    return;
                }
            }
        }else{
            allegatiSel = allegatiSel ? allegatiSel : [];
            cmp.set('v.allegatiSelezionati',allegatiSel);
        }
        var x = cmp.get('v.allegatiSelezionati');
        
    },
    
    deleteFile:function(cmp,event,helper){
        var fileList = cmp.get('v.fileList');

        if(fileList.length==1){

            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Errore cancellazione",
                "type" : "error",
                "message": "Impossibile cancellare, deve essere presente almeno un allegato."
            });
            toastEvent.fire();

        }else{


            helper.showSpinner(cmp, event);
            
            var list=[];
            var fileName = event.getParam("row").Name;
            var idParent = event.getParam("row").ParentId;
            var idDocument = event.getParam("row").Description;
            
            cmp.set('v.fileName', fileName);
            cmp.set('v.idParent', idParent);
            
            var f = cmp.get('v.fileName');
            var i = cmp.get('v.idParent');
            
            var action = cmp.get("c.deleteAttachment");
            action.setParams({
                idFile : idDocument,
                idParent : idParent
            });
            action.setCallback(this,function(response){
                if (response.getState()== 'SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Allegato Cancellato",
                        "type" : "success",
                        "message": "L'allegato è stato cancellato correttamente."
                    });
                    toastEvent.fire();
                    cmp.set('v.showList',false);
                    cmp.set('v.showList',true);
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Errore",
                        "type" : "error",
                        "message": "Non è stato possibile cancellare l'allegato: Ricarica la pagina"
                    });
                    toastEvent.fire();
                }
                helper.hideSpinner(cmp, event);
            });
            $A.enqueueAction(action);
            
            cmp.get('v.fileList').forEach(function(temp){
                
                if(temp.Description!=idDocument){
                    list.push(temp);
                }
            });
            
            
            console.log("Fine");
            console.log(list);
            cmp.set('v.fileList',list);
            cmp.set('v.numberAttach',list.length);
        }
    },

    salvaComeGestita : function(component, event, helper){
        helper.salvaComeGestita(component, event, helper);
    }
    
  
    
})