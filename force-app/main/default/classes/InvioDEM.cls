/**
 * @File Name          : InvioDEM.cls
 * @Description        : 
 * @Author             : CISSE Ahmet
 * @Group              : 
 * @Last Modified By   : CISSE Ahmet
 * @Last Modified On   : 26/06/2019 à 08:42:01
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    26/06/2019 à 08:25:47   CISSE Ahmet     Initial Version
**/

public class InvioDEM {
	/*This method searches for all accounts that are linked to the account whose ID is passed as a parameter.
   Then for each contact if DEM_Da_Inviare__c is equal to false, it modifies some fields of the contact with the data received in parameter before inserting a CampaignMember related to this Contact and the campaign passed in parameter and to update the contact.
   If DEM_Da_Inviare__c is equal to true, an AccountRichiesteDEM__c is inserted with the data passed in parameter and the contact is updated.*/
    
   public static void check(Id id, String DEM_Value , String demParam1, String demParam2, String demParam3, 
                             String demParam4, String demParam5, String demParam6 , String demParam7 , String demParam8 ,
                             String demParam9 , String demParam10 /*, Date dem_Data_invio*/) 
    {

		List < Contact > contacts = [ SELECT Id, DEM_Value__c, DEM_Da_Inviare__c, Ultima_DEM_Inserita__c, DEM_Param_1_del__c, 
                                            DEM_Param_2__c, DEM_Param_3__c, DEM_Param_4__c, DEM_Param_5__c, DEM_Param_6__c ,
                                            DEM_Param_7__c , DEM_Param_8__c , DEM_Param_9__c , DEM_Param_10__c , 
                                            AccountId,contact.Name 
                                      FROM Contact 
                                      WHERE AccountId = :id];
        
		System.debug('contacts**' + contacts);
		if( contacts != null && contacts.size()>0 ) 
        {
            //Condition on Contact with DEM_Da_Inviare__c == false
            if( contacts[0].DEM_Da_Inviare__c == false ) 
            {
                
                      updateRelatedContact( contacts[0].Id, DEM_Value, demParam1, demParam2, 
                                            demParam3, demParam4, demParam5 , 
                                            demParam6 , demParam7 , demParam8 , demParam9 , 
                                            demParam10 , true );

            //Condition on Contact with DEM_Da_Inviare__c == true
            }else if( contacts[0].DEM_Da_Inviare__c == true )
            {
                //Check Ultima Dem Inserita
                if( contacts[0].Ultima_DEM_Inserita__c != null && CaricareListaDemUtils.isTheWaitingTimeExceeded(contacts[0].Ultima_DEM_Inserita__c) == true )
                {
                    
                       updateRelatedContact( contacts[0].Id, DEM_Value, demParam1, demParam2, 
                                             demParam3, demParam4, demParam5, 
                                             demParam6 , demParam7 , demParam8 , demParam9 , 
                                             demParam10 , true );

                }else if( contacts[0].Ultima_DEM_Inserita__c != null && CaricareListaDemUtils.isTheWaitingTimeExceeded(contacts[0].Ultima_DEM_Inserita__c) == false )
                {
                      try{
					  
                          insertaccountRichiesteDEM(id, DEM_Value, demParam1, demParam2, demParam3, demParam4, demParam5 , 
                                                    demParam6 , demParam7 , demParam8 , demParam9 , 
                                            demParam10/*, dem_Data_invio*/);
				      }catch( System.DmlException e )
                      {
					      for( Integer i = 0 ; i < e.getNumDml() ; i++ )
                          {
						       System.debug(e.getDmlMessage(i));
					      }
				      }
                }                
                
            }
            
		}
		
	}

	//This metode will be called in saveData for inserting an accountRichiesteDEM after checking the conditions
	public static void insertaccountRichiesteDEM(Id accountId, String nameOfCampaign, String demParam1, String demParam2, 
                                                  String demParam3, String demParam4, String demParam5 , String demParam6 , 
                                                 String demParam7 , String demParam8 , String demParam9 , String demParam10/*, Date dem_Data_invio*/) {

		AccountRichiesteDEM__c accountRichiesteDEM = new AccountRichiesteDEM__c();

		accountRichiesteDEM.Account__c = accountId;
		accountRichiesteDEM.DEM_Value__c = nameOfCampaign;
		accountRichiesteDEM.DEM_Param_1__c = demParam1;
		accountRichiesteDEM.DEM_Param_2__c = demParam2;
		accountRichiesteDEM.DEM_Param_3__c = demParam3;
		accountRichiesteDEM.DEM_Param_4__c = demParam4;
		accountRichiesteDEM.DEM_Param_5__c = demParam5;
        accountRichiesteDEM.DEM_Param_6__c = demParam6;
		accountRichiesteDEM.DEM_Param_7__c = demParam7;
		accountRichiesteDEM.DEM_Param_8__c = demParam8;
		accountRichiesteDEM.DEM_Param_9__c = demParam9;
		accountRichiesteDEM.DEM_Param_10__c = demParam10;


		//accountRichiesteDEM.DEM_Data_invio__c = dem_Data_invio;

		insert accountRichiesteDEM;
	}

	//This metode will be called in saveData for updating a contact after checking the conditions
	public static void updateRelatedContact( Id idContact, String DEM_Value, String demParam1, String demParam2,
                                             String demParam3, String demParam4, String demParam5, String demParam6,
                                             String demParam7, String demParam8,String demParam9 , String demParam10 , 
                                             boolean DEMDaInviare )
                                                                                                  /*, Date dem_Data_invio*/
    {
		Contact con = new Contact();

		con.Id = idContact;
		con.DEM_Param_1_del__c = demParam1;
		con.DEM_Param_2__c = demParam2;
		con.DEM_Param_3__c = demParam3;
		con.DEM_Param_4__c = demParam4;
		con.DEM_Param_5__c = demParam5;
   		con.DEM_Param_6__c = demParam6;
		con.DEM_Param_7__c = demParam7;
		con.DEM_Param_8__c = demParam8;
		con.DEM_Param_9__c = demParam9;
		con.DEM_Param_10__c = demParam10;

		con.DEM_Value__c = DEM_Value;

		//Reset ultimaDEMinserita
		con.Ultima_DEM_Inserita__c = DateTime.now();
		con.DEM_Da_Inviare__c = DEMDaInviare;

		UPDATE con;
	}


	public static void check(Id id, String DEM_Value , String demParam1, String demParam2, String demParam3, 
                             String demParam4, String demParam5, Date dem_Data_invio)
    {}

}