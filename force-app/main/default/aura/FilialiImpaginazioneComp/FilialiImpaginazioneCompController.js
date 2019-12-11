({
  
  init: function(component, event, helper) 
  {
    helper.doInit(component, event);
    // this.hideSpinner(component);
    //this.showSpinner(component);
  },
  
  setValueFilter: function(component, event, helper) 
  {
        //set input value to attribute
        //set input value to attribute
        var namefiliale              = component.find("namefiliale").get("v.value");
        var codiceFiliale            = component.find("codiceFiliale").get("v.value");
        var valuenumeroPratiche      = component.find("numeroPratiche").get("v.value");
        var valuechiusoConforme      = component.find("chiusoConforme").get("v.value");
        var valuechiusoNonConforme   = component.find("chiusoNonConforme").get("v.value");
        var data                     = component.get("v.datafilialList");
        
        if( namefiliale ) 
        {
            data = data.filter( row =>row.Name.toLowerCase().includes(namefiliale.toLowerCase()) );
            helper.initializePagination(component, null, data);
            component.set("v.SpinnerSearch", true);
        }
      
        if( codiceFiliale ) 
        {
            data = data.filter(row => row.CodiceClienteFilled__c.toLowerCase().includes(codiceFiliale.toLowerCase()));
            helper.initializePagination(component, null, data);
            component.set("v.SpinnerSearch", true);
        }
      
        if( valuenumeroPratiche ) 
        {
            //alert(typeof data[0].COM_Numero_Pratiche_Filiale__c);
            data = data.filter(row => new String(row.COM_Numero_Pratiche_Filiale__c).includes(valuenumeroPratiche));
            /*data.forEach(function (value, index) {
              var numero = new Number(value.COM_Numero_Pratiche_Filiale__c); 
              data[index].COM_Numero_Pratiche_Filiale__c = numero;
            });*/
            helper.initializePagination(component, null, data);
            component.set("v.SpinnerSearch", true);
        }

        if( valuechiusoConforme ) 
        {
           //alert(typeof data[0].COM_Numero_Pratiche_Filiale__c);
           data = data.filter(row =>new String(row.COM_Numero_Pratiche_Conf_Filiale__c).includes(valuechiusoConforme));
           helper.initializePagination(component, null, data);
           component.set("v.SpinnerSearch", true);
        }

        if (valuechiusoNonConforme) 
        {
            //alert(typeof data[0].COM_Numero_Pratiche_Filiale__c);
            data = data.filter(row =>new String(row.COM_Numero_Pratiche_NConf_Filiale__c).includes(valuechiusoNonConforme));
            helper.initializePagination(component, null, data);
            component.set("v.SpinnerSearch", true);
        }

        if (namefiliale != "") {
          component.set("v.dataName", namefiliale);
        } else if (codiceFiliale != "") {
          component.set("v.codiceFiliale", codiceFiliale);
        } else if (valuenumeroPratiche != "") {
          component.set("v.numeroPratiche", valuenumeroPratiche);
        } else if (valuechiusoConforme != "") {
          component.set("v.chiusoConforme", valuechiusoConforme);
        } else if (valuechiusoNonConforme != "") {
          component.set("v.chiusoNonConforme", valuechiusoNonConforme);
        } else {
          helper.initializePagination(
            component,
            null,
            component.get("v.datafilialList")
          );
          component.set("v.SpinnerSearch", true);
        }
      
  },

  getRunSearch: function(component, event, helper) 
  {
        var dataName           = component.find("namefiliale").get("v.value");
        var codiceFiliale      = component.find("codiceFiliale").get("v.value");
        var numeroPratiche     = component.find("numeroPratiche").get("v.value");
        var chiusoConforme     = component.find("chiusoConforme").get("v.value");
        var chiusoNonConforme  = component.find("chiusoNonConforme").get("v.value");

        if( dataName == "" && codiceFiliale == "" && numeroPratiche == "" && chiusoConforme == "" &&
            chiusoNonConforme == "" ) 
        {
            helper.initializePagination( component, null , component.get("v.datafilialList") );
            component.set("v.SpinnerSearch", true);
        }else{
            helper.runSearch(component, event);
            component.set("v.SpinnerSearch", true);
        }
  },
 
  showSpinner: function(component) 
  {
    console.log("SppinerShown");
    component.set("v.SpinnerSearch", true);
  },
    
  hideSpinner: function(component) 
  {
    console.log("SppinerHidden");
    component.set("v.SpinnerSearch", false);
  },
 
  sortNumeroPratiche: function(component, event, helper) 
  {
      helper.sortColumn( component, "NumeroPratiche" );
  },

  sortChiusoConforme: function(component, event, helper) 
  {
      helper.sortColumn( component, "ChiusoConforme" );
  },
  
  sortChiusoNonConforme: function(component, event, helper)
  {
      helper.sortColumn( component, "ChiusoNonConforme" );
  },
    
  downloadCsv: function(component, event, helper) 
  {
    
      // get the Records [Filiali] list from 'paginationList' attribute
      //var stockData = component.get("v.datafilialList"); 
      var stockData   = component.get("v.objectList");
      if( stockData.length === 0 )
      {
          helper.showToast('Non ci sono record da scaricare!','ERROR');
          return;
      }
      // call the helper function which "return" the CSV data as a String
      var csv = helper.convertArrayOfObjectsToCSV(component, stockData);
      if (csv == null) {
         return;
      }

      // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
      var hiddenElement = document.createElement("a");
      hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
      hiddenElement.target = "_self"; //
      hiddenElement.download = "ExportData.csv"; // CSV file Name* you can change it.[only name not .csv]
      document.body.appendChild(hiddenElement); // Required for FireFox browser
      hiddenElement.click(); // using click() js function to download csv file
   },
   
  getIntervista: function(component, event, helper) 
  {
       
    var eventIntervista = $A.get("e.c:eventGetIntervista");
    eventIntervista.setParams({
        "loadData": true
    });
    eventIntervista.fire();
  },
    
  getPratica: function(component, event, helper) 
  {
      var pratiche           = event.target.getAttribute("data-index");
      var praticheCurrentObj = component.get("v.paginationList")[pratiche];
      var evt                = $A.get("e.c:eventNavigateToPraticheFiliali");
          evt.setParams({
                          Id: praticheCurrentObj.Name,
                          loadData :true
                        });
          evt.fire();
  },
  
  showToast : function(message, type)
  {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type : type
		});
		toastEvent.fire();
  }
    
});