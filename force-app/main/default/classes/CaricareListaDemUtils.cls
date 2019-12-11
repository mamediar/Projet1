/**
 * @File Name          : CaricareListaDemUtils.cls
 * @Description        : 
 * @Author             : CISSE Ahmet
 * @Group              : 
 * @Last Modified By   : CISSE Ahmet
 * @Last Modified On   : 12/07/2019 à 15:24:02
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *============================================================================== 
 * 1.0    26/06/2019 à 08:30:14   CISSE Ahmet     Initial Version
**/

public class CaricareListaDemUtils {

	//This method checks whether the time between ultimaDEMinserita and currently is greater than 6 hours or not. It's  called in execute Method.
	public static Boolean isTheWaitingTimeExceeded(DateTime ultimaDEMinserita) {
		Long dt1Long = ultimaDEMinserita.getTime();
		Long dt2Long = DateTime.now().getTime();
		Long milliseconds = dt2Long - dt1Long;
		Long seconds = milliseconds / 1000;
		Long minutes = seconds / 60;
		Long hours = minutes / 60;
		if (hours >= 6) return true;
		else return false;
	}

	//This metode will be called in saveData for inserting an accountRichiesteDEM after checking the conditions
	public static AccountRichiesteDEM__c addAccountRichiesteDEM(Id accountId, Record2Object record2Object) {

		AccountRichiesteDEM__c accountRichiesteDEM = new AccountRichiesteDEM__c();

		accountRichiesteDEM.Account__c = accountId;
		accountRichiesteDEM.DEM_Value__c = record2Object.nameOfCampagne;
		accountRichiesteDEM.DEM_Param_1__c = record2Object.dEMParam1;
		accountRichiesteDEM.DEM_Param_2__c = record2Object.dEMParam2;
		accountRichiesteDEM.DEM_Param_3__c = record2Object.dEMParam3;
		accountRichiesteDEM.DEM_Param_4__c = record2Object.dEMParam4;
		accountRichiesteDEM.DEM_Param_5__c = record2Object.dEMParam5;

		accountRichiesteDEM.DEM_Data_invio__c = Date.valueOf(record2Object.dEMDatainvio.trim());

		return accountRichiesteDEM;
	}

	//This metode will be called in saveData for updating a contact after checking the conditions
	public static Contact addRelatedContact(Id idContact, Record2Object record2Object) {

		Contact con = new Contact();

		con.Id = idContact;
		con.DEM_Param_1_del__c = record2Object.dEMParam1;
		con.DEM_Param_2__c = record2Object.dEMParam2;
		con.DEM_Param_3__c = record2Object.dEMParam3;
		con.DEM_Param_4__c = record2Object.dEMParam4;
		con.DEM_Param_5__c = record2Object.dEMParam5;
		con.DEM_Value__c = record2Object.nameOfCampagne;

		//Reset ultimaDEMinserita
		con.Ultima_DEM_Inserita__c = Datetime.now();
		con.DEM_Da_Inviare__c = true;

		return con;
	}

	/**
* Split a string of any size, while avoiding the dreaded 'Regex too complicated'
* error, which the String.split(String) method causes on some large inputs.
*
* Note that this method does not avoid other errors, such as those related to 
* excess heap size or CPU time.
*/
	public static List < String > safeSplit(String inStr, String delim) {
		Integer regexFindLimit = 100;
		Integer regexFindCount = 0;

		List < String > output = new List < String > ();

		Matcher m = Pattern.compile(delim).matcher(inStr);

		Integer lastEnd = 0;

		while (!m.hitEnd()) {
			while (regexFindCount < regexFindLimit && !m.hitEnd()) {
				if (m.find()) {
					output.add(inStr.substring(lastEnd, m.start()));
					lastEnd = m.end();
				}
				else {
					output.add(inStr.substring(lastEnd));
					lastEnd = inStr.length();
				}

				regexFindCount++;
			}

			// Note: Using region() to advance instead of substring() saves 
			// drastically on heap size. Nonetheless, we still must reset the 
			// (unmodified) input sequence to avoid a 'Regex too complicated' 
			// error.
			m.reset(inStr);
			m.region(lastEnd, m.regionEnd());

			regexFindCount = 0;
		}

		return output;
	}

	public class Record2Object {

		public String codiceCliente;
		public String dEMParam1;
		public String dEMParam2;
		public String dEMParam3;
		public String dEMParam4;
		public String dEMParam5;
		public String dEMDatainvio;
		public String nameOfCampagne;

		public Record2Object() {}

		public void putAvalue(String fieldName, String fieldValue) {
			if (fieldName == 'codiceCliente') {
				this.codiceCliente = fieldValue;
			} else if (fieldName == 'dEMParam1') {
				this.dEMParam1 = fieldValue;
			} else if (fieldName == 'dEMParam2') {
				this.dEMParam2 = fieldValue;
			} else if (fieldName == 'dEMParam3') {
				this.dEMParam3 = fieldValue;
			} else if (fieldName == 'dEMParam4') {
				this.dEMParam4 = fieldValue;
			} else if (fieldName == 'dEMParam5') {
				this.dEMParam5 = fieldValue;
			} else if (fieldName == 'dEMDatainvio') {
				this.dEMDatainvio = fieldValue;
			} else if (fieldName == 'nameOfCampagne') {
				this.nameOfCampagne = fieldValue;
			} else {

}
		}
	}

	public class Record2ObjectFromClientiCSV {

		public String codiceCliente;
		public String dEMParam1;
		public String dEMParam2;
		public String dEMParam3;
		public String dEMParam4;
		public String dEMParam5;
		public String dEMDatainvio;
		public String nameOfCampagne;

		public Record2ObjectFromClientiCSV() {}

		public void putAvalue(String fieldName, String fieldValue) {
			if (fieldName == 'codiceCliente') {
				this.codiceCliente = fieldValue;
			} else if (fieldName == 'dEMParam1') {
				this.dEMParam1 = fieldValue;
			} else if (fieldName == 'dEMParam2') {
				this.dEMParam2 = fieldValue;
			} else if (fieldName == 'dEMParam3') {
				this.dEMParam3 = fieldValue;
			} else if (fieldName == 'dEMParam4') {
				this.dEMParam4 = fieldValue;
			} else if (fieldName == 'dEMParam5') {
				this.dEMParam5 = fieldValue;
			} else if (fieldName == 'dEMDatainvio') {
				this.dEMDatainvio = fieldValue;
			} else if (fieldName == 'nameOfCampagne') {
				this.nameOfCampagne = fieldValue;
			} else {

}
		}
	}

}