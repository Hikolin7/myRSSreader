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
    
    //let UrlString = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://feeds.feedburner.com/hatena/b/hotentry&num=-1"
    
    //@IBOutlet weak var textLabel: UILabel!
    //@IBOutlet weak var cell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self;
        myTableView.dataSource = self;
        
        request()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    //    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "news")
    //        self.configureCell(cell, atIndexPath: indexPath)
    //        return cell
    //    }
    
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
    
    //    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
    //        //get entry
    //        var entry = entries[indexPath.row] as NSDictionary
    //
    //        //set title
    //        //cell.textLabel.text = entry["title"] as? String
    //    }
    
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
    
    //add segue
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Segue
        performSegueWithIdentifier("detail", sender: entries[indexPath.row])
        println("didSelectRowAtIndexPath success")
    }
    
    // send entry to DetailController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            // get DetailController
            var webViewController = segue.destinationViewController as WebViewController
            
            // set entry
            webViewController.entry = sender as NSDictionary
        }
    }

    
//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        if (segue.identifier == "detal") {
//            let nextViewController: NextViewController = segue.destinationViewController as NextViewController
//            nextViewController.param = param
//        }
//    }

}
