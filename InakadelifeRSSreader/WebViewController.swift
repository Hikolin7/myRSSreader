//
//  WebViewController.swift
//  InakadelifeRSSreader
//
//  Created by 七田　人比古 on 2015/01/03.
//  Copyright (c) 2015年 Shichida Hitohiko. All rights reserved.
//

import UIKit

class WebViewController: UIViewController ,UIWebViewDelegate {
    
    var entry = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let webBrowser = TSMiniWebBrowser(url: NSURL(string: "http://google.com"))
        let webBrowser = TSMiniWebBrowser(url: NSURL(string: self.entry["link"] as String))
        webBrowser.showURLStringOnActionSheetTitle = true
        webBrowser.showPageTitleOnTitleBar = true
        webBrowser.showActionButton = true
        webBrowser.showReloadButton = true
        webBrowser.barStyle = .Black

        webBrowser.mode = TSMiniWebBrowserModeNavigation
        self.navigationController?.pushViewController(webBrowser, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
