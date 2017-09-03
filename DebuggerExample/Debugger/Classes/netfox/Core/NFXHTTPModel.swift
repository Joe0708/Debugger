//
//  NFXHTTPModel.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class NFXHTTPModel: NSObject {
    var requestURL: URL?
    var requestURLString: String? {
        return requestURL != nil ? requestURL!.absoluteString : "Unknown"
    }
    var requestMethod: String!
    var requestCachePolicy: String?
    var requestDate: Date?
    var requestTime: String!
    var requestTimeout: String?
    var requestHeaders: [AnyHashable: Any]?
    var requestBodyLength: Int?
    var requestType: String?
    
    var responseStatus: Int?
    var responseType: String?
    var responseDate: Date?
    var responseTime: String?
    var responseHeaders: [AnyHashable: Any]?
    var responseBodyLength: Int = 0
    
    var timeInterval: Float?
    
    var randomHash: String?
    
    var shortType = HTTPModelShortType.OTHER.rawValue
    
    var noResponse: Bool = true
    
    func saveRequest(_ request: URLRequest) {
        self.requestDate = Date()
        self.requestTime = getTimeFromDate(self.requestDate!)
        self.requestURL = request.url
        self.requestMethod = request.httpMethod ?? "Unknown"
        self.requestCachePolicy = request.getNFXCachePolicy()
        self.requestTimeout = request.getNFXTimeout()
        self.requestHeaders = request.getNFXHeaders()
        self.requestType = requestHeaders?["Content-Type"] as! String?
        saveRequestBodyData(request.getNFXBody())
        formattedRequestLogEntry().appendToFile(filePath: sessionLogPath)

    }
    
    func saveErrorResponse() {
        self.responseDate = Date()
    }
    
    func saveResponse(_ response: URLResponse, data: Data) {
        self.noResponse = false
        
        self.responseDate = Date()
        self.responseTime = getTimeFromDate(self.responseDate!)
        self.responseStatus = (response as? HTTPURLResponse)?.statusCode ?? 999
        self.responseHeaders = response.getNFXHeaders()
        
        let headers = response.getNFXHeaders()
        
        if let contentType = headers["Content-Type"] as? String {
            self.responseType = contentType.components(separatedBy: ";")[0]
            self.shortType = getShortTypeFrom(self.responseType!).rawValue
        }
        
        self.timeInterval = Float(self.responseDate!.timeIntervalSince(self.requestDate!))
        
        saveResponseBodyData(data)
        formattedResponseLogEntry().appendToFile(filePath: sessionLogPath)
    }
    
    
    func saveRequestBodyData(_ data: Data) {
        self.requestBodyLength = data.count
        if let bodyString = String(data: data, encoding: .utf8) {
            saveData(bodyString, toFile: getRequestBodyFilepath())
        }
    }
    
    func saveResponseBodyData(_ data: Data){
        var bodyString: String?
        
        if self.shortType == HTTPModelShortType.IMAGE.rawValue {
            bodyString = data.base64EncodedString(options: .endLineWithLineFeed)

        } else {
            if let tempBodyString = String(data: data, encoding: .utf8) {
                bodyString = tempBodyString
            }
        }
        
        if (bodyString != nil) {
            self.responseBodyLength = data.count
            saveData(bodyString!, toFile: getResponseBodyFilepath())
        }
        
    }
    
    fileprivate func prettyOutput(_ rawData: Data, contentType: String? = nil) -> String{
        if let contentType = contentType {
            let shortType = getShortTypeFrom(contentType)
            if let output = prettyPrint(rawData, type: shortType) {
                return output
            }
        }
        return String(data: rawData, encoding: .utf8) ?? ""
    }

    func getRequestBody() -> String {
        guard let data = readRawData(getRequestBodyFilepath()) else {
            return ""
        }
        return prettyOutput(data, contentType: requestType)
    }
    
    func getResponseBody() -> String {
        guard let data = readRawData(getResponseBodyFilepath()) else {
            return ""
        }
        
        return prettyOutput(data, contentType: responseType)
    }
    
    func getRequestBodyFilepath() -> String {
        return FileManager.debugger.appendingPathComponent("Request").appendingPathComponent(requestDate!.description + ".log")
    }
    
    func getResponseBodyFilepath() -> String {
        return FileManager.debugger.appendingPathComponent("Response").appendingPathComponent(requestDate!.description + ".log")
    }
    
    func saveData(_ dataString: String, toFile: String) {
        FileManager.create(at: toFile)
        FileManager.save(content: dataString, savePath: toFile)
    }
    
    func readRawData(_ fromFile: String) -> Data? {
        return (try? Data(contentsOf: URL(fileURLWithPath: fromFile)))
    }
    
    func getTimeFromDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour, .minute, .second], from: date)
        guard let hour = components.hour, let minutes = components.minute, let second = components.second else {
            return "00:00:00"
        }
        return String(format: "%d:%02d:%d", hour, minutes, second)
    }
    
    func getShortTypeFrom(_ contentType: String) -> HTTPModelShortType {
        if NSPredicate(format: "SELF MATCHES %@",
                                "^application/(vnd\\.(.*)\\+)?json$").evaluate(with: contentType) {
            return .JSON
        }
        
        if (contentType == "application/xml") || (contentType == "text/xml")  {
            return .XML
        }
        
        if contentType == "text/html" {
            return .HTML
        }
        
        if contentType.hasPrefix("image/") {
            return .IMAGE
        }
        
        return .OTHER
    }
    
    func prettyPrint(_ rawData: Data, type: HTTPModelShortType) -> String? {
        switch type {
        case .JSON:
            do {
                let rawJsonData = try JSONSerialization.jsonObject(with: rawData, options: [])
                let prettyPrintedString = try JSONSerialization.data(withJSONObject: rawJsonData, options: [.prettyPrinted])
                return String(data: prettyPrintedString, encoding: .utf8)
            } catch {
                return nil
            }
        
        default:
            return nil
        }
    }
    
    func isSuccessful() -> Bool {
        return self.responseStatus != nil && self.responseStatus < 400
    }
    
    
    func formattedRequestLogEntry() -> String {
        var log = String()
        
        if let requestURLString = self.requestURLString {
            log.append("-------START REQUEST -  \(requestURLString) -------\n")
        }

        if let requestMethod = self.requestMethod {
            log.append("[Request Method] \(requestMethod)\n")
        }
        
        if let requestDate = self.requestDate {
            log.append("[Request Date] \(requestDate)\n")
        }
        
        if let requestTime = self.requestTime {
            log.append("[Request Time] \(requestTime)\n")
        }
        
        if let requestType = self.requestType {
            log.append("[Request Type] \(requestType)\n")
        }
            
        if let requestTimeout = self.requestTimeout {
            log.append("[Request Timeout] \(requestTimeout)\n")
        }
            
        if let requestHeaders = self.requestHeaders {
            log.append("[Request Headers]\n\(requestHeaders)\n")
        }
        
        log.append("[Request Body]\n \(getRequestBody())\n")
        
        if let requestURLString = self.requestURLString {
            log.append("-------END REQUEST - \(requestURLString) -------\n\n")
        }
        
        return log;
    }
    
    func formattedResponseLogEntry() -> String {
        var log = String()
        
        if let requestURLString = self.requestURLString {
            log.append("-------START RESPONSE -  \(requestURLString) -------\n")
        }
        
        if let responseStatus = self.responseStatus {
            log.append("[Response Status] \(responseStatus)\n")
        }
        
        if let responseType = self.responseType {
            log.append("[Response Type] \(responseType)\n")
        }
        
        if let responseDate = self.responseDate {
            log.append("[Response Date] \(responseDate)\n")
        }
        
        if let responseTime = self.responseTime {
            log.append("[Response Time] \(responseTime)\n")
        }
        
        if let responseHeaders = self.responseHeaders {
            log.append("[Response Headers]\n\(responseHeaders)\n\n")
        }
        
        log.append("[Response Body]\n \(getResponseBody())\n")
        
        if let requestURLString = self.requestURLString {
            log.append("-------END RESPONSE - \(requestURLString) -------\n\n")
        }
        
        return log;
    }

}
