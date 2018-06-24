//
//  URLSession+Addon.swift
//  MTWiki
//
//  Created by Rahul Sharma on 22/06/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import Foundation
import UIKit

extension URLSession {

    static func callGetMethodWithURL(urlString:String ,headers:Dictionary<String, String>? ,delegate :URLSessionDelegate , success: @escaping (_ httpCode :Int , _ json:Dictionary<String,Any>?)->Void ,failure:@escaping (_ error:Error )->Void) -> Void {
        print("heloo extension of URLSession")
        var session: URLSession =  URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: nil)
        var url  = URL(string: urlString)
        var request:URLRequest = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "GET"

        if let headerUnwrapped = headers {
            for (key ,holder) in  headerUnwrapped {
                request.addValue(holder, forHTTPHeaderField: key)
            }
        }
        print("URL is \(url) and Request is \(request)")

        session.dataTask(with: request, completionHandler:{
            (data:Data? ,response:URLResponse?,error:Error?)->Void in
            self.handleResponsewith(url: urlString, data: data, response: response, error0: error,success: success,failure: failure)
            }).resume()

        }

    static func handleResponsewith(url:String?,data:Data?,response:URLResponse?,error0:Error?,success:(_ httpCode :Int , _ json:Dictionary<String,Any>?)->Void ,failure:(_ error1:Error )->Void)->Void{

        if  error0 == nil {
            if let data = data {
                do  {
                    let json :Dictionary<String,Any>? = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Dictionary<String,Any>

                    let httpResponse:HTTPURLResponse = response as! HTTPURLResponse
                    let statusCode:Int =  httpResponse.statusCode
                    print("URL->\(url), Success-> \(json)",url,json);
                    success(statusCode, json);
                }
                catch {
                    print("Unexpected error: \(error).")
                    print("URL->\(url), Response parse error->\(error.localizedDescription)");
                     let resp = String.init(data: data, encoding: .utf8)
                    print("Response -> \(resp)");
                    failure(error)

                }

            }
        }else{
            print("URL->\(url), URL Domain error->\(error0?.localizedDescription)");
            failure(error0!)

        }


    }


}
