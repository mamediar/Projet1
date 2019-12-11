({
	convertArrayOfObjectsToCSV : function(component, objectRecords) 
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
       lineDivider   = "\n";
       // in the keys variable store fields API Names as a key
       // this labels use in CSV file header
       keys = [ "Regione__c","Area__c","Filiale__c","Codice_Intermediario__c","Ragione_Sociale__c",
                "Name","Cognome__c","Nome__c","Codice_Fiscale__c","Data_Iscrizione__c",
                "Stato_Corso__c","Note__c","Esito_Outsourcer__c","Note_x_Outsourcer__c"
              ]; 
        
       keysLabelName = [ "REGIONE","AREA","FILIALE","CODICE INTERMEDIARIO","RAGIONE SOCIALE",
                         "CODICE REFERENTE","COGNOME","NOME","CODICE FISCALE","DATA ISCRIZIONE",
                         "STATO CORSO","NOTE","ESITO OUTSOURCER",
                         "NOTE OUTSOURCER"
                       ];
        
       csvStringResult = "";
       csvStringResult += keysLabelName.join(columnDivider);
       csvStringResult += lineDivider;
       //alert(JSON.stringify(objectRecords));
       for( var i = 0; i < objectRecords.length; i++ ) 
       {
            counter = 0;
            for( var sTempkey in keys )
            {
                 var skey = keys[sTempkey];
                 // add , [comma] after every String value,. [except first]
                 if( counter > 0 ) 
                 {
                     csvStringResult += columnDivider;
                 }
                
                 if (objectRecords[i][skey] == undefined) 
                 {
                     csvStringResult += " ";
                 }else{ 
                     csvStringResult += '"' + objectRecords[i][skey] + '"';
                 }
                 
                 counter++;
            }
            csvStringResult += lineDivider;
       }
       //alert(csvStringResult);

       return csvStringResult;
	} , 
    
    showToast : function(message, type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type : type
		});
		toastEvent.fire();
	}
})