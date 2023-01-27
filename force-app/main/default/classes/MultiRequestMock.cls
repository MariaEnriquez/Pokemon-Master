public class MultiRequestMock implements HttpCalloutMock {
    Map<String, HttpCalloutMock> requests;
    
    public virtual class MyCustomException extends Exception {
    }

    public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    public HTTPResponse respond(HTTPRequest req) {
	    HttpCalloutMock mock = requests.get(req.getEndpoint());
	    if (mock != null) {
	        return mock.respond(req);
        } else {
            throw new MyCustomException('HTTP callout not supported for test methods');
	    }
    }
}