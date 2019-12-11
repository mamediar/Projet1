public interface CompassSerializer {
	
	APIResponse deserialize(HTTPResponse res, Type c);

	//String serialize(APIRequest request);

}