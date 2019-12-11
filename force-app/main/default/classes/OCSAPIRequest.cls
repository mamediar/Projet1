public virtual class OCSAPIRequest extends APIRequest  {
    public String serviceId {get; set;}
    public Map<String, String> companyType = new Map<String, String>{'value' => 'COMPASS'};
   
}