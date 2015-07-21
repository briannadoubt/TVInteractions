//
//  SecondViewController.swift
//  TV Interactions
//
//  Created by Benjamin Heutmaker on 7/17/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func loadRequest() {
        if let url = appDelegate.url {
            let request = NSURLRequest(URL: url)
            self.webView.loadRequest(request)
        }
    }
    
    func setNavBarTitle(title: String) {
        navBar.topItem?.title = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
