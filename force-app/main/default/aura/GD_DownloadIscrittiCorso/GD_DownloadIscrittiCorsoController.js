({
	doInit : function(component, event, helper) 
    {
         var IdCorso = component.get('v.recordId');        
         var action = component.get("c.IscrittiAlCorso");
             action.setParams({ 'IDCorso': IdCorso });

             action.setCallback( this, function (response) 
             {
               //store state of response
               var state = response.getState();
               if( state === "SUCCESS" )
               {
                   var ResponseObj = response.getReturnValue();
                   component.set("v.objectList",ResponseObj);
                   //alert(JSON.stringify(ResponseObj));
               }
              });
                
          $A.enqueueAction(action);

    },
    downloadCsv : function(component,event,helper)
    {
        
       var stockData = component.get("v.objectList");
       //alert(JSON.stringify(stockData));
       if( stockData.length === 0 )
       {
           helper.showToast('Non ci sono record da scaricare!','ERROR');
           return;
       }
       
       var csv = helper.convertArrayOfObjectsToCSV(component, stockData);
       if (csv == null) return;

       // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
       var hiddenElement = document.createElement("a");
       hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
       hiddenElement.target = "_self"; //
       hiddenElement.download = "ExportData_Iscritti.csv"; // CSV file Name* you can change it.[only name not .csv]
       document.body.appendChild(hiddenElement); // Required for FireFox browser
       hiddenElement.click(); // using click() js function to download csv file

    }
})