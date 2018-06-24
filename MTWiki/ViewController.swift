//
//  ViewController.swift
//  MTWiki
//
//  Created by Rahul Sharma on 22/06/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController,URLSessionDelegate {
    let url = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&titles=Albert%20Einstein%7CAlbert%20Ellis%7CAlbert%20Estopinal&redirects=1&formatversion=2&piprop=thumbnail&pilimit=3&wbptterms=description"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func succesHandler (code:Int,json:Dictionary<String,Any>?) ->Void {
//
//    }
//    func errorHandler (error:Error)->Void{
//
//    }


    @IBAction func Button1Pressed(_ sender: Any) {
        var vc = PageListViewController()
        self.present(vc, animated: true, completion: nil)

    }
    @IBAction func Button2TestingClicked(_ sender: Any) {
//        var vc = WikiDetailViewController()
//        var vc = PageWebViewController()
        var vc  : PageWebViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageWebViewController") as! PageWebViewController

        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func apiButtonPressed(_ sender: Any) {
        var headers = ["Content-Type": "application/json"]
        URLSession.callGetMethodWithURL(urlString: url, headers: headers, delegate: self, success: {(code,json)->Void in
            print("lol1")
//            print(json)
            let alert :UIAlertController  = UIAlertController(title: "", message: "Success", preferredStyle: UIAlertControllerStyle(rawValue: 1)!)
//            let alert :UIAlertController  = UIAlertController(title: "", message: "Success", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }, failure: {(error) ->Void in
            print("lol2")
            print(error.localizedDescription)

            })

        }
}


