global class CervedEreimuResponse extends APIXMLResponse {
	
	@AuraEnabled public S2xResponse s2xResponse {get;set;}
	
	public CervedEreimuResponse() {
		this.s2xResponse = new S2xResponse();
	}
	
	public override Set<String> getTagNamesAsArray() {
        Set<String> tagNamesAsArray = new Set<String>();
        tagNamesAsArray.add('GeneralCompanyDetails');
        tagNamesAsArray.add('SpecialSections');
        return tagNamesAsArray;
    }

	global class GeneralCompanyDetails implements Comparable {
		@AuraEnabled public String CoCProvinceAcronym {get;set;} 
		@AuraEnabled public String FullNameOfProvince {get;set;} 
		@AuraEnabled public String REA {get;set;} 
		@AuraEnabled public String CompanyName {get;set;} 
		@AuraEnabled public String HQProvinceAcronym {get;set;} 
		@AuraEnabled public String HQFullNameOfProvince {get;set;} 
		@AuraEnabled public String CompanyTaxCodeNo {get;set;} 
		@AuraEnabled public String LegalEntityType {get;set;} 
		@AuraEnabled public String DescriptionOfLegalEntityType {get;set;} 
		@AuraEnabled public String PositionOriginCode {get;set;} 
		@AuraEnabled public String ISTATCodeMunicipality {get;set;} 
		@AuraEnabled public String FullNameOfMunicipality {get;set;} 
		@AuraEnabled public String BusinessStatus {get;set;} 
		@AuraEnabled public String DescriptionOfBusinessStatus {get;set;} 
		@AuraEnabled public String FlagOfInclusionInSpecialFarmersSection {get;set;} 
		@AuraEnabled public String FlagOfPresenceInSpecialSections {get;set;} 
		@AuraEnabled public String VATRegistrationNo {get;set;} 
		@AuraEnabled public String REARegistrationDate {get;set;} 
		@AuraEnabled public OtherCompanyInformation OtherCompanyInformation {get;set;} 
		@AuraEnabled public SpecialSections[] SpecialSections {get;set;} 
		@AuraEnabled public String CompanyRegisterNo {get;set;} 
		@AuraEnabled public TransferInformation TransferInformation {get;set;} 

		public GeneralCompanyDetails() {
			this.OtherCompanyInformation = new OtherCompanyInformation();
			this.SpecialSections = new List<SpecialSections>();
			this.TransferInformation = new TransferInformation();
		}

		// Implement the compareTo() method
		global Integer compareTo(Object compareTo) {
			GeneralCompanyDetails compareToGCD  = (GeneralCompanyDetails)compareTo;
			if (Integer.valueOf(REARegistrationDate) == Integer.valueOf(compareToGCD.REARegistrationDate)) 
				return 0;
			if (Integer.valueOf(REARegistrationDate) < Integer.valueOf(compareToGCD.REARegistrationDate)) 
				return 1;
			return -1;
		}
	}
	
	public class S2xStatus {
		@AuraEnabled public String Reload {get;set;} 
		@AuraEnabled public String s2xRetCode {get;set;} 
		@AuraEnabled public String s2xDescription {get;set;} 
		@AuraEnabled public String s2xRequestId {get;set;} 
		@AuraEnabled public String s2xTime {get;set;} 
	}
	
	public class TransferInformation {
		@AuraEnabled public String Code {get;set;} 
		@AuraEnabled public String ProvinceCode {get;set;} 
		@AuraEnabled public String REAProvinceCode {get;set;} 
	}
	
	public class ResultsReport {
		@AuraEnabled public Integer NumberOfRecordsExtractedFromDatabank {get;set;} 
		@AuraEnabled public Integer NumberOfElementsFilteredByHQFilter {get;set;} 
		@AuraEnabled public Integer NumberOfElementsFilteredByStatusFilter {get;set;} 
		@AuraEnabled public Integer NumberOfElementsFilteredByNameFilter {get;set;} 
		@AuraEnabled public Integer NumberOfElementsFilteredByMunicipalityFilter {get;set;} 
	}
	
	public class SpecialSections {
		@AuraEnabled public String Code {get;set;} 
		@AuraEnabled public String Description {get;set;} 
	}
	
	public class S2xParamDef {
		@AuraEnabled public String Param_1 {get;set;} 
		@AuraEnabled public String Param_2 {get;set;} 
		@AuraEnabled public String Param_7 {get;set;} 
	}
	
	public class S2xData {
		@AuraEnabled public List<GeneralCompanyDetails> GeneralCompanyDetails {get;set;} 
		@AuraEnabled public ResultsReport ResultsReport {get;set;} 
		@AuraEnabled public DoubleSearchIndicator DoubleSearchIndicator {get;set;} 

		public S2xData() {
			this.GeneralCompanyDetails = new List<GeneralCompanyDetails>();
			this.ResultsReport = new ResultsReport();
			this.DoubleSearchIndicator = new DoubleSearchIndicator();
		}
	}
	
	public class S2xAccount {
		@AuraEnabled public String s2xPrice {get;set;} 
		@AuraEnabled public String s2xBalanceRemaining {get;set;} 
		@AuraEnabled public String s2xProductCode {get;set;} 
		@AuraEnabled public String s2xUnitsOfMeasurement {get;set;} 
		@AuraEnabled public String s2xQuantity {get;set;} 
		@AuraEnabled public String s2xSearchResult {get;set;} 
		@AuraEnabled public String s2xOperationType {get;set;} 
	}
	
	public class S2xInfo {
		@AuraEnabled public S2xAccount s2xAccount {get;set;} 
		@AuraEnabled public S2xRequest s2xRequest {get;set;} 

		public S2xInfo() {
			this.s2xAccount = new S2xAccount();
			this.s2xRequest = new S2xRequest();
		}
	}
	
	public class S2xOptionDef {
		@AuraEnabled public String DIV {get;set;} 
		@AuraEnabled public String TYPE {get;set;}
		@AuraEnabled public String OUTPUT {get;set;} 
	}
	
	public class S2xRequest {
		@AuraEnabled public String s2xServiceName {get;set;} 
		@AuraEnabled public String s2xParams {get;set;} 
		@AuraEnabled public String s2xReturn {get;set;} 
		@AuraEnabled public S2xParamDef s2xParamDef {get;set;} 
		@AuraEnabled public S2xOptionDef s2xOptionDef {get;set;} 

		public S2xRequest() {
			this.s2xParamDef = new S2xParamDef();
			this.s2xOptionDef = new S2xOptionDef();
		}
	}
	
	public class S2xResponse {
		@AuraEnabled public S2xStatus s2xStatus {get;set;} 
		@AuraEnabled public S2xData s2xData {get;set;} 
		@AuraEnabled public S2xInfo s2xInfo {get;set;} 

		public S2xResponse() {
			this.s2xStatus = new S2xStatus();
			this.s2xData = new S2xData();
			this.s2xInfo = new S2xInfo();
		}
	}
	
	public class DoubleSearchIndicator {
		@AuraEnabled public String Value {get;set;} 
	}
	
	public class OtherCompanyInformation {
		@AuraEnabled public String FirstTwoCharactersOfBusinessCode {get;set;} 
		@AuraEnabled public String DescriptionOfCATECOA {get;set;} 
		@AuraEnabled public String ToponymCode {get;set;} 
		@AuraEnabled public String Address {get;set;} 
		@AuraEnabled public String StreetNumber {get;set;} 
		@AuraEnabled public String Municipality {get;set;} 
		@AuraEnabled public String MainActivityCode {get;set;} 
		@AuraEnabled public String MainActivityCodeDescription {get;set;}
	}
}