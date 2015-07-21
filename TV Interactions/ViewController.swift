//
//  ViewController.swift
//  TV Interactions
//
//  Created by Benjamin Heutmaker on 7/17/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIWebViewDelegate {
    
    var webView: UIWebView?
    
    var secondWindow: UIWindow?
    var vc: SecondViewController?
    
    var urlBar: UITextField?
    var urlIsShown = false
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let url = appDelegate.url {
            
            let webFrame = CGRectMake(0, 20, self.view.frame.width, self.view.frame.height - 20)
            webView = UIWebView(frame: webFrame)
            webView?.loadRequest(NSURLRequest(URL: url))
            
            webView!.delegate = self
            webView!.scrollView.delegate = self
            
            view.insertSubview(webView!, atIndex: 0)
        }
        
        checkForExistingScreenAndInitializeIfPresent()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func urlButtonClicked() {
        if !urlIsShown {
            showURLBar()
        } else {
            removeURLBar()
        }
    }
    
    @IBAction func refreshButtonClicked() {
        if let url = appDelegate.url {
            requestURL(url)
        }
    }
    
    @IBAction func connectButtonClicked() {
        checkForExistingScreenAndInitializeIfPresent()
    }
    
    func showURLBar() {
        
        if !urlIsShown {
            
            if urlBar == nil {
                urlBar = UITextField(frame: CGRectMake(16, -30, view.frame.width - 32, 30))
                urlBar?.borderStyle = UITextBorderStyle.RoundedRect
                urlBar!.delegate = self
                
                view.insertSubview(urlBar!, aboveSubview: webView!)
            }
            
            UIView.animateWithDuration(0.3) { () -> Void in
                self.urlBar!.frame.origin.y = 20
                self.urlBar!.becomeFirstResponder()
                
                self.urlIsShown = true
            }
        }
    }
    
    func removeURLBar() {
        
        if urlIsShown {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.urlBar!.frame.origin.y = -30
                self.urlBar!.resignFirstResponder()
                
                self.urlIsShown = false
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let text = textField.text
        var urlText: String?
        
        if text != "" {
            if text?.lowercaseString.rangeOfString("http://") == nil {
                urlText = "http://\(text!)"
            } else {
                urlText = text!
            }
            
            let url = NSURL(string: urlText!)
            requestURL(url!)
        }
            
        removeURLBar()
        
        return false
    }
    
    func requestURL(url: NSURL) {
        appDelegate.url = url
        
        self.loadRequest()
        
        vc!.loadRequest()
        vc!.setNavBarTitle(url.absoluteString)
    }
    
    func loadRequest() {
        if let url = appDelegate.url {
            let request = NSURLRequest(URL: url)
            self.webView!.loadRequest(request)
        }
    }
    
    func checkForExistingScreenAndInitializeIfPresent() {
        
        //Checking for screens...
        
        if UIScreen.screens().count > 1 {
            //Found a screen!
            
            //Here's the screen...
            let secondScreen = UIScreen.screens()[1]
            let screenBounds = secondScreen.bounds
            
            //And here's the window for that screen...
            secondWindow = UIWindow(frame: screenBounds)
            secondWindow?.screen = secondScreen
            
            //Set up and configure the ViewController on the second window...
            vc = SecondViewController()
            vc!.view = NSBundle.mainBundle().loadNibNamed("SecondViewController", owner: vc, options: nil)[0] as! UIView
            
            vc?.webView.delegate = self
            
            secondWindow?.rootViewController = vc
            
            //Screen has been set up, now displaying...
            self.secondWindow?.hidden = false
            
            //Second screen has been displayed!
            vc?.webView.loadRequest(NSURLRequest(URL: appDelegate.url!))
            vc?.title = appDelegate.url!.absoluteString
            
        } else {
            print("No other screens")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let firstOffsetY = self.webView!.scrollView.contentOffset.y
        let firstOffsetX = self.webView!.scrollView.contentOffset.x
        
        let firstContentSizeHeight = self.webView?.scrollView.contentSize.height
        let firstContentSizeWidth = self.webView?.scrollView.contentSize.width
        
        let secondContentSizeHeight = vc!.webView.scrollView.contentSize.height
        let secondContentSizeWidth = vc!.webView.scrollView.contentSize.width
        
        let newContentOffsetY = (secondContentSizeHeight * firstOffsetY) / firstContentSizeHeight!
        let newContentOffsetX = (secondContentSizeWidth * firstOffsetX) / firstContentSizeWidth!
        
        let newContentOffset = CGPointMake(newContentOffsetX, newContentOffsetY)
        
        vc?.webView.scrollView.setContentOffset(newContentOffset, animated: true)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        vc?.activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        vc?.activityIndicator.stopAnimating()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        vc?.activityIndicator.stopAnimating()
        
        let alert = UIAlertController(
            title: "Failed to load page",
            message: "The page failed to load. Maybe because the url was inputted incorrectly... \n\nError: \(error!)",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Okay",
                style: UIAlertActionStyle.Default,
                handler: nil
            )
        )
        presentViewController(alert, animated: true, completion: nil)
    }
}























