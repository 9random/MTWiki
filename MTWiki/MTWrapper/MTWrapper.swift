//
//  MTWrapper.swift
//  MTWiki
//
//  Created by Rahul Sharma on 23/06/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class MTWrapper :NSObject,URLSessionDelegate{
    //MARK: - Methods
//    let baseURL =
//"""
//    https://en.wikipedia.org/w/api.php?action=query&format=json&
//prop=pageimages%7Cpageterms&titles=Albert%20Einstein%7CAlbert%20Ellis%7CAlbert%20Estopinal&redirects=1&formatversion=2&piprop=thumbnail&pilimit=3&wbptterms=description
//"""
    // let baseURL = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&titles=Albert%20Einstein%7CAlbert%20Ellis%7CAlbert%20Estopinal&redirects=1&formatversion=2&piprop=thumbnail&pilimit=3&wbptterms=description"
//    let baseURL = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=Sachin+T&gpslimit=10"
let baseURL = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpslimit=10"
    static let sharedInstance: MTWrapper = {
        let instance = MTWrapper()
        return instance
    }()
    //MARK: Utility
    //returns all internal as array
    func fetchPageResults()->Array<Page>?{
        return Page.mr_findAllSorted(by: "index", ascending: true) as? Array<Page>
    }
    func fetchHistoryResults()->Array<History>?{
        return History.mr_findAllSorted(by: "time", ascending: false) as? Array<History>
    }
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    static func getWebData(url: String?)->Data?{
        if let url = url{
            let uri = URL.init(string: url)
            if let uri = uri{
                var request = URLRequest.init(url: uri, cachePolicy: URLRequest.CachePolicy.returnCacheDataDontLoad, timeoutInterval: 35)
                request.httpMethod="GET"
                let response = URLCache.shared.cachedResponse(for: request)
                if let response = response{
                    let data = response.data
                    return data
                }
            }
        }
        return nil
    }


    //MARK: REST
    func searchQueryAndUpdateTheDB (query:String?,success: @escaping (_ httpCode :Int , _ json:Dictionary<String,Any>?)->Void ,failure:@escaping (_ error:Error )->Void) -> Void {
        if let q = query {
            // make the new apt url and feed
            var url = baseURL+"&gpssearch=\(query!)"
            var realurl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

            URLSession.callGetMethodWithURL(urlString: url, headers: nil, delegate: self, success: {(code,json)->Void in
                print("MTWrapper lol1")
                //clear the db and
                //add to db
                if let response = json{
                    if let query = response["query"]{
                        var query1 = response["query"] as? Dictionary<String,Any>
                        let pages:Array<Dictionary<String, Any>>? = query1!["pages"] as? Array<Dictionary<String, Any>>
                        if(pages != nil){
                            if((pages?.count)!>0){

                                MagicalRecord.save(
                                    { (localContext) in
                                    if Page.mr_truncateAll(in: localContext){
                                        for page in pages!{
                                            let new = Page.mr_createEntity(in: localContext)
                                            if new != nil{
                                                if let index = (page["index"] as? Int64){
                                                    new!.index = index
                                                }
                                                new!.title = page["title"]  as? String

                                                if let pageid = (page["pageid"] as? Int64){
                                                    new!.pageid = pageid
                                                }
                                                var thumbnail:Dictionary<String,Any>? = page["thumbnail"] as? Dictionary<String, Any>
                                                if(thumbnail != nil){
                                                    new!.thumbnailSource = thumbnail!["source"] as? String
                                                    if let thumbnailWidth = (page["width"] as? Int64){
                                                        new!.thumbnailWidth = thumbnailWidth
                                                    }
                                                    if let thumbnailHeight = (page["height"] as? Int64){
                                                        new!.thumbnailHeight = thumbnailHeight
                                                    }
                                                }
                                                var terms:Dictionary<String,Any>? = page["terms"] as? Dictionary<String, Any>
                                                if(terms != nil ){

                                                    var descriptionArray:Array<String>? = terms!["description"] as? Array<String>
                                                    if(descriptionArray != nil){
                                                        if(descriptionArray!.count > 0){
                                                            new!.descriptionWiki = descriptionArray![0]
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }, completion: { (pass, error) in
                                    if pass {
                                        DispatchQueue.main.async {
                                            success(code,json)

                                        }
                                    }
                                })         }
                        }
                        }
                    }
        }, failure: {
            (error) ->Void in
            print("MTWrapper lol2")
            DispatchQueue.main.async {failure(error)}

        })

        }}


}
