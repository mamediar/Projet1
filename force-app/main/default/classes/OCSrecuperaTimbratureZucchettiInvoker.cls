public class OCSrecuperaTimbratureZucchettiInvoker {
    public static OCSrecuperaTimbratureZucchettiResponse callrecuperaTimbratureZucchetti(OCSrecuperaTimbratureZucchettiRequest request){
        return (OCSrecuperaTimbratureZucchettiResponse)ApiUtils.callApi('ocs.recuperaTimbratureZucchetti',request,OCSrecuperaTimbratureZucchettiResponse.class);
    }

    public static OCSrecuperaTimbratureZucchettiResponse callrecuperaTimbratureZucchetti(String idCompany, String idEmploy, Date dataTimbrature){
        OCSrecuperaTimbratureZucchettiRequest request=new OCSrecuperaTimbratureZucchettiRequest();
        request.recuperaTimbratureZucchettiRequest.idEmploy=idEmploy;
        String month=String.valueOf(datatimbrature.month());
        String day=String.valueOf(datatimbrature.day());
        String datatimbratureMonthStr =(month.length()==1 ? '0'+month : month);
        String datatimbratureDayStr =(day.length()==1 ? '0'+day : day);

        request.recuperaTimbratureZucchettiRequest.dataTimbrature=dataTimbrature.year()+datatimbratureMonthStr+datatimbratureDayStr;
        request.recuperaTimbratureZucchettiRequest.idCompany=idCompany;
        OCSrecuperaTimbratureZucchettiResponse res= callrecuperaTimbratureZucchetti(request);
        return res;
    }
}