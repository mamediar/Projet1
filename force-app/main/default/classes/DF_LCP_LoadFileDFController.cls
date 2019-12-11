/**
 * @File Name          : DF_LCP_LoadFileDFController.cls
 * @Description        : This class is used to process the CSV file loaded by the component. 
 						 Processing consists of inserting the CSV data into the Case and Dossier__c objects once the required conditions are met.
						 A CSV file containing the lines processed successfully and those with error is created and sent by email.
 * @Author             : CISSE Ahmet
 * @Group              : 
 * @Last Modified By   : CISSE Ahmet
 * @Last Modified On   : 08/08/2019 à 10:00:45
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    31/07/2019 à 16:31:53   CISSE Ahmet     Initial Version
**/
public class DF_LCP_LoadFileDFController {

	public static Map < String, Object > response = new Map < String, Object > ();

	@AuraEnabled
	public static Map < String, Object > saveInDossierAndAccount(List < String > data, List < String > codiceOcsInCSVfile, List < String > linesWithErrors) {

		List < Dossier__c > dossiersListToInsert = new List < Dossier__c > ();
		List < Case > caseListToInsert = new List < Case > ();
		List < Account > accounts = new List < Account > ();
		string header = 'tipo_conv;    ocs_code;    name;    piva;    codice_fiscale;    branch;    data_attivazione;    nota; success  \n';
		string finalstr = header;

		System.debug('data>>: ' + data);
		response.put('error', false);

		// Save the dataBase
        SavePoint sp = Database.setSavePoint();

		if (!Dossier__c.sObjectType.getDescribe().IsCreateable() || !Case.sObjectType.getDescribe().IsCreateable()) {
			throw new AuraHandledException('Non hai accesso');
		} else {
			try {
				Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
				Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SFA Convenzionamento').getRecordTypeId();

				XCS_Categoria__c categoria = [SELECT id, Name FROM XCS_Categoria__c where name = 'Gestione Dossier Convenzionamento' limit 1];

				accounts = [SELECT id, Name, getCodice_Cliente__c, RecordTypeId FROM Account
								where
									RecordTypeId = :accountRecordTypeId
									And getCodice_Cliente__c IN: codiceOcsInCSVfile];
				
				for (Integer j = 0; j < data.size(); j++) {
					string[] csvRecordData = data[j].split(';');
					Boolean exist = false;
					for (Integer i = 0; i < accounts.size(); i++) {
						if (accounts[i].getCodice_Cliente__c.trim() == csvRecordData.get(1).trim()) {
							exist = true;				
							// Create a case and link it to dossier__c
                            Case casex = new Case();
							casex.Status = 'Chiuso';
							casex.RecordTypeId = caseRecordTypeId;
							casex.Categoria_Riferimento__c = categoria.Id;
							casex.AccountId = accounts[i].Id;
                            casex.Subject = 'Dossier Management';
                            casex.Disposition__c = 'Dossier – Approvato ';
							insert casex;

							// a dossier to insert
							Dossier__c dossier = new Dossier__c();
							dossier.Tipo__c = 'Dossier Fittizio';
							dossier.Name = csvRecordData.get(2).trim();
							dossier.DataRiferimento__c = date.valueOf(csvRecordData.get(6).trim());
							dossier.Note__c = csvRecordData.get(7).trim();
							dossier.IdAttivita__c = casex.Id;
							dossiersListToInsert.add(dossier);
						}
					}
					if (!exist) {
						linesWithErrors.add(data[j]);
						data.remove(j);
					}
				}
				
				 // insert caseListToInsert;
				if (dossiersListToInsert.size() > 0) {				  
					insert dossiersListToInsert;
				}
				//<<< Create CSV Report
				for (String linex: data) {
					String successLine = linex + '; true  \n';
					finalstr = finalstr + successLine;
				}
				for (String linex: linesWithErrors) {
					String errorLine = linex + '; false  \n';
					finalstr = finalstr + errorLine;
				}
				createCSVfile(finalstr);

				response.put('lineError', linesWithErrors.size());
				response.put('lineSuccess', data.size());
				
				System.debug('accounts List: ' + accounts.size());
				System.debug('dossiersListToInsert List: ' + dossiersListToInsert.size());
				System.debug('data:'+ data);
				System.debug('codiceOcsInCSVfile: '+codiceOcsInCSVfile);
				System.debug('accounts: '+accounts.size());

			} catch(Exception e) {
				// Rollback
                Database.rollback(sp);

				response.put('error', true);
				response.put('message', e.getMessage());
				response.put('lineError', linesWithErrors.size());
				response.put('lineSuccess', data.size());
				System.debug('cause: '+ e.getCause());
				System.debug('Line N°: '+ e.getLineNumber());
				System.debug('message debug: ' + e.getMessage());
				System.debug('Cause debug: ' + e.getCause());
				System.debug('Line N°: '+ e.getLineNumber());
			}
			return response;
		}
	}

	public static void createCSVfile(String finalstr) {
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
			};//UserInfo.getUserEmail()
			String subject = 'Results Of Importation data  in CSV File';
			email.setSubject(subject);
			email.setToAddresses(toAddresses);
			email.setPlainTextBody('Results Of Importation data  in CSV File ');
			email.setFileAttachments(new Messaging.EmailFileAttachment[] {
				csvAttc
			});
			Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
				email
			});
		} catch(Exception e) {
			System.debug('createCSVfile Method --> Error creating CSV file: ' + e.getMessage());
			//Adding the error message if an exception is occured
			System.debug('error creating CSV: '+ true);
			System.debug('message creating CSV: '+ e.getMessage());
			System.debug('cause creating CSV: '+ e.getCause());
			System.debug('Line N° creating CSV: '+ e.getLineNumber());
		}
	}
}