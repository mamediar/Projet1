/**
 * @File Name          : CaricareListaDEmBatch.cls
 * @Description        : 
 * @Author             : CISSE Ahmet
 * @Group              : 
 * @Last Modified By   : CISSE Ahmet
 * @Last Modified On   : 12/07/2019 à 22:16:53
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    08/07/2019 à 15:56:33   CISSE Ahmet     Initial Version
**/
global class CaricareListaDEmBatch implements Database.Batchable <String> , Database.Stateful {

	global String fileContent ;
    global List < String > listOfIterableRecords = new List < String > ();
	global Set < String > codiceClienteInCSVfile = new Set < String > ();
	global string header = 'AccontId , State , Message  \n';
	global string finalstr = header;
    global Map < String,
		Integer > fieldNumberMap = new Map < String,
		Integer > ();
    global List < String > lstFieldNames = new List < String > ();
    global List < String > csvFieldNames = new List < String > ();

	global CaricareListaDEmBatch(String fileContent) {
        listOfIterableRecords = CaricareListaDemUtils.safeSplit(fileContent, '\r\n');
        if (listOfIterableRecords.size()>0) {
            csvFieldNames = CaricareListaDemUtils.safeSplit(listOfIterableRecords[0], ';'); 
            listOfIterableRecords.remove(0);
        } 
	}

	global Iterable <String> start(Database.batchableContext bc) {
		return listOfIterableRecords;
	}

	global void execute(Database.batchableContext bc, List < String > scope) {
        System.debug('---scope---= ' + scope);
		List < CaricareListaDemUtils.Record2Object > lstRecord2Object = new List < CaricareListaDemUtils.Record2Object > ();
		if (scope.size() <= 0) {
			//The file is empty.
			System.debug('CaricareListaDEmBatch.exxecute --> The file is empty');
		}
		else {			
			//The file is not empty.
            System.debug('The file is not empty.');
            System.debug('---convertRecordToObject(scope)---= ' + convertRecordToObject(scope));
			lstRecord2Object = convertRecordToObject(scope);
		}
		if (lstRecord2Object != null && lstRecord2Object.size() > 1) {
			//Save Data From CSV File to Org            
            System.debug('---lstRecord2Object---= ' + lstRecord2Object);
			saveData(lstRecord2Object);
		}
	}

	global void finish(Database.batchableContext bc) {
        System.debug('CaricareListaDEmBatch.finish --> ');
		AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
		FROM AsyncApexJob
		WHERE Id = :bc.getJobId()];
		//Send a Mail
		createCSVfileForTheReport(job);
	}

	List < CaricareListaDemUtils.Record2Object > convertRecordToObject(List < String > records) {

		List < CaricareListaDemUtils.Record2Object > lstRecord2Object = new List < CaricareListaDemUtils.Record2Object > ();       		
		String fieldValue;
		Integer fieldNumber;
		CaricareListaDemUtils.Record2Object record2Object;
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
				if (csvFieldNames.size() == 8 && csvRecordData.size() == csvFieldNames.size() && csvRecordData[0].trim() != '' && csvRecordData[6].trim() != '' && csvRecordData[7].trim() != '') {
					if (Date.today().daysBetween(Date.valueOf(csvRecordData[6].trim())) < 0) {
						lstRecord2Object.clear();
						System.debug('File data is not correct at line ' + (i + 1) + '.' + 'DEM_Data_invio__c is earlier than today.' + 'lstRecord2Object ' + lstRecord2Object.size());
						return null;
					} else {
						codiceClienteInCSVfile.add(csvRecordData[0].trim());
						System.debug('---Line---: ' + i);
						for (String fieldName: csvFieldNames) {
							fieldNumber = fieldNumberMap.get(fieldName);
							fieldValue = csvRecordData[fieldNumber];
							System.debug('---' + fieldName + '---= ' + fieldValue);
							record2Object.putAvalue(fieldName.trim(), fieldValue.trim());
						}
						lstRecord2Object.add(record2Object);
					}
				} else {
					lstRecord2Object.clear();
					System.debug('File data is not correct at line ' + (i + 1) + 'lstRecord2Object ' + lstRecord2Object.size());
					return null;
				}
			}
			return lstRecord2Object;
		} catch(Exception e) {
			System.debug('readCSVfile Method --> Error reading CSV file Message: ' + e.getMessage());
			System.debug('readCSVfile Method --> Error reading CSV file Cause: ' + e.getCause());
			System.debug('readCSVfile Method --> Error reading CSV file LineNumber: ' + e.getLineNumber());
			return null;
		}
	}

	void saveData(List < CaricareListaDemUtils.Record2Object > lstRecord2Object) {
		List < AccountRichiesteDEM__c > accountRichiesteDEMsToInsert = new List < AccountRichiesteDEM__c > ();
		List < Contact > contactsToUpdate = new List < Contact > ();
		//Save the Data Base
	//	SavePoint sp = Database.setSavePoint();
		try {
			//Retrieve contacts who have Id in the CSV file.
			List < Contact > recoveredContacts = [Select Id, DEM_Value__c, DEM_Da_Inviare__c, Ultima_DEM_Inserita__c, DEM_Param_1_del__c, DEM_Param_2__c, DEM_Param_3__c, DEM_Param_4__c, DEM_Param_5__c, Account.getCodice_Cliente__c From Contact where Account.getCodice_Cliente__c IN: codiceClienteInCSVfile];

			System.debug('--saveData Method--Number of CodiceCliente In SET:---= ' + codiceClienteInCSVfile.size());
			System.debug('--saveData Method--CodiceCliente In SET:---= ' + codiceClienteInCSVfile);
			System.debug('---saveData Method-->Number of Contacts to update:---= ' + recoveredContacts.size());
			System.debug('---saveData Method-->Number of Contacts for updating:---= ' + lstRecord2Object.size());
			//Update Contacts
			if (recoveredContacts.size() > 0 && lstRecord2Object.size() > 0) {
				for (Integer i = 0; i < recoveredContacts.size(); i++) {
					for (Integer j = 0; j < lstRecord2Object.size(); j++) {
						if (recoveredContacts[i].Account.getCodice_Cliente__c.trim() == lstRecord2Object[j].codiceCliente.trim()) {    //							
                            if (Date.today().daysBetween(Date.valueOf(lstRecord2Object[j].dEMDatainvio.trim())) > 0) {
								//Now we are sure that DEM_Data_invio__c > today.
								// In this case we save in AccountRichiesteDEMobject                                
								accountRichiesteDEMsToInsert.add(CaricareListaDemUtils.addAccountRichiesteDEM(recoveredContacts[i].AccountId, lstRecord2Object[j]));
								System.debug('---An accountRichiesteDEM is added :---= ' + CaricareListaDemUtils.addAccountRichiesteDEM(recoveredContacts[i].AccountId, lstRecord2Object[j]));
							} else if (Date.today().isSameDay(Date.valueOf(lstRecord2Object[j].dEMDatainvio.trim())) == true) {
								//Now we are sure that DEM_Data_invio__c = today.
								if (recoveredContacts[i].DEM_Da_Inviare__c == false) {
									// Update Contact
									contactsToUpdate.add(CaricareListaDemUtils.addRelatedContact(recoveredContacts[i].Id, lstRecord2Object[j]));
									System.debug('---this contact is updated :---= ' + recoveredContacts[i]);
								} else if (recoveredContacts[i].Ultima_DEM_Inserita__c != null && recoveredContacts[i].DEM_Da_Inviare__c == true && CaricareListaDemUtils.isTheWaitingTimeExceeded(recoveredContacts[i].Ultima_DEM_Inserita__c) == true) {
									// Update Contcat
									contactsToUpdate.add(CaricareListaDemUtils.addRelatedContact(recoveredContacts[i].Id, lstRecord2Object[j]));
									System.debug('---this contact is updated :---= ' + recoveredContacts[i]);
								} else if (recoveredContacts[i].Ultima_DEM_Inserita__c != null && recoveredContacts[i].DEM_Da_Inviare__c == true && CaricareListaDemUtils.isTheWaitingTimeExceeded(recoveredContacts[i].Ultima_DEM_Inserita__c) == false) {
									// In this case we use AccountRichiesteDEMobject
									accountRichiesteDEMsToInsert.add(CaricareListaDemUtils.addAccountRichiesteDEM(recoveredContacts[i].AccountId, lstRecord2Object[j]));
									System.debug('---An accountRichiesteDEM is added :---= ' + CaricareListaDemUtils.addAccountRichiesteDEM(recoveredContacts[i].AccountId, lstRecord2Object[j]));
								} else if (recoveredContacts[i].Ultima_DEM_Inserita__c == null && recoveredContacts[i].DEM_Da_Inviare__c == true) {
									// In this case we use AccountRichiesteDEMobject
									accountRichiesteDEMsToInsert.add(CaricareListaDemUtils.addAccountRichiesteDEM(recoveredContacts[i].AccountId, lstRecord2Object[j]));
									System.debug('---An accountRichiesteDEM is added :---= ' + CaricareListaDemUtils.addAccountRichiesteDEM(recoveredContacts[i].AccountId, lstRecord2Object[j]));
								}
							}
						}
					}
				}
				// insert accountRichiesteDEMlist to add and related contact to add.
				System.debug('---contactsToUpdate---= ' + contactsToUpdate.size());
				System.debug('---accountRichiesteDEMsToInsert---= ' + accountRichiesteDEMsToInsert.size());

				update contactsToUpdate;
				insert accountRichiesteDEMsToInsert;

				// Add new Lines in  CSV File generated	
				for (Contact con: contactsToUpdate) {
					string recordString = con.Id + ';' + 'Success' + ';' + 'The contact is updated successfully.' + '\n';
					finalstr = finalstr + recordString;
				}
				for (AccountRichiesteDEM__c acc: accountRichiesteDEMsToInsert) {
					string recordString = acc.Account__c + ';' + 'Success' + ';' + 'An accountRichiesteDEM is added successfully.' + '\n';
					finalstr = finalstr + recordString;
				}
			}
		} catch(Exception e) {
			System.debug('Error Saving Data From CSV file Message: ' + e.getMessage());
			System.debug('Error Saving Data From CSV file Cause: ' + e.getCause());
			System.debug('Error Saving Data From CSV file LineNumber: ' + e.getLineNumber());
			// Rollback
		//	Database.rollback(sp);
		}
	}

	void createCSVfileForTheReport(AsyncApexJob job) {
		try {
			blob csvBlob = Blob.valueOf(finalstr);
			System.debug('--- createCSVfile Method Content of CSV file Created ---: ' + csvBlob.toString());
			Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
			string csvname = 'Results.csv';
			csvAttc.setFileName(csvname);
			csvAttc.setBody(csvBlob);
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			String[] toAddresses = new list < string > {
				'ahmetdamecisse@gmail.com'
			};
			String subject = 'Results Of Importation data  in CSV File';
			email.setSubject(subject);
			email.setToAddresses(toAddresses);
			email.setPlainTextBody('Job Informations: ' + job);
			email.setFileAttachments(new Messaging.EmailFileAttachment[] {
				csvAttc
			});
			Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
				email
			});
		} catch(Exception e) {
			System.debug('createCSVfile Method --> Error creating CSV file: ' + e.getMessage());
		}
	}
}