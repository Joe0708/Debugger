import Foundation

@objc
open class NetfoxProtocol: URLProtocol {
    var connection: NSURLConnection?
    var model: NetfoxHTTPModel?
    var session: URLSession?
    
    override open class func canInit(with request: URLRequest) -> Bool{
        return canServeRequest(request)
    }
    
    override open class func canInit(with task: URLSessionTask) -> Bool {
        guard let request = task.currentRequest else { return false }
        return canServeRequest(request)
    }
    
    fileprivate class func canServeRequest(_ request: URLRequest) -> Bool {
        
        guard Netfox.shared.isEnabled() else { return false }
        guard let url = request.url else { return false }
        guard url.absoluteString.hasPrefix("http"), url.absoluteString.hasPrefix("https") else { return false }
        
        let urls = Netfox.shared.getIgnoredURLs().filter { url.absoluteString.hasPrefix($0) }
        guard urls.count == 0 else { return false }
        guard URLProtocol.property(forKey: "NFXInternal", in: request) == nil else { return false }
        
        return true
    }
    
    override open func startLoading() {
        model = NetfoxHTTPModel()
                
        let req = (NetfoxProtocol.canonicalRequest(for: request) as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        
        model?.saveRequest(req as URLRequest)
                
        URLProtocol.setProperty("1", forKey: "NFXInternal", in: req)
        
        if session == nil {
            session = URLSession(configuration: URLSessionConfiguration.default)
        }
        
        session!.dataTask(with: req as URLRequest, completionHandler: {data, response, error in
            
            if let error = error {
                self.model?.saveErrorResponse()
                self.loaded()
                self.client?.urlProtocol(self, didFailWithError: error)
            } else {
                if let data = data {
                    self.model?.saveResponse(response!, data: data)
                }
                self.loaded()
            }
            
            if let response = response, let client = self.client {
                client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data = data {
                self.client!.urlProtocol(self, didLoad: data)
            }
            
            if let client = self.client {
                client.urlProtocolDidFinishLoading(self)
            }
        }).resume()
    }
    
    override open func stopLoading() {
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
        
    func loaded() {
        if let `model` = model {
            NFXHTTPModelManager.sharedInstance.add(model)
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NFXReloadData"), object: nil)
    }
    
}
