//
//  PageListViewController.swift
//  MTWiki
//
//  Created by Rahul Sharma on 23/06/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//


import UIKit


class PageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {


    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pageListResults : Array<Page>? = nil
    var historyPageListResults : Array<History>? = nil

//    var internalRoles:Array<InternalRole>?

//    var internalContacts:Dictionary<String, Array<Page>>?
//    var internalContactsToBeRemoved:Array<InternalContact>?
//    var selectedContacts:Array<InternalContact>!
//    var internalSectionArray:Array<String>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleUI()
        
        self.searchBar.delegate=self
        
        self.tableView.delegate=self; self.tableView.dataSource=self
        self.tableView.register(UINib.init(nibName: "PageCell", bundle: nil), forCellReuseIdentifier: "PageCell")
        self.tableView.allowsMultipleSelection=true
        self.tableView.tableFooterView = UIView.init()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.historyPageListResults = MTWrapper.sharedInstance.fetchHistoryResults()
//
//        let allContacts = MoxtraWrapper.sharedInstance.fetchInternalContacts()
//        if allContacts != nil  {
//            if self.internalContactsToBeRemoved != nil && self.internalContactsToBeRemoved!.count>0{
//                let filteredContacts = Set(allContacts!).subtracting(self.internalContactsToBeRemoved!).sorted{($0.firstName!+($0.lastName ?? ""))<($1.firstName!+($1.lastName ?? ""))}
//                internalContacts = MoxtraWrapper.sharedInstance.fetchArrangedInternalContact(internalContacts: filteredContacts)
//            }else{
//                internalContacts = MoxtraWrapper.sharedInstance.fetchArrangedInternalContact(internalContacts: allContacts)
//            }
//        }
//        if internalContacts != nil{
//            internalSectionArray = internalContacts!.keys.sorted()
//        }
//        self.selectedContacts = [InternalContact]()
//        internalRoles = MoxtraWrapper.sharedInstance.fetchInternalRoles()
    }
    
    func handleUI(){
        //self.navigationBar.barTintColor = UIColor.primaryColor()
        //self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.secondaryColor()]
       // self.cancelButton.tintColor = UIColor.secondaryColor()
       // self.statusView.backgroundColor = UIColor.primaryColor()
//        
//        let size = CGSize(width:30, height:30)
//        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
//        UIBezierPath.init(roundedRect: CGRect(origin:CGPoint(x:0,y:0),size:size), cornerRadius: 5.0).addClip()
//        UIColor.primaryColor().setFill()
//        UIRectFill(CGRect(origin:CGPoint(x:0,y:0),size:size));
//        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
//        UIGraphicsEndImageContext();
//        self.searchBar.setSearchFieldBackgroundImage(image, for: UIControlState.normal)
//        self.searchBar.layer.borderWidth=1;
//        self.searchBar.layer.borderColor=UIColor.white.cgColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    
    
    //MARK: - Search delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("fire api for \(searchText)")
        MTWrapper.sharedInstance.searchQueryAndUpdateTheDB(query: searchText, success: {
            (code,json) in
            print("success")
            self.pageListResults = MTWrapper.sharedInstance.fetchPageResults()
            self.historyPageListResults = MTWrapper.sharedInstance.fetchHistoryResults()

            print("success fetchPageResults")

            self.tableView.reloadData()
            self.tableView.reloadSections([0, 1], with: .none)


            

        }, failure: {
            (error) in
            print("error")
        })

    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        if alert.popoverPresentationController != nil {
            alert.popoverPresentationController!.sourceView=searchBar
        }
        
//        if self.internalRoles != nil {
//            if self.internalRoles!.count > 0 {
//                for role in self.internalRoles!{
//                    alert.addAction(UIAlertAction.init(title: role.roleDisplayName!, style: UIAlertActionStyle.default, handler:{(action) in
//                        self.internalContacts = MoxtraWrapper.sharedInstance.fetchInternalContactsOf(role: role.roleName)
//                        if self.internalContacts != nil{
//                            self.internalSectionArray = self.internalContacts!.keys.sorted()
//                            self.tableView.reloadData()
//                        }
//                    }))
//                }
//            }
//        }

        alert.addAction(UIAlertAction.init(title: NSLocalizedString("ALL", comment: "ALL"), style: UIAlertActionStyle.cancel, handler: {(action) in
            
        }))
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("ALERT_CANCEL_BUTTON", comment: "ALERT_CANCEL_BUTTON"), style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=true
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=false
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
//        internalContacts = MoxtraWrapper.sharedInstance.fetchInternalContacts(query: nil)
//        if internalContacts != nil{
//            internalSectionArray = internalContacts!.keys.sorted()
//        }
        self.tableView.reloadData()
        searchBar.showsCancelButton=false
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    
    
    //MARK: - table methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
//
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
       // return self.internalContacts != nil ? self.internalContacts!.keys.count:0
    }
//
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if(pageListResults != nil && historyPageListResults != nil){
            return ["Result","History"]

        }
        else if(pageListResults != nil){
            return ["Result"]
        }
        else if (historyPageListResults != nil){
            return ["History"]

        }
        else {return nil}
    }
//
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            if(pageListResults != nil){
                return "Result"
            }else {
                return nil

            }

        }
        else if(section == 1){
            if(historyPageListResults != nil){
                return "History"
            }else{
                return nil
            }

        }
        else {return  ""}
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
             return self.pageListResults != nil ?(self.pageListResults?.count)!:0

        }else{
            return self.historyPageListResults != nil ?(self.historyPageListResults?.count)!:0

        }
      //  return self.pageListResults != nil ?(self.pageListResults?.count)!:0
        //return (self.pageListResults?.count)!
        //return self.internalContacts != nil ? self.internalContacts![internalSectionArray![section]]!.count:0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PageCell = tableView.dequeueReusableCell(withIdentifier: "PageCell", for: indexPath) as! PageCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if(indexPath.section == 0 ){
            if(self.pageListResults != nil){
                cell.mPage = self.pageListResults![indexPath.row]
                cell.prepare()

            }

        }
        if(indexPath.section == 1 ){
            if(self.historyPageListResults != nil){

                    cell.mHistory = self.historyPageListResults![indexPath.row]
                    cell.hisoryPrepare()

            }

        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0 ){
            print("search result section")

            let cell:PageCell = tableView.cellForRow(at: indexPath) as! PageCell
            if(pageListResults != nil ){
                let mPage:Page = self.pageListResults![indexPath.row]

                var wikiUrl :String =  "https://en.wikipedia.org/?curid=\(mPage.pageid)"
                var wikiUrl2 :String = "https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&prop=info&inprop=url&pageids=\(mPage.pageid)"


                //var vc  : PageWebViewController = PageWebViewController()
                var vc  : PageWebViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageWebViewController") as! PageWebViewController

                vc.myUrl = wikiUrl

                //add to history cd

                MagicalRecord.save({
                    (localContext) in
                    let new = History.mr_createEntity(in: localContext)
                    if let newHistory =  new {
                        newHistory.pageDetails?.pageid = mPage.pageid
                        newHistory.pageDetails?.index = mPage.index
                        newHistory.pageDetails?.thumbnailSource = mPage.thumbnailSource
                        newHistory.pageDetails?.title = mPage.title
                        newHistory.pageDetails?.descriptionWiki = mPage.descriptionWiki

                        newHistory.time = NSDate()
                        newHistory.descriptionWiki = mPage.descriptionWiki
                        newHistory.pageIDSeen = mPage.pageid
                        newHistory.title = mPage.title
                        newHistory.pageUrl = wikiUrl
                        newHistory.thumbnailSource = mPage.thumbnailSource
                        let data = MTWrapper.getWebData(url: wikiUrl)
                        newHistory.data = data as? NSData

                    }
                })


                
                self.tableView.reloadData()
                

                self.present(vc, animated: true, completion: nil)

            }
                    }
        if(indexPath.section == 1 ){
            print("history section")

            let cell:PageCell = tableView.cellForRow(at: indexPath) as! PageCell
            if(historyPageListResults != nil ){

              //  let mPage:Page = self.historyPageListResults![indexPath.row].pageDetails!
                let pageid =  self.historyPageListResults![indexPath.row].pageIDSeen
                var wikiUrl :String =  "https://en.wikipedia.org/?curid=\(pageid)"
                var wikiUrl2 :String = "https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&prop=info&inprop=url&pageids=\(pageid)"


                //var vc  : PageWebViewController = PageWebViewController()
                var vc  : PageWebViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageWebViewController") as! PageWebViewController

                vc.myUrl = wikiUrl
                vc.mHistory = self.historyPageListResults![indexPath.row]

                self.present(vc, animated: true, completion: nil)


            }

        }

    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell:InternalContactCell = tableView.cellForRow(at: indexPath) as! InternalContactCell
//        let contact:InternalContact=self.internalContacts![internalSectionArray![indexPath.section]]![indexPath.row]
//        if self.selectedContacts.contains(contact){
//            self.selectedContacts.remove(at: self.selectedContacts.index(of: contact)!)
//            cell.makeSelected(selected: false)
//        }
//    }

}
