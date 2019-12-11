public class CervedEreimuInvoker {
    public static CervedEreimuResponse getDatiEreimu(CervedEreimuRequest request){
        system.debug('RequestEreimu_1 :'+ request);
        return (CervedEreimuResponse) ApiUtils.callApi('cerved.ereimu', request, CervedEreimuResponse.class);
    }
    
    public static CervedEreimuResponse getDatiEreimu(String parameter){
        system.debug('RequestEreimu_2 :'+ parameter);
        CervedEreimuRequest request = new CervedEreimuRequest('CFI+' + parameter + '+++++X+');
         system.debug('RequestEreimu_2_R :'+ request);
        return(getDatiEreimu(request));
    }
}