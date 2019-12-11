/**
 * @File Name          : CaricareListaDEMController.cls
 * @Description        : 
 * @Author             : CISSE Ahmet
 * @Group              : 
 * @Last Modified By   : CISSE Ahmet
 * @Last Modified On   : 22/07/2019 à 12:00:01
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *============================================================================== 
 * 1.0    26/06/2019 à 08:29:47   CISSE Ahmet     Initial Version
**/

public with sharing class CaricareListaDEMController {

	//Initializing the wrapper message 
	public static AuraProcessingMessage returnMessage = new AuraProcessingMessage();
	public static List < String > listOfIterableRecords = new List < String > ();
	public static List < String > csvFieldNames = new List < String > ();
	public static List < CaricareListaDemUtils.Record2Object > lstRecord2Object = new List < CaricareListaDemUtils.Record2Object > ();
	public static Set < String > codiceClienteInCSVfile = new Set < String > ();
	public static List < Integer > listOfLineNumbersContainingErrors = new List < Integer > ();
	public static Map < String,
		Integer > fieldNumberMap = new Map < String,
		Integer > ();
   public static List < String > lstFieldNames = new List < String > ();

	@AuraEnabled
	//public static void readFromFileAndSave(String fileContent) {
	public static AuraProcessingMessage readFromFileAndSave(String fileContent) {
		CaricareListaDEmBatch caricareListaDEmBatch = new CaricareListaDEmBatch(fileContent);
		Id batchId = Database.executeBatch(caricareListaDEmBatch);
		//	returnMessage.contentMsg = '---- '+CaricareListaDemUtils.safeSplit(fileContent, '\r\n').size()+'---';
		returnMessage.contentMsg = 'A batch is started to process all the records of your CSV file and a report of execution will be sent to you after the treatment by mail.';
		return returnMessage;
	}

	@AuraEnabled
	public static AuraProcessingMessage readingAndControlOnTheCSVfile(String fileContent, String chosenFileType) {
		if (fileContent.length()>0) {
			listOfIterableRecords = CaricareListaDemUtils.safeSplit(fileContent, '\r\n');
		}
			System.debug('*************1-Size of listOfIterableRecords: '+listOfIterableRecords.size());
		if (listOfIterableRecords.size() > 1) {
			csvFieldNames = CaricareListaDemUtils.safeSplit(listOfIterableRecords[0], ';');
			listOfIterableRecords.remove(0);
			System.debug('*************2-Size of csvFieldNames List: '+csvFieldNames.size());
			//--------------------------------------------------------------------------------
			if (chosenFileType == 'DEM_Clenti') {
				if (csvFieldNames.size() != 8) {
					returnMessage.isSuccess = false;
					returnMessage.title = 'Error';
					returnMessage.severity = 'error';
					returnMessage.contentMsg = 'Attenzione: il file caricato non rispetta gli standard di formattazione1';
					System.debug('Attenzione: il file caricato non rispetta gli standard di formattazione1');
					return returnMessage;
				}
				else {
					returnMessage = convertRecordToObject(listOfIterableRecords, 8);
					return returnMessage;
				}
			}//------------------------------------------------------------------------------
			else {
				if (csvFieldNames.size() != 30) {
					returnMessage.isSuccess = false;
					returnMessage.title = 'Error';
					returnMessage.severity = 'error';
					returnMessage.contentMsg = 'Attenzione: il file caricato non rispetta gli standard di formattazione2';
					System.debug('Attenzione: il file caricato non rispetta gli standard di formattazione2');
					return returnMessage;
				}
				else {
					returnMessage = convertRecordToObject(listOfIterableRecords, 30);
					return returnMessage;
				}
			}
			//---------------------------------------------------------------------------------
		}
			returnMessage.isSuccess = false;
			returnMessage.title = 'Error';
			returnMessage.severity = 'error';
			returnMessage.contentMsg = 'Attenzione: il file caricato non rispetta gli standard di formattazione3';
			System.debug('Attenzione: il file caricato non rispetta gli standard di formattazione3');
			return returnMessage;
	}

	public static AuraProcessingMessage convertRecordToObject(List < String > records, Integer numberOfColumn) {    		
		String fieldValue;
		Integer fieldNumber;
		CaricareListaDemUtils.Record2Object record2Object;
		returnMessage.isSuccess = true;
		returnMessage.title = 'Confirmation';
		returnMessage.severity = 'confirm';
		returnMessage.contentMsg = 'La lista selezionata ha superato i controllo Validata';	
		System.debug('La lista selezionata ha superato i controllo Validata');
		try {
                for (Integer i = 0; i < csvFieldNames.size(); i++) {
				fieldNumberMap.put(csvFieldNames[i], i);
				lstFieldNames.add(csvFieldNames[i].trim());
            }
			//Browse the recovered rows to put them in Contact objects to use for the update.
			for (Integer i = 0; i < records.size(); i++) {

                System.debug('... csvFieldNames ...: ' + csvFieldNames);
                System.debug('... fieldNumberMap ...: ' + fieldNumberMap);
                System.debug('... lstFieldNames ...: ' + lstFieldNames);

				record2Object = new CaricareListaDemUtils.Record2Object();
				string[] csvRecordData = CaricareListaDemUtils.safeSplit(records[i], ';');
				/*This line is not correct because:
                --Somme Columns are missing.
                --OR The number of columns is greater than normal (number of columns of the first line).
                --This line has missing data (codiceCliente OR dEMDatainvio OR nameOfCampagne).
                So we do not treat her. We go to next line.
                */
				if (csvFieldNames.size() == numberOfColumn && csvRecordData.size() == csvFieldNames.size() && csvRecordData[0].trim() != '' && csvRecordData[6].trim() != '' && csvRecordData[7].trim() != '') {
						codiceClienteInCSVfile.add(csvRecordData[0].trim());
						System.debug('---Line---: ' + i);
						for (String fieldName: csvFieldNames) {
							fieldNumber = fieldNumberMap.get(fieldName);
							fieldValue = csvRecordData[fieldNumber];
							System.debug('---' + fieldName + '---= ' + fieldValue);
							record2Object.putAvalue(fieldName.trim(), fieldValue.trim());
						}
						lstRecord2Object.add(record2Object);
				} else {
					records.remove(i);
					listOfLineNumbersContainingErrors.add((i + 2));//2 rows are deleted: the column row and the row containing an error.
					System.debug('File data is not correct at line ' + (i + 2));
					
					returnMessage.isSuccess = true;
					returnMessage.title = 'Warning';
					returnMessage.severity = 'warning';
					returnMessage.contentMsg = 'Attenzione: Per alcune righe della lista non risultano valorizzati campiobligatori';	
					System.debug('Attenzione: Per alcune righe della lista non risultano valorizzati campiobligatori');				
				}
			}
			return returnMessage;
		} catch(Exception e) {
			System.debug('readCSVfile Method --> Error reading CSV file Message: ' + e.getMessage());
			System.debug('readCSVfile Method --> Error reading CSV file Cause: ' + e.getCause());
			System.debug('readCSVfile Method --> Error reading CSV file LineNumber: ' + e.getLineNumber());
			
			returnMessage.isSuccess = false;
			returnMessage.title = 'Error';
			returnMessage.severity = 'error';
			returnMessage.contentMsg = 'Attenzione: il file caricato non rispetta gli standard di formattazione4';
			System.debug('Attenzione: il file caricato non rispetta gli standard di formattazione4');				
			return returnMessage;
		}
	}

	/************************************************************
     Name:      AuraProcessingMessage
     Type:      Wrapper  Class  
     Purpose:   Wrapper  Class to hold error and success 
                message to  display in  lightning component 
    ***********************************************************/
	public class AuraProcessingMessage {

		@AuraEnabled public Boolean isSuccess;
		@AuraEnabled public String contentMsg; 
		@AuraEnabled public String severity;
		@AuraEnabled public String title; 

		public AuraProcessingMessage() {
			isSuccess = true;
			contentMsg = '';
			severity = '';
			title = '';
		}
	}
}