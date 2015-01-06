//
//  TableViewController.swift
//  InakadelifeRSSreader
//
//  Created by 七田　人比古 on 2015/01/02.
//  Copyright (c) 2015年 Shichida Hitohiko. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var textLabel: UILabel?
    
    
    var cell : UITableViewCell!
    var entries = NSArray()
    let UrlString = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://feeds.feedburner.com/inakadelife/rss&num=-1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self;
        myTableView.dataSource = self;
        
        request()

    }
    
    @IBAction func reloadButton(sender: AnyObject) {
        request()
        println("success")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //count cell of table view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    //make tableView
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //get cell
        cell = tableView.dequeueReusableCellWithIdentifier("newArticle") as UITableViewCell?
        
        //get entry
        var entry = entries[indexPath.row] as NSDictionary
        
        //set title
        cell.textLabel!.text = entry["title"] as? String
        
        return cell!
    }
    
    func request() {
        let URL = NSURL(string: UrlString)!
        var task = NSURLSession.sharedSession().dataTaskWithURL(URL, completionHandler: {data, response, error in
            // conver json to dictionary
            var dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            
            // get responseData entries
            if var responseData = dict["responseData"] as? NSDictionary {
                if var feed = responseData["feed"] as? NSDictionary {
                    if var entries = feed["entries"] as? NSArray {
                        // set array of entries
                        self.entries = entries
                    }
                }
            }
            //switch to main thread to relad table view
            dispatch_async(dispatch_get_main_queue(), {
                //reload table view
                self.tableView.reloadData()
            })
        })
        task.resume()
        
    }
    
    var selectEntry = NSDictionary()
    //add segue
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectEntry = self.entries[indexPath.row] as NSDictionary
        let webBrowser = TSMiniWebBrowser(url: NSURL(string: self.selectEntry["link"] as String))
        webBrowser.showURLStringOnActionSheetTitle = true
        webBrowser.showPageTitleOnTitleBar = true
        webBrowser.showActionButton = true
        webBrowser.showReloadButton = true
        webBrowser.barStyle = .Black
        
        webBrowser.mode = TSMiniWebBrowserModeNavigation
        self.navigationController?.pushViewController(webBrowser, animated: true)
    }
    
}
