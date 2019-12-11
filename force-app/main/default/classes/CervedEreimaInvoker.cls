public class CervedEreimaInvoker {
    public static CervedEreimaResponse getDatiEreima(CervedEreimaRequest request){
        return (CervedEreimaResponse) ApiUtils.callApi('cerved.ereima', request, CervedEreimaResponse.class);
    }
    
    public static CervedEreimaResponse getDatiEreima(String parameter){
        CervedEreimaRequest request = new CervedEreimaRequest('CFI+' + parameter + '+++++X+');
        return(getDatiEreima(request));
    }
}