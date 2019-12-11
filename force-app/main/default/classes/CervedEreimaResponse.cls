public class CervedEreimaResponse extends APIXMLResponse {
	
	@AuraEnabled public S2xResponse s2xResponse {get;set;}

	public CervedEreimaResponse() {
		this.s2xResponse = new S2xResponse();
	}
	
	public override Set<String> getTagNamesAsArray() {
        Set<String> tagNamesAsArray = new Set<String>();
        tagNamesAsArray.add('CompanyIdentification');
        return tagNamesAsArray;
    }

	public class InformationTransferts {
		@AuraEnabled public String REANo {get;set;} 
		@AuraEnabled public String CoCProvinceCode {get;set;} 
		@AuraEnabled public String CauseCode {get;set;} 
	}
	
	public class S2xStatus {
		@AuraEnabled public String s2xTime {get;set;} 
		@AuraEnabled public String s2xRequestId {get;set;} 
		@AuraEnabled public String s2xDescription {get;set;} 
		@AuraEnabled public String s2xRetCode {get;set;} 
	}
	
	public class ResearchIndicator {
		@AuraEnabled public ReportResults ReportResults {get;set;} 
		@AuraEnabled public List<CompanyIdentification> CompanyIdentification {get;set;} 
		@AuraEnabled public String Indicator {get;set;} 

		public ResearchIndicator() {
			this.ReportResults = new ReportResults();
			this.CompanyIdentification = new List<CompanyIdentification>();
		}
	}
	
	public class OtherInformationCompany {
		@AuraEnabled public String MainActivityCodeDescription {get;set;} 
		@AuraEnabled public String MainActivityCode {get;set;} 
		@AuraEnabled public String BirthMunicipality {get;set;} 
		@AuraEnabled public String StreetNo {get;set;} 
		@AuraEnabled public String Address {get;set;} 
		@AuraEnabled public String ToponymDescription {get;set;} 
		@AuraEnabled public String CATECOADescription {get;set;} 
		@AuraEnabled public String FirstTwoCharactersMainActivityCode {get;set;} 
	}
	
	public class SpecialSections {
		@AuraEnabled public String Code {get;set;} 
	}
	
	public class S2xParamDef {
		@AuraEnabled public String ParamFlagHeadOfficeFilter {get;set;} 
		@AuraEnabled public String ParamTaxCode {get;set;} 
		@AuraEnabled public String ParamTypeKey {get;set;} 
	}
	
	public class S2xData {
		@AuraEnabled public ResearchIndicator ResearchIndicator {get;set;} 

		public S2xData() {
			this.ResearchIndicator = new ResearchIndicator();
		}
	}
	
	public class S2xAccount {
		@AuraEnabled public String s2xOperationType {get;set;} 
		@AuraEnabled public String s2xSearchResult {get;set;} 
		@AuraEnabled public String s2xQuantity {get;set;} 
		@AuraEnabled public String s2xUnitsOfMeasurement {get;set;} 
		@AuraEnabled public String s2xProductCode {get;set;} 
		@AuraEnabled public String s2xBalanceRemaining {get;set;} 
		@AuraEnabled public String s2xPrice {get;set;} 
	}
	
	public class S2xInfo {
		@AuraEnabled public S2xRequest s2xRequest {get;set;} 
		@AuraEnabled public S2xAccount s2xAccount {get;set;} 

		public S2xInfo() {
			this.s2xRequest = new S2xRequest();
			this.s2xAccount = new S2xAccount();
		}
	}
	
	//public class ClosingCompanyInformation {
	//	public String Date {get;set;} 
	//}
	
	public class S2xOptionDef {
		@AuraEnabled public String OUTPUT {get;set;} 
		@AuraEnabled public String TYPE {get;set;}
		@AuraEnabled public String DIV {get;set;} 
	}
	
	public class S2xRequest {
		@AuraEnabled public S2xOptionDef s2xOptionDef {get;set;} 
		@AuraEnabled public S2xParamDef s2xParamDef {get;set;} 
		@AuraEnabled public String s2xReturn {get;set;} 
		@AuraEnabled public String s2xParams {get;set;} 
		@AuraEnabled public String s2xServiceName {get;set;} 

		public S2xRequest() {
			this.s2xOptionDef = new S2xOptionDef();
			this.s2xParamDef = new S2xParamDef();
		}
	}
	
	public class ReportResults {
		@AuraEnabled public Integer NumberFilteredItemsFromCityCouncil {get;set;} 
		@AuraEnabled public Integer NumberFilteredItemsFromCompanyName {get;set;} 
		@AuraEnabled public Integer NumberFilteredItemsFromStatus {get;set;} 
		@AuraEnabled public Integer NumberFilteredItemsFromHeadOffice {get;set;} 
		@AuraEnabled public Integer NumberRecordsExtractedFromDatabase {get;set;} 
	}
	
	public class S2xResponse {
		@AuraEnabled public S2xInfo s2xInfo {get;set;} 
		@AuraEnabled public S2xData s2xData {get;set;} 
		@AuraEnabled public S2xStatus s2xStatus {get;set;} 

		public S2xResponse() {
			this.s2xInfo = new S2xInfo();
			this.s2xData = new S2xData();
			this.s2xStatus = new S2xStatus();
		}
	}
	
	public class CompanyIdentification {
		@AuraEnabled public SpecialSections SpecialSections {get;set;} 
		//@AuraEnabled public ClosingCompanyInformation ClosingCompanyInformation {get;set;} 
		@AuraEnabled public OtherInformationCompany OtherInformationCompany {get;set;} 
		@AuraEnabled public String REARegistrationDate {get;set;} 
		@AuraEnabled public String VATRegistrationNoCompany {get;set;} 
		@AuraEnabled public String FlagPresenceRecord20 {get;set;} 
		@AuraEnabled public String FlagMemberGroupFarmer {get;set;} 
		@AuraEnabled public String BusinessStatus {get;set;} 
		@AuraEnabled public String ISTATMunicipalityCode {get;set;} 
		@AuraEnabled public String PreviousPositionCode {get;set;} 
		@AuraEnabled public String LegalFormCode {get;set;} 
		@AuraEnabled public String CompanyTaxCode {get;set;} 
		@AuraEnabled public String RegisteredHeadOfficeProvinceCode {get;set;} 
		@AuraEnabled public String Name {get;set;} 
		@AuraEnabled public String REANo {get;set;} 
		@AuraEnabled public String CoCProvinceCode {get;set;} 
		@AuraEnabled public InformationTransferts InformationTransferts {get;set;} 
		@AuraEnabled public String RegistrationNo {get;set;} 

		public CompanyIdentification() {
			this.SpecialSections = new SpecialSections();
			//this.ClosingCompanyInformation = new ClosingCompanyInformation();
			this.OtherInformationCompany = new OtherInformationCompany();
			this.InformationTransferts = new InformationTransferts();
		}
	}
	
}