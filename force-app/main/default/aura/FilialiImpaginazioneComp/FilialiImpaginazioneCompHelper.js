({
  
  doInit: function(component, event) 
  {
         try{
               var action = component.get("c.getAllFiliale");
                   action.setCallback( this, function(response) 
                   {
                         var state = response.getState();
                         if( state === "SUCCESS" )
                         {
                             var storeResponse = response.getReturnValue();
                             component.set("v.datafilialList", storeResponse);
                             component.set("v.objectList", storeResponse);
                             this.initializePagination(component, null, storeResponse);
                         }
                   });
               $A.enqueueAction(action);
            }catch(e){}
  },
  
  PageDetails: function(component, recs) 
  {
        var paginationList = [];
        for( var i = 0; i < recs.length; i++ )
        {
             paginationList.push(recs[i]);
        }
        component.set("v.paginationList", paginationList);
  },
  
  initializePagination: function(component, event, recs) 
  {
        var pageSize = component.get("v.pageSize");
        component.set("v.start", 0);
        component.set("v.end", pageSize - 1);
        var totalPage = Math.ceil(recs.length / pageSize);
        console.log("totalPage=" + totalPage);
        component.set("v.totalPage", totalPage);
        
        var pages = [];
        for( var i = 1; i <= totalPage; i++ )
        {
             pages.push(i);
        }
        component.set("v.pages", pages);
    
        var paginationList = [];
        for( var i = 0; i < pageSize; i++ )
        {
             if( recs.length > i )paginationList.push(recs[i]);
        }
    
        component.set("v.totalRecord", recs.length);
        component.set("v.objectList", recs);
        component.set("v.paginationList", paginationList);
        component.set("v.currentPage", 1);
        this.PageDetails(component, paginationList);
  },
 
  runSearch: function(component, event) 
  {
    
           var action = component.get("c.execQueryFiltered");
           action.setParams({
                   NameFiliale: component.get("v.dataName"),
                   codiceFiliale: component.get("v.codiceFiliale"),
                   numeroPratiche: component.get("v.numeroPratiche"),
                   chiusoConforme: component.get("v.chiusoConforme"),
                   chiusoNonConforme: component.get("v.chiusoNonConforme")
               });
    
           action.setCallback( this, function(response) 
           {
                 var state = response.getState();
                 if( state === "SUCCESS" ) 
                 {
                     this.initializePagination(component, null, response.getReturnValue());
                 }else{
                     $A.log("Errors", action.getError());
                 }
           });
           $A.enqueueAction(action);
  },

  handleFilter: function(data, key, fieldName) 
  {
        var regex;
        try {
            regex = new RegExp(key, "i");
            data = data.filter(function (row) { return row.fieldName.toLowerCase().includes(key.toLowerCase()); });
        }catch(e){
          console.error(e);
        }
        return data;
 },
    
  convertArrayOfObjectsToCSV: function(component, objectRecords) 
  {
       // declare variables
       var csvStringResult,counter,keys,columnDivider,lineDivider,keysLabelName;
       // check if "objectRecords" parameter is null, then return from function
       if( objectRecords == null || !objectRecords.length ){
           return null;
       }
       // store ,[comma] in columnDivider variabel for sparate CSV values and
       // for start next line use '\n' [new line] in lineDivider varaible
       columnDivider = ",";
       lineDivider = "\n";

       // in the keys variable store fields API Names as a key
       // this labels use in CSV file header
       keys = ["CodiceClienteFilled__c","Name","COM_Numero_Pratiche_Filiale__c","COM_Numero_Pratiche_Conf_Filiale__c",
               "COM_Numero_Pratiche_NConf_Filiale__c"
              ];

       keysLabelName = [ "CODICE DIPENDENZA","FILIALE","NUMERO PRATICHE","CHIUSO CONFORME","CHIUSO NON CONFORME" ];

       csvStringResult  = "";
       csvStringResult += keysLabelName.join(columnDivider);
       csvStringResult += lineDivider;

       for( var i = 0; i < objectRecords.length; i++ ) 
       {
            counter = 0;
            for( var sTempkey in keys ) 
            {
                 var skey = keys[sTempkey];
                 // add , [comma] after every String value,. [except first]
                 if( counter > 0 ){
                     csvStringResult += columnDivider;
                 }
                 var CellN = objectRecords[i][skey];
                 if( CellN === undefined )
                 {
                     csvStringResult += '""';
                 }else{
                     csvStringResult += '"' + objectRecords[i][skey] + '"';
                 }
                 //csvStringResult += '"'+ objectRecords[i][skey]+'"';
                 counter++;
            } // inner for loop close
            csvStringResult += lineDivider;
       } // outer main for loop close
        // return the CSV formate String
    return csvStringResult;
  },
    
  showToast: function (message, type) 
  {
       var toastEvent = $A.get("e.force:showToast");
           toastEvent.setParams({
                message: message,
                type: type
           });
           toastEvent.fire();
  },
   
  sortColumn: function( component, column)
  {
      if( column === "ChiusoNonConforme"){
          component.set("v.selectedTabsoft","chiusononconforme");
      }else if( column === "ChiusoConforme"){
          component.set("v.selectedTabsoft","chiusoconforme");
      }else if( column === "NumeroPratiche"){
          component.set("v.selectedTabsoft","numeroPratiche");
      }
      //var list = component.get("v.datafilialList");
      var list                = component.get("v.objectList");
      var currentDir          = component.get("v.arrowDirection");
      var byListaFiliali      = list.slice(0);
      var x,y;

      if( currentDir == "arrowup" ) 
      {
          byListaFiliali.sort( function(a, b) 
          {
               if( column === "ChiusoNonConforme")
               {
                   x = a.COM_Numero_Pratiche_NConf_Filiale__c; 
                   y = b.COM_Numero_Pratiche_NConf_Filiale__c; 
               }else if( column === "ChiusoConforme" )
               {
                   x = a.COM_Numero_Pratiche_Conf_Filiale__c; 
                   y = b.COM_Numero_Pratiche_Conf_Filiale__c; 
               }else if( column === "NumeroPratiche" )
               {
                   x = a.COM_Numero_Pratiche_Filiale__c;
                   y = b.COM_Numero_Pratiche_Filiale__c;
               }
               return x - y;
          });
          component.set("v.arrowDirection", "arrowdown");
      }else{
          
          byListaFiliali.sort( function(a, b) 
          {
               if( column === "ChiusoNonConforme")
               {
                   x = a.COM_Numero_Pratiche_NConf_Filiale__c; 
                   y = b.COM_Numero_Pratiche_NConf_Filiale__c; 
               }else if( column === "ChiusoConforme" )
               {
                   x = a.COM_Numero_Pratiche_Conf_Filiale__c; 
                   y = b.COM_Numero_Pratiche_Conf_Filiale__c; 
               }else if( column === "NumeroPratiche" )
               {
                   x = a.COM_Numero_Pratiche_Filiale__c;
                   y = b.COM_Numero_Pratiche_Filiale__c;
               }
               return y - x;
          });
  
          component.set("v.arrowDirection", "arrowup");
      }

      this.initializePagination(component, event, byListaFiliali);
        
  }
    
});