//
//  WebViewController.swift
//  CLG
//
//  Created by Aravind Kumar on 18/10/21.
//

import UIKit
import WebKit
class WebViewController: BaseVC,WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var webViewUrl = ""
    var webViewTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = webViewTitle
        showLoader()
        webView.navigationDelegate = self
       
      //  print(webViewUrl)
        webView.load(NSURLRequest(url: NSURL(string: webViewUrl)! as URL) as URLRequest)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    //Equivalent of shouldStartLoadWithRequest:
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {    
        var action: WKNavigationActionPolicy?
       defer {
           decisionHandler(action ?? .allow)
       }
        guard let url = navigationAction.request.url else {
            return }
        //Uncomment below code if you want to open URL in safari
        /*
         if navigationAction.navigationType == .linkActivated, url.absoluteString.hasPrefix("https://developer.apple.com/") {
         action = .cancel  // Stop in WebView
         UIApplication.shared.open(url)
         }
         */
    }
    
    //Equivalent of webViewDidStartLoad:
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    //Equivalent of didFailLoadWithError:
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    //Equivalent of webViewDidFinishLoad:
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        dismissLoader()
    }
    
}
