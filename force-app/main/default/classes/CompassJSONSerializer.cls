public class CompassJSONSerializer implements CompassSerializer {

	public APIResponse deserialize(HTTPResponse resp, Type respClass) {
		APIResponse res=(APIResponse)respClass.newInstance();        
		res=(APIResponse)JSON.deserialize(resp.getBody(), respClass);
        return res;
	}


	/*public String serialize(APIRequest request) {
		return null;
	}*/

}