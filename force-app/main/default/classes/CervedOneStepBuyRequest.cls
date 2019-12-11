public class CervedOneStepBuyRequest extends OCSRequest {
	
	public CervedOneStepBuyRequestDTO cervedOneStepBuyRequest;

	public CervedOneStepBuyRequest() {
		serviceId = 'cervedOneStepBuy';
		this.cervedOneStepBuyRequest = new CervedOneStepBuyRequestDTO();
  }
	public class CervedOneStepBuyRequestDTO {
		public Integer productCode {get { if (productCode == null) productCode = 55200; return productCode;} set;}
		public Integer urgency {get { if (urgency == null) urgency = 1; return urgency;} set;}
		public String reasonOfEnquiry {get { if (reasonOfEnquiry == null) reasonOfEnquiry = ''; return reasonOfEnquiry;} set;}
		public String attention {get { if (attention == null) attention = ''; return attention;} set;}
		public String reference {get { if (reference == null) reference = ''; return reference;} set;}
		public String deliveryChannel {get { if (deliveryChannel == null) deliveryChannel = 'WW'; return deliveryChannel;} set;}
		public String recipient {get { if (recipient == null) recipient = ''; return recipient;} set;}
		public String notes {get { if (notes == null) notes = ''; return notes;} set;}
		public String language {get { if (language == null) language = ''; return language;} set;}
		public String fiscalCode {get { if (fiscalCode == null) fiscalCode = ''; return fiscalCode;} set;}
		public String vatNumber {get { if (vatNumber == null) vatNumber = ''; return vatNumber;} set;}
		public String registrationProvince {get { if (registrationProvince == null) registrationProvince = ''; return registrationProvince;} set;}
		public String companyName {get { if (companyName == null) companyName = ''; return companyName;} set;}
		public String address {get { if (address == null) address = ''; return address;} set;}
		public String town {get { if (town == null) town = ''; return town;} set;}
		public String hamlet {get { if (hamlet == null) hamlet = ''; return hamlet;} set;}
		public String zipCode {get { if (zipCode == null) zipCode = ''; return zipCode;} set;}
		public String addressProvince {get { if (addressProvince == null) addressProvince = ''; return addressProvince;} set;}
		public String phoneNumber {get { if (phoneNumber == null) phoneNumber = ''; return phoneNumber;} set;}
		public String country {get { if (country == null) country = ''; return country;} set;}
		public String countryCode {get { if (countryCode == null) countryCode = ''; return countryCode;} set;}
	}

}