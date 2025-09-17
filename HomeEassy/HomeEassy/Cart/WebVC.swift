//
//  WebViewController.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import WebKit

class WebVC: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    let url: URL
    let accessToken: String?
    
    private let webView = WKWebView(frame: .zero)
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(url: URL, accessToken: String?) {
        self.url         = url
        self.accessToken = accessToken
        
        super.init(nibName: nil, bundle: nil)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func initialize() {
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        
        NSLayoutConstraint.activate([
            self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
        ])
        
        self.load(url: self.url)
    }
    
    // ----------------------------------
    //  MARK: - Request -
    //
    private func load(url: URL) {
        var request = URLRequest(url: self.url)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        if let accessToken = self.accessToken {
            request.setValue(accessToken, forHTTPHeaderField: "X-Shopify-Customer-Access-Token")
        }
        
        self.webView.load(request)
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Fail")
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print("finish to load")
        self.webView.evaluateJavaScript("{\n" + "document.getElementsByTagName(\"header\")[0].style.display = \"none\";\n" +
                                        "document.getElementsByTagName(\"footer\")[0].style.display = \"none\";\n" + "}") { (result, error) in
            debugPrint("Am here")
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        _ = shouldStartLoad(navigationAction.request)
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        _ = navigationResponse.response as? HTTPURLResponse
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?{
        if navigationAction.targetFrame == nil {
          webView.load(navigationAction.request) }
        return nil
        
    }
    
    func shouldStartLoad(_ request : URLRequest) -> Bool {
        let shouldLoad = true
        print("url--\(String(describing: request.url?.absoluteString))")
        return shouldLoad
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
    

