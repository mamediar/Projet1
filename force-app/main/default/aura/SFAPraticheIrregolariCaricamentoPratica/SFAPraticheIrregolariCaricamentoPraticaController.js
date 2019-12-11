({
  
  init: function (component, event, helper) {
      helper.initHelper(component, event, helper);
       
      //controlla se le email per l'ultimo caso inserito sono state inviate oppure no e di conseguenza disabilita o meno il bottone
      var action = component.get("c.checkFlagInvioEmail"); 
      action.setCallback(this, function(response){
          if (response.getState() == 'SUCCESS'){
            var disableButtonInviaEmail=response.getReturnValue();
			component.set("v.disableButtonInviaEmail",disableButtonInviaEmail);
              if (disableButtonInviaEmail){
                  component.set("v.myText",'Le email per l\'ultima elaborazione caricata sono già state inviate.');
              } 
          }
      });
      $A.enqueueAction(action);             
  },


  loadFile: function (component, event, helper) {
    var result = event.getSource().get("v.files");

    if (result) {
      var file = result[0];

      var fileName = file.name.split(".")[0];
      var fileExtension = file.name.split(".")[file.name.split(".").length-1];

      var fr = new FileReader();

      fr.onload = function () {
        var fileContents = fr.result;

        var fileContentsLineArray = fileContents.split("\n");
        var length = fileContentsLineArray.length;

        if (fileContentsLineArray[length-1] == "") {
          fileContentsLineArray.pop();
          fileContents = fileContentsLineArray.join("\n");
        }

        component.set("v.fileContents", fileContents);
        component.set("v.fileName", fileName);
        component.set("v.fileExtension", fileExtension);

      };

      fr.readAsText(file);

    } 
    else {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        "type": "error",
        "title": "File non caricato",
        "message": "Errore nel caricamento"
      });
      toastEvent.fire();
    }

  },
  
  uploadFile: function (component, event, helper) {
    var fileName = component.get("v.fileName");
    var fileExtension = component.get("v.fileExtension");
    var fileContents = component.get("v.fileContents");
    var dataScadenza = component.get("v.dataScadenza");
    var dataScadenzaDate = new Date(new Date(dataScadenza).toDateString());

    var dataScadenzaString = new Date(dataScadenzaDate.getTime() - (dataScadenzaDate.getTimezoneOffset() * 60000)).toJSON();

    var today = new Date(new Date().toDateString());

    if (fileName && fileExtension && fileContents && dataScadenza) {
      if (dataScadenzaDate > today) {
        helper.uploadFileHelper(component, event, helper, fileContents, fileName, fileExtension, dataScadenzaString);      
      }
      else {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          "type": "error",
          "title": "Data di scadenza non valida",
          "message": "Selezionare una data di scadenza successiva a quella odierna"
        });
        toastEvent.fire();
      }

    }
    else {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        "type": "error",
        "title": "File non caricato",
        "message": "Selezionare un file ed inserire una data di scadenza"
      });
      toastEvent.fire();
    }
  },


  visualizzaTemplatesEmail: function (component, event, helper) {   
          var action = component.get("c.recuperaIndirizziEmail"); 
          action.setCallback(this, function(response){
              if (response.getState() == 'SUCCESS'){
                   var listaEmail=response.getReturnValue();
                   var resultsEmailFiliali=listaEmail.emailFiliali;    
                   var resultsEmailCoordinatoriArea=listaEmail.emailCoordinatoriArea;
                   var resultsEmailRegionalManager=listaEmail.emailRegionalManager;                  
                   var emailTemplateFiliale=listaEmail.emailTemplateFiliale;
                   var emailRegionalManager=listaEmail.emailRegionalManager;
                   var emailCoordinatoriArea=listaEmail.emailCoordinatoriArea;

                  var emailFiliali = [];
                  var emailCoordinatoriArea=[];
                  var emailRegionalManager=[];
                  for(var key in resultsEmailFiliali){
                      emailFiliali.push({value:resultsEmailFiliali[key], key:key});
                  }
                  for(var key in resultsEmailCoordinatoriArea){
                      emailCoordinatoriArea.push({value:resultsEmailCoordinatoriArea[key], key:key});
                  }
                  for(var key in resultsEmailRegionalManager){
                      emailRegionalManager.push({value:resultsEmailRegionalManager[key], key:key});
                  } 

                  
                  component.set("v.templatesEmailVisible", true);
                  component.set("v.emailFiliali", emailFiliali);                                    
                   component.set("v.emailCoordinatoriArea", emailCoordinatoriArea);   //emailCoordinatoriArea
                   component.set("v.emailRegionalManager", emailRegionalManager);
                   component.set("v.indirizziMailFiliali",listaEmail.emailFiliali);
                   component.set("v.indirizziMailCoordinatori",listaEmail.emailCoordinatoriArea);
                   component.set("v.indirizziMailRegional",listaEmail.emailRegionalManager);
                   component.set("v.emailTemplateFiliale",listaEmail.emailTemplateFiliale);
                   component.set("v.emailTemplateRegionalManager",listaEmail.emailTemplateRegionalManager);
                   component.set("v.emailTemplateCoordinatoriArea",listaEmail.emailTemplateCoordinatoriArea);
                      
                  
  
              }
              else {
                  console.log(response);
              }
          });
          $A.enqueueAction(action);           
   },

    
  inviaEmail: function (component, event, helper) {   
          var action = component.get("c.assegnaPraticheEAttivitaAllaCodaeInviaEmail"); 
          console.log('adesso entro');     
          action.setParams({               
              emailFiliali:component.get("v.indirizziMailFiliali"),               
          	  emailCoordinatoriArea:component.get("v.indirizziMailCoordinatori"),
              emailRegionalManager:component.get("v.indirizziMailRegional")
          });      
          action.setCallback(this, function(response){
              console.log('adesso esco');
              if (response.getState() == 'SUCCESS'){
                   console.log('adesso successo');
                    component.set("v.disableButtonInviaEmail",true);
                    component.set("v.myText",'Le email per l\'ultima elaborazione caricata sono già state inviate.');
                    $A.get("e.force:refreshView").fire();   
                    var toastEvent = $A.get("e.force:showToast");                     
                    toastEvent.setParams({ 
                      "type": "success",  
                      "message": "Le nuove pratiche caricate sono state aperte per i relativi utenti di filiale e le mail sono state correttamente inviate."  
                    });  
                    toastEvent.fire();                   
              } else {
                    var toastEvent = $A.get("e.force:showToast");                     
                    toastEvent.setParams({  
                      "type": "error",
                      "message": "Errore nell\'apertura delle nuove pratiche caricate per i relativi utenti di filiale e il relativo invio delle email."  
                    });  
                    toastEvent.fire();                  
              }
          });
          $A.enqueueAction(action);   
          console.log('adesso esco fine');
   },
    
    
  chiudiCasoCaricatoConErrore: function (component, event, helper) {   
          var action = component.get("c.chiudiCasoConErrore"); 
          action.setParams({               
              caseId:component.get("v.caseId")
          });      
          action.setCallback(this, function(response){
              console.log('adesso esco');
              if (response.getState() == 'SUCCESS'){
					var chiuso=response.getReturnValue();
                      if (chiuso){
                          component.set("v.isCasePending",false);
                           
                         
                      } else {
                            var toastEvent = $A.get("e.force:showToast");                     
                            toastEvent.setParams({  
                              "type": "error",
                              "message": "Errore nella preprarzione per un nuovo caricamento!"  
                            });  
                            toastEvent.fire();                          
                      }
                  
              } else {
                    var toastEvent = $A.get("e.force:showToast");                     
                    toastEvent.setParams({  
                      "type": "error",
                      "message": "Errore nella preprarzione per un nuovo caricamento!"  
                    });  
                    toastEvent.fire();                  
              }
          });
          $A.enqueueAction(action);   
          console.log('adesso esco fine');
   }
    
    
})