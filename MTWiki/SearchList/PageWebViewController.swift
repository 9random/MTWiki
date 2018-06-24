//
//  PageWebViewController.swift
//  MTWiki
//
//  Created by Rahul Sharma on 24/06/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import UIKit

class PageWebViewController: UIViewController ,UIWebViewDelegate{
    var mHistory:History? = nil


    @IBOutlet weak var myWebViewOK: UIWebView!
    //    @IBOutlet weak var myView: UIView!
    var myWebView: UIWebView?
    var myUrl:String?
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if(MTWrapper.isInternetAvailable()){
            networkCall()
        }else{
            if(mHistory != nil){
                if(mHistory?.data != nil){
                    if let url = URL.init(string: (mHistory?.pageUrl)!){
                        myWebViewOK.load(mHistory?.data! as! Data, mimeType: "text/html", textEncodingName: "", baseURL:url)

                    }


                }
            }
        }


        // Do any additional setup after loading the view.
    }
    func networkCall(){
        let url = URL(string: "https://www.google.co.in")
        if(myUrl == nil){
            let requestObj = URLRequest(url: url!)
            myWebViewOK?.loadRequest(requestObj)


        }else{
            var myUrlforReq = URL(string: myUrl!)
            let requestObj = URLRequest(url: myUrlforReq!)
            myWebViewOK?.loadRequest(requestObj)

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
