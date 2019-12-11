public virtual class APIRequest {

    public virtual Map<String, String> getParametri() {
        return new Map<String, String>();
    }

    public String getFullUrl(Map<String, String> parametri, String endPoint) {
        PageReference pgEndPoint = new PageReference(endPoint);

        if (parametri != null) {
          System.debug('####################### parametri Not Null '+parametri);
            for (String key : parametri.keySet()) {
                String value = parametri.get(key);
                pgEndPoint.getParameters().put(key, value);
            }
                
            return pgEndPoint.getUrl();
        }
        else
            return null;
    }

}