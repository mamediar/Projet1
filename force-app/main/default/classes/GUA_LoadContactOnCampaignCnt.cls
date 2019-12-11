//----------------------------------------------------------------------
//-- - Author       : Aminata GUEYE
//-- - Date         : 22/09/2019
//-- - Class  : GUA_LoadContactOnCampaignCnt
//----------------------------------------------------------------------
public with sharing class GUA_LoadContactOnCampaignCnt {
    public static string myDate{get;set;}
    public static String[] csvRecordData = new String[]{};
    public  static   Map<String, Object> dataAccount = new Map<String, Object>();
/**
* @description:Insert List Case
* @date:17/09/2019
* @author: Aminata GUEYE 
* @Modify by: Sana BADJI | Date: 30/09/19
* @params: data | List<String>
* @return: List<Case> 
*/
    @AuraEnabled
    public static  List<Case>  saveFile(List<String> data ,String campaignId){
        System.debug('List data ' +data);
        System.debug('size data ' +data.size());
        System.debug('campaignId ' +campaignId);
        if( data.size()==0 && campaignId==null){
        System.debug('campaignId is :' +campaignId);
        System.debug('list data is empty :' +campaignId);
        }
         List<Case> listCaseToinsert = new List<Case>();
        try{
			for(Integer j = 0; j < data.size(); j++) {
                Case c = new Case();
                csvRecordData = data[j].split(';');
                System.debug('csvRecordData size ' +csvRecordData.size());
                System.debug('csvRecordData  ' +csvRecordData);
                System.debug('csvRecordData[j] ' +csvRecordData[j]);
                System.debug('NumeroPratica ' +csvRecordData[0]);
                System.debug('Stato_Pratica ' +csvRecordData[1]);
                System.debug('Priority ' +csvRecordData[2]);
                System.debug('Scadenza__c ' +csvRecordData[3]);
                System.debug('Anomalia_num_2 ' +csvRecordData[24]);
                System.debug('Anomalia_num_3 ' +csvRecordData[25]);
                System.debug('Anomalia_num_5 ' +csvRecordData[26]);
                myDate =csvRecordData[3];
                 Date dateScadenza= GUA_LoadContactOnCampaignCnt.setStringToDateFormat(myDate);
                System.debug('Date parse Scadenza ' +dateScadenza);
                System.debug('Note ' +csvRecordData[23]);
                System.debug('CodiceDealer ' +csvRecordData[15]);
                
                 GUA_CSVparsingJSON jsonCsv = 
                new GUA_CSVparsingJSON (csvRecordData[4],
                csvRecordData[5],csvRecordData[6], 
                csvRecordData[7],csvRecordData[8],
                csvRecordData[9],csvRecordData[10],
                csvRecordData[11],csvRecordData[12],
                csvRecordData[13],csvRecordData[14],
                csvRecordData[16],csvRecordData[17],
                csvRecordData[18],csvRecordData[19],
                csvRecordData[20],csvRecordData[21],
                csvRecordData[22],csvRecordData[24],
                csvRecordData[25],csvRecordData[26], 
                csvRecordData[27]);
                String caseJSON = JSON.serialize(jsonCsv,true);
                System.debug('caseJSON' +caseJSON);    
                GUA_CSVparsingJSON mainJSONWrapper = (GUA_CSVparsingJSON) JSON.deserialize(caseJSON,GUA_CSVparsingJSON.class);
                System.debug('mainJSONWrapper' +mainJSONWrapper);
                String codiceDealer=csvRecordData[15];
                String cognome= csvRecordData[4];
                String nome =csvRecordData[5];
                String name=cognome+' '+nome;
                Account account=createAccount(codiceDealer);
                Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
                accountMap.put(account, null);
                XCSGestioneAnagraficaDealer.execute(accountMap, true);
                DealerAccount dealerAcc = accountMap.get(account);
                Account accOut1 = dealerAcc.account;
                System.debug('********************** accountMap '+accountMap);
                System.debug('********************** account '+account);
                System.debug('******************* dealerAcc ***************** '+dealerAcc.account); 
                System.debug('******************* accOut1 ***************** '+accOut1.Id); 
                Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
                c.RecordTypeId=recordType;
                c.NumeroPratica__c = csvRecordData[0]; 
                c.Stato_Pratica__c =csvRecordData[1] ;
                c.Priority = csvRecordData[2];
                c.Scadenza__c =  dateScadenza;
                c.CodiceDealer__c =csvRecordData[15] ;
                c.Note__c = csvRecordData[23];
                c.UAF_DatiAggiuntiviFile__c =caseJSON;
                c.CampaignId__c =campaignId;
                c.AccountId=accOut1.Id;
                listCaseToinsert.add(c);
                System.debug('listCaseToinsert  size ' +listCaseToinsert.size());
				}
                 // insert caseListToInsert;
				if (listCaseToinsert.size() > 0) {				  
					upsert listCaseToinsert;
                    System.debug('listCaseToinsert insert suucessfully' +listCaseToinsert.size());
				}
            }
            catch(Exception e){
            System.debug('Error insert Case' +listCaseToinsert);
            System.debug('cause: '+ e.getCause());
				System.debug('Line N°: '+ e.getLineNumber());
				System.debug('message debug: ' + e.getMessage());
				System.debug('Cause debug: ' + e.getCause());
				System.debug('Line N°: '+ e.getLineNumber());

            }    
        return  listCaseToinsert;  
    }
/**
* @description:Format String Date to type Date
* @date:30/09/19
* @author: Sana BADJI 
* @params: myDate | String
* @return: Date
*/
    
     @AuraEnabled
    public static Date setStringToDateFormat(String myDate) {
        String[] myDateOnly = myDate.split(' ');
        String[] strDate = myDateOnly[0].split('/');
        Integer myIntDate = integer.valueOf(strDate[1]);
        Integer myIntMonth = integer.valueOf(strDate[0]);
        Integer myIntYear = integer.valueOf(strDate[2]);
        Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        return d;
    }
    
/**
* @description:Mrthod Create Account 
* @date:08/10/19
* @author: Sana BADJI 
* @params: codiceDealer | String
* @return: Account
*/
    public static Account createAccount(String codiceDealer){
            /******************************** Create Account Object **************************** */
            Integer randomNumber = Integer.valueof((30 * Math.random()+1));
            System.debug('randomNumber is'+randomNumber);
            Account account = new Account(
                OCS_External_Id__c=codiceDealer,
                OCSAreaId__c=randomNumber
            );
            return account;

    } 
}