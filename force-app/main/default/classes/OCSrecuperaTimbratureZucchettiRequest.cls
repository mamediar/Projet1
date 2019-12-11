public class OCSrecuperaTimbratureZucchettiRequest extends OCSRequest{
    public recuperaTimbratureZucchettiRequestDTO recuperaTimbratureZucchettiRequest{get; set;}

    public OCSrecuperaTimbratureZucchettiRequest(){
        this.serviceId= 'recuperaTimbratureZucchetti';
        this.recuperaTimbratureZucchettiRequest= new recuperaTimbratureZucchettiRequestDTO();
    }

    public class recuperaTimbratureZucchettiRequestDTO{
        public String idCompany{get;set;}
        public String idEmploy{get;set;}
        public String dataTimbrature{get;set;}
    }
}