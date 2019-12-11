({
          /**
	 * @description : To show Toast
	 * @author: Mady COLY
	 * @date: 27/05/2019
	 * @param :message
	 * @param :type
	 */
    showToast: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
          /**
	 * @description : fetch the  List Aggiungi al corso
	 * @author: Mady COLY
	 * @date: 30/07/2019
	 */
	getAllAggiungiCorso : function(component,event) {
		 var action = component.get("c.getAllAggiungiCorso");
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var responseValue= response.getReturnValue();
                if(!responseValue.error){
                    component.set("v.aggiungiCorsoList",responseValue.data);
                }
                else
                {
                    this.showToast('Non successo', 'ERROR');
                }
            }else
            {
                this.showToast('Non successo', 'ERROR');
            }
        });
        $A.enqueueAction(action);
    },
         /**
	 * @description : fetch the  List tipologia al corso
	 * @author: Mady COLY
	 * @date: 31/07/2019
	 */
    getAllTipologiaCorso : function(component,event) {
        var action = component.get("c.getAllTipologiaCorso");
       action.setCallback(this,function(response){
           var state = response.getState();
           if (state === 'SUCCESS') {
               var responseValue= response.getReturnValue();
               if(!responseValue.error){
                   component.set("v.tipologiaCorsoList",responseValue.data);
               }
               else
               {
                   this.showToast('Non successo', 'ERROR');
               }
           }else
           {
               this.showToast('Non successo', 'ERROR');
           }
       });
       $A.enqueueAction(action);
   },
         /**
	 * @description : fetch the  List tipologia al corso
	 * @author: Mady COLY
	 * @date: 31/07/2019
	 */
    getAnnoRiferimento : function(component,event) {
        var annoRiferimento=[];
        var dateToday = new Date();
        var datelastYear = new Date();
        var dateNextYear = new Date();
        dateNextYear.setFullYear(dateNextYear.getFullYear()+1);
        datelastYear.setFullYear(datelastYear.getFullYear()-1);
        annoRiferimento.push(datelastYear.getFullYear());
        annoRiferimento.push(dateToday.getFullYear());
        annoRiferimento.push(dateNextYear.getFullYear());
        component.set("v.annoRiferimento",annoRiferimento);
    },
          /**
	 * @description : fetch the  List IVASS_Dealer_Courses__c object
	 * @author: Mady COLY
	 * @date: 31/07/2019
	 */
    getAllDealerCourses: function(component,event) {
        var action = component.get("c.getAllDealerCourses");
       action.setCallback(this,function(response){
           var state = response.getState();
           if (state === 'SUCCESS') {
               var responseValue= response.getReturnValue();
               if(!responseValue.error){
                   component.set("v.dealerCoursesList",responseValue.data);
                   console.log("data: "+JSON.stringify(responseValue.data));
               }
               else
               {
                   this.showToast('Non successo', 'ERROR');
               }
           }else
           {
               this.showToast('Non successo', 'ERROR');
           }
       });
       $A.enqueueAction(action);
    },
    
    getQueueIVASS: function(component,event) {
       var action = component.get("c.getQueueIVASS");
       action.setCallback(this,function(response){
           var state = response.getState();
           if (state === 'SUCCESS') {
               var responseValue= response.getReturnValue();
               if(!responseValue.error){
                   component.set("v.IDQueueIVASS",responseValue);
                   console.log("data: "+JSON.stringify(responseValue));
               }
               else
               {
                   this.showToast('Non successo', 'ERROR');
               }
           }else
           {
               this.showToast('Non successo', 'ERROR');
           }
       });
       $A.enqueueAction(action);   
    },
    
    readFile: function(component, helper, file) {
        if (!file) return;
        console.log('file'+file.name);
        if(!file.name.match(/\.(csv||CSV)$/)){
            return console.log('only support csv files');
        }else{
            
            reader = new FileReader();
            reader.onerror =function errorHandler(evt) {
                switch(evt.target.error.code) {
                    case evt.target.error.NOT_FOUND_ERR:
                        console.log('File Not Found!');
                        break;
                    case evt.target.error.NOT_READABLE_ERR:
                        console.log('File is not readable');
                        break;
                    case evt.target.error.ABORT_ERR:
                        break; // noop
                    default:
                        console.log('An error occurred reading this file.');
                };
            }
            //reader.onprogress = updateProgress;
            reader.onabort = function(e) {
                console.log('File read cancelled');
            };
            reader.onloadstart = function(e) { 
                
                var output = '<ui type=\"disc\"><li><strong>'+file.name +'</strong> '+file.size+'bytes</li></ui>';
                component.set("v.filename",file.name);
                component.set("v.TargetFileName",output);
               
            };
            reader.onload = function(e) {
                var data=e.target.result;
                component.set("v.fileContentData",data);
                console.log("file data"+JSON.stringify(data));
                var allTextLines = data.split(/\r\n|\n/);
                var dataRows=allTextLines.length-1;
                var headers = allTextLines[0].split(',');
                console.log("header : "+headers);
                console.log("Rows length::"+dataRows);
                  	var numOfRows=component.get("v.NumOfRecords");
                      console.log("numOfRows::"+numOfRows);
                      if(dataRows > numOfRows+1 || dataRows == 1 || dataRows== 0){
                   
                     console.log("File Rows between 1 to "+numOfRows+" .");
                    component.set("v.showMain",false);
                    
                } 
                else{
                    component.set("v.showMain",true);                   
                }
            }
            reader.readAsText(file);
            
        }
        var reader = new FileReader();
        reader.onloadend = function() {
         
        };
        reader.readAsDataURL(file);
    },
    
    saveRecords : function(component,helper,event){
       // alert('batchIsFinish : '+component.get('v.batchIsFinish'));
        if(component.get('v.batchIsFinish')==undefined){
            component.set('v.batchIsFinish',false);
            //alert("batch      started");
            console.log('17_10_2019 dealerCorso:'+JSON.stringify( component.get("v.dealerCorso") ) );
            var action = component.get("c.processData");
            var fieldsList=['REGIONE','AREA','FILIALE','COD. OCS CONV.','RAGIONE SOCIALE','MAIL CONV.','COD. OCS REF.','COGNOME','NOME','CODICE FISCALE','MAIL REFERENTE','DATA ISCRIZIONE','UTENZA','PASSWORD','generic_field_1','generic_field_2','generic_field_3','INVIO OUTSOURCER','NOTE'];
            component.set("v.datenow",Date.now());
            action.setParams({ fileData : component.get("v.fileContentData"),
                              fields:fieldsList,
                              dealerCorso: component.get("v.dealerCorso")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.showMain",true);
                    var jobID = response.getReturnValue();
                    this.callbackOnceAfterDelay(component,helper,jobID);
                    //this.statusJob(component,event);
                }
                else if (state === "INCOMPLETE") {
                    console.log('saved successfully');
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                     errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
                var status=false;
            });
            $A.enqueueAction(action);
        }
        else if(component.get('v.batchIsFinish')==false){
            this.showToast('è in corso il processo di caricamento del file, attendere ...','ERROR');
        }else{
            this.showToast('il file è già stato salvato','ERROR');
        }
    },
    callbackOnceAfterDelay : function(component,helper,jobID) {
        var delayInMilliseconds = 1; //5 seconds
        window.setTimeout(function(){ helper.helpMethod(component,helper, jobID)}, delayInMilliseconds);       
    },
 helpMethod : function(component,helper,jobID) {
    console.log('myHelperMethod EXECUTING NOW... ');
    var action = component.get("c.isCompleted");
    action.setParams({ 'jobID' : jobID});
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            var responseValue = response.getReturnValue();
            if(responseValue.error==false){
                var jobInfo = responseValue.jobInfo;
                console.log('jobInfo : '+JSON.stringify(jobInfo));
                component.set('v.statusBatch',jobInfo.Status);
                if(jobInfo.Status =='Queued' || jobInfo.Status=='Preparing' || jobInfo.Status=='Processing'){
                    this.sleep(1000);
                    this.callbackOnceAfterDelay(component,helper,jobID)
                } else if (jobInfo.Status =='Completed'){
                    this.showToast('Completato, il file CSV è stato caricato correttamente','Success')
                    component.set('v.batchIsFinish',true);
                }else{
                    var listError = responseValue.listInError;
                    console.log('listError : '+JSON.stringify(listError));
                    this.showToast('Non Completato','ERROR');
                    component.set('v.batchIsFinish',true);
                }
            }
        }
        else {
       
        }                 
    });
    $A.enqueueAction(action);
 },

    readFileCorsi: function(component, helper, file) {
        if (!file) return;
        console.log('file'+file.name);
        if(!file.name.match(/\.(csv||CSV)$/)){
            return console.log('only support csv files');
        }else{
            reader = new FileReader();
            reader.onerror =function errorHandler(evt) {
                switch(evt.target.error.code) {
                    case evt.target.error.NOT_FOUND_ERR:
                        console.log('File Not Found!');
                        break;
                    case evt.target.error.NOT_READABLE_ERR:
                        console.log('File is not readable');
                        break;
                    case evt.target.error.ABORT_ERR:
                        break; // noop
                    default:
                        console.log('An error occurred reading this file.');
                };
            }
            //reader.onprogress = updateProgress;
            reader.onabort = function(e) {
                console.log('File read cancelled');
            };
            reader.onloadstart = function(e) { 
                
                var output = '<ui type=\"disc\"><li><strong>'+file.name +'</strong> '+file.size+'bytes</li></ui>';
                component.set("v.filename",file.name);
                component.set("v.TargetFileNameCorsi",output);
               
            };
            reader.onload = function(e) {
                var data=e.target.result;
                component.set("v.fileContentData",data);
                console.log("file data"+JSON.stringify(data));
                var allTextLines = data.split(/\r\n|\n/);
                var dataRowsLenght=allTextLines.length-1;
                var headers = allTextLines[0].split(',');
                var errorContentFile = false;
                var errorMsgContentFile = '';
                var dealerList =[];
                console.log("header : "+headers);
                console.log("Rows length::"+dataRowsLenght);
                  	var numOfRows=component.get("v.NumOfRecords");
                    if(dataRowsLenght > numOfRows+1 || dataRowsLenght == 1 || dataRowsLenght== 0){
                   
                     console.log("File Rows between 1 to "+numOfRows+" .");
                    component.set("v.showMainCorsi",false);
                } 
                else{
                    component.set("v.showMainCorsi",true);  
                    component.set('v.batchIsFinish',undefined);
                    console.log(' ************************ start controlli_formali_contenuto_file ****************************');
                    var fields=['REGIONE','AREA','FILIALE','COD. OCS CONV.','RAGIONE SOCIALE','MAIL CONV.','COD. OCS REF.','COGNOME','NOME','CODICE FISCALE','MAIL REFERENTE','DATA ISCRIZIONE','UTENZA','PASSWORD','generic_field_1','generic_field_2','generic_field_3','INVIO OUTSOURCER','NOTE'];
                    var dataFile = component.get('v.fileContentData');
                    var dataRows= dataFile.split(/\r\n|\n/);

                      // Check if the file is empty
                      if(dataRows.length>0){
                    //controll the header of file
                    var header = dataRows[0].split(';');
                      //Check for the header that is correct
                      console.log('beafore header, size : '+header.length);
                      if(header.length== 19){
                        console.log('after header');
                        // chech if the format of header is correct
                        if(header[0]==fields[0] && header[1]==fields[1] && header[2]==fields[2] && header[3]==fields[3] && header[4]==fields[4] && header[5]==fields[5] && header[6]==fields[6]
                            && header[7]==fields[7] && header[8]==fields[8] && header[9]==fields[9] && header[10]==fields[10] && header[11]==fields[11] && header[12]==fields[12] && header[13]==fields[13]
                            && header[14]==fields[14] && header[15]==fields[15] && header[16]==fields[16] && header[17]==fields[17], header[18]==fields[18]){
                                // check if the content of file is correct
                                console.log("size dataRows: "+dataRows.length);
                                for( var i=1;i<dataRows.length;i++){
                                    var dataRow = dataRows[i].split(";");
                                    console.log(" size datarow : "+dataRow.length);
                                    if(dataRow.length!=19 && dataRow.length>=2)
                                    {
                                        errorContentFile = true;
                                        component.set('v.erroMsg','errore nel contenuto del file');
                                        errorMsgContentFile =  errorMsgContentFile.concat(" errore alla linea "+ i +", il formato della riga non è corretto \r\n .")
                                    } 
                                    
                                    dealerList.push(dataRow[3]);
                                }
                                console.log("list dealers : "+JSON.stringify(dealerList));
                              
                                component.set("v.errorMsgContentFile",errorMsgContentFile);
                              //  return errorContentFile;
                            }
                      } 
                      else{
                        console.log('after header in else');
                        errorContentFile = true;
                        component.set('v.erroMsg','il formato dell\'intestazione del file non è corretto');
                      }   
                    }
                    else
                    {
                        errorContentFile = true;
                        component.set('v.erroMsg','Il file è vuoto');
                    }
                    component.set("v.errorFile",errorContentFile);
                   // return false;
                   console.log("errorFile : "+component.get("v.errorFile"));
                    console.log(' ************************ end controlli_formali_contenuto_file ****************************');
                }
            }
            reader.readAsText(file);
        }
        var reader = new FileReader();
        reader.onloadend = function() {
         
        };
        reader.readAsDataURL(file);

              
    },
    saveRecordsCorsi : function(component,event){
        //this.show(component,event);
        var action = component.get("c.uploadRecordsCorsi");
        var fieldsList=['REGIONE','AREA','FILIALE','COD. OCS CONV.','RAGIONE SOCIALE','MAIL CONV.','COD. OCS REF.','COGNOME','NOME','CODICE FISCALE','MAIL REFERENTE','DATA ISCRIZIONE','UTENZA','PASSWORD','generic_field_1','generic_field_2','generic_field_3','INVIO OUTSOURCER','NOTE'];
        component.set("v.datenow",Date.now());
        action.setParams({ fileData : component.get("v.fileContentData"),
                          fields:fieldsList});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showMain",true);
                this.sleep(1000);
                this.callbackOnceAfterDelay(component,jobID);
                //this.statusJob(component,event);
            }
            else if (state === "INCOMPLETE") {
                //console.log('saved successfully');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            var status=false;
        });
        $A.enqueueAction(action);
    },
    sleep : function(milliseconds) {
        console.log('sleep started');
        var start = new Date().getTime();
        for (var i = 0; i < 1e7; i++) {
          if ((new Date().getTime() - start) > milliseconds){
            break;
          }
        }
    },
})