public class QuickReportResponse {

	public S2xResponse s2xResponse {get;set;} 

	public QuickReportResponse() {
		this.s2xResponse = new S2xResponse();
	}
	
	public class S2xResponse {
		public S2xData s2xData {get;set;} 

		public S2xResponse() {
			this.s2xData = new s2xData();
		}
	}
	
	public class S2xData {
		public Shareholders Shareholders {get;set;} 
		public Representatives Representatives {get;set;} 
		public EconomicalActivity EconomicalActivity {get;set;} 
		public ProtestsAndPrejudicialEvents ProtestsAndPrejudicialEvents {get;set;} 
		public CharacteristicData CharacteristicData {get;set;} 
		public IdentifyingData IdentifyingData {get;set;} 
		public AssessmentSummary AssessmentSummary {get;set;} 
		public InfocomData InfocomData {get;set;} 

		public S2xData() {
			this.Shareholders = new Shareholders();
			this.Representatives = new Representatives();
			this.EconomicalActivity = new EconomicalActivity();
			this.ProtestsAndPrejudicialEvents = new ProtestsAndPrejudicialEvents();
			this.CharacteristicData = new CharacteristicData();
			this.IdentifyingData = new IdentifyingData();
			this.AssessmentSummary = new AssessmentSummary();
			this.InfocomData = new InfocomData();
		}
	}

	public class PrejudicialEvents {
		public String FlagAlarm {get;set;}
	}
	
	public class Ateco2007 {
		public String Code {get;set;} 
	}
	
	public class CompanyActivity {
		public Ateco2007List Ateco2007List {get;set;} 

		public CompanyActivity() {
			this.Ateco2007List = new Ateco2007List();
		}
	}
	
	public class InfocomData {
		public String DateOfUpdate {get;set;} 
	}
	
	public class IndividualList {
		public List<Individual> Individual {get;set;} 

		public IndividualList() {
			this.Individual = new List<Individual>();
		}
	}
	
	public class Address {
		public String Postcode {get;set;} 
		public String StreetNo {get;set;} 
		public String StreetName {get;set;} 
		public String ToponymCode {get;set;} 
		public String DescriptionCityIfNotISTAT {get;set;} 
		public String ISTATMunicipalityCode {get;set;} 
		public String ProvinceCode {get;set;} 
	}
	
	public class Representatives {
		public IndividualList IndividualList {get;set;} 

		public Representatives() {
			this.IndividualList = new IndividualList();
		}
	}
	
	public class EconomicalActivity {
		public String SAECode2007 {get;set;} 
		public String RAECode2007 {get;set;} 
		public CompanyActivity CompanyActivity {get;set;} 

		public EconomicalActivity() {
			this.CompanyActivity = new CompanyActivity();
		}
	}
	
	public class Birth {
		public String BirthDate {get;set;} 
		public String City {get;set;} 
		public String ISTATMunicipalityCode {get;set;} 
		public String BirthplaceProvinceCode {get;set;} 
	}
	
	public class AssessmentSummary {
		public String CervedGroupRating {get;set;} 
		public String Rating {get;set;}
		public String RecommendedMaximumCreditLimit {get; set;} 
	}
	
	public class Shareholders {
		public ShareholdersList ShareholdersList {get;set;} 

		public Shareholders() {
			this.ShareholdersList = new ShareholdersList();
		}
	}
	
	public class CharacteristicData {
		public String ActivityStartDate {get;set;} 
	}
	
	public class IdentifyingData {
		public CervedProspectAdditionalInformations CervedProspectAdditionalInformations {get;set;} 
		public String VATNo {get;set;} 
		public String Email {get;set;}

		public IdentifyingData() {
			this.CervedProspectAdditionalInformations = new CervedProspectAdditionalInformations();
		}
	}
	
	public class ProtestsAndPrejudicialEvents {
		public PrejudicialEvents PrejudicialEvents {get;set;} 
		public PrejudicialEvents Protests {get;set;} 

		public ProtestsAndPrejudicialEvents() {
			this.PrejudicialEvents = new PrejudicialEvents();
			this.Protests = new PrejudicialEvents();
		}
	}
	
	public class RegisteredHeadOfficeLocation {
		public String CertifiedEmail {get;set;} 
		public Address Address {get;set;} 

		public RegisteredHeadOfficeLocation() {
			this.Address = new Address();
		}
	}
	
	public class RegisteredHeadOfficeIdentification {
		public String CompanyTitle {get;set;} 
		public String VATRegistrationNo {get;set;} 
		public String TaxCode {get;set;} 
		public String CompanyName {get;set;} 
	}
	
	public class Shareholder {
		public String TaxCode {get;set;} 
		public String FirstName {get;set;} 
		public String LastName {get;set;} 
		public String Name {get;set;} 
	}
	
	public class CervedProspectAdditionalInformations {
		public RegisteredHeadOfficeLocation RegisteredHeadOfficeLocation {get;set;} 
		public RegisteredHeadOfficeIdentification RegisteredHeadOfficeIdentification {get;set;} 

		public CervedProspectAdditionalInformations() {
			this.RegisteredHeadOfficeLocation = new RegisteredHeadOfficeLocation();
			this.RegisteredHeadOfficeIdentification = new RegisteredHeadOfficeIdentification();
		}
	}
	
	public class Ateco2007List {
		public List<Ateco2007> Ateco2007 {get;set;} 

		public Ateco2007List() {
			Ateco2007 = new List<Ateco2007>();
		}
	}
	
	public class PersonalData {
		public Domicile Domicile {get;set;} 
		public TaxDomicile TaxDomicile {get;set;}
		public Birth Birth {get;set;} 
		public String TaxCode {get;set;} 
		public String Sex {get;set;} 
		public String FirstName {get;set;} 
		public String LastName {get;set;} 

		public PersonalData() {
			this.Birth = new Birth();
			this.Domicile = new Domicile();
			this.TaxDomicile = new TaxDomicile();
		}
	}
	
	public class ShareholdersList {
		public List<Shareholder> Shareholder {get;set;} 

		public ShareholdersList() {
			this.Shareholder = new List<Shareholder>();
		}
	}
	
	public class Individual {
		public PersonalData PersonalData {get;set;} 

		public Individual() {
			this.PersonalData = new PersonalData();
		}
	}
	
	public class Domicile {
		public String StreetNo {get;set;} 
		public String StreetName {get;set;} 
		public String ToponymCode {get;set;} 
		public String Postcode {get;set;} 
		public String City {get;set;} 
		public String ProvinceCode {get;set;} 
		public String ForeignCountryCode {get;set;}
	}

	public class TaxDomicile {
		public String StreetNo {get;set;} 
		public String StreetName {get;set;} 
		public String ToponymCode {get;set;} 
		public String Postcode {get;set;} 
		public String City {get;set;} 
		public String ProvinceCode {get;set;} 
		public String ForeignCountryCode {get;set;}
	}
	
}