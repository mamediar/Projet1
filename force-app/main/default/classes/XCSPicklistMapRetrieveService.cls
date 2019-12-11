@RestResource (urlMapping='/PicklistMapRetrieve/*')
global with sharing class XCSPicklistMapRetrieveService {

    @HttpPost
    global static void execute() {
        final RestRequest req = RestContext.request;
        final RestResponse res = Restcontext.response;
        
        try {
            res.responseBody = Blob.valueOf(execute(req.requestBody.toString().trim()));
            res.statusCode = 200;
        }
        catch(Exception e) {
            if (res <> null) {
            	res.responseBody = Blob.valueOf(e.getMessage());
            	res.statusCode = 500;
            }
            return;
        }
    }

    public static String execute(final String jsonRequest) {
        final PicklistMapRetrieveRequest request = (PicklistMapRetrieveRequest) JSON.deserialize(jsonRequest, PicklistMapRetrieveRequest.class);
        final PicklistMapRetrieverResponse response = new PicklistMapRetrieverResponse();
        System.debug(LoggingLevel.DEBUG, 'Input JSON deserialized in ' + request);
		
		final String sObjName = request.OBJ;
		final PicklistName[] picklistNameArr = request.PICKNAMES;

        System.debug('picklistNameArr.size:' + picklistNameArr.size());
        response.PICKRES = new PicklistMapResult[picklistNameArr.size()];
        System.debug('response.PICKRES:' + response.PICKRES);
        System.debug('response.PICKRES size:' + response.PICKRES.size());

        final Schema.SObjectType st = Schema.getGlobalDescribe().get(sObjName);
        final Map<String, SObjectField> fieldMap = st.getDescribe().fields.getMap();

		for (Integer i = 0; i < picklistNameArr.size(); i++) {
            final String picklistName = picklistNameArr[i].PICKNAME;
            System.debug('picklistName:' + picklistName);
            final Schema.DescribeFieldResult fieldResult = fieldMap.get(picklistName).getDescribe();
            final List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            response.PICKRES[i] = new PicklistMapResult();
            final PicklistMapResult picklstMapRes = response.PICKRES[i];
            System.debug('picklstMapRes:' + picklstMapRes);
            picklstMapRes.PICKNAME = picklistName;
            picklstMapRes.PICKMAP = new PicklistMap[ple.size()];
            
            for (Integer j = 0; j < ple.size(); j++) {
                picklstMapRes.PICKMAP[j] = new PicklistMap();
                picklstMapRes.PICKMAP[j].LABEL = ple[j].getLabel();
                picklstMapRes.PICKMAP[j].VALUE = ple[j].getValue();
            }
		}

        return JSON.serialize(response);
    }

    public class PicklistMapRetrieveRequest {
		public String OBJ;
		public PicklistName[] PICKNAMES;
    }
	
	public class PicklistName {
		public String PICKNAME;
    }
	
	public class PicklistMapRetrieverResponse {
		public PicklistMapResult[] PICKRES;
    }

    public class PicklistMapResult {
        public String PICKNAME;
        public PicklistMap[] PICKMAP;
    }

    public class PicklistMap {
		public String LABEL;
        public String VALUE;
    }

}