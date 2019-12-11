public  class XMLSerializerGenerique implements CompassSerializer {
   public APIResponse deserialize(HTTPResponse resp, Type respClass) {
		System.debug('################ CompassXMLSerializer  '+ respClass);
		System.debug('################ CompassXMLSerializer  resp '+ resp.getBody());
		APIXMLResponse r = (APIXMLResponse) respClass.newInstance();
		System.debug('################ CompassXMLSerializer r  '+ r);
        Set<String> tagNamesAsArray = r.getTagNamesAsArray();
		System.debug('################ CompassXMLSerializer  tagNamesAsArray '+ tagNamesAsArray.size());
        OCSXMLSerializer xmls = new OCSXMLSerializer();
        if (tagNamesAsArray != null & tagNamesAsArray.size() >= 1){
          
		  System.debug('################ Okkkkkkkkkkk   ');
		  return (APIXMLResponse) xmls.deserialize(resp.getBody(), respClass, tagNamesAsArray);
		}
        	
        else
            return (APIXMLResponse) xmls.deserialize(resp.getBody(), respClass);
	}
}