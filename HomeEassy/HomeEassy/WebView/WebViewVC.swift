import Foundation
import UIKit
import WebKit

protocol paymentDelegate{
    func succussFullyPaid()
}

class WebViewVC: UIViewController{
    @IBOutlet weak var webView : WKWebView?
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView?
    var urlString : String?
    var checkOut:CheckoutViewModel?
    var payment:paymentDelegate?
    override func viewDidLoad(){
        super.viewDidLoad()
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        if var urlString = urlString {
            urlString = urlString + "?headless=1"
            if let url = URL(string:urlString) {
                let urlRequest = NSMutableURLRequest(url:url)
                if let accessToken = AccountController.shared.accessToken,let _=checkOut {
                    urlRequest.setValue(accessToken, forHTTPHeaderField: "X-Shopify-Customer-Access-Token")
                }
                DispatchQueue.main.async {
                    self.webView?.load(urlRequest as URLRequest)
                    print("\(urlRequest.httpBody)\n \(urlRequest.allHTTPHeaderFields)")
                }}}
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//                if self.navigationController?.viewControllers.count == 1 {
//                    let barButton = UIBarButtonItem(image: UIImage(contentsOfFile: "closeIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButton))
//                    self.navigationItem.leftBarButtonItems = [barButton]
//                    self.navigationItem.backBarButtonItem = nil
 //   }
}
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
//    @IBAction override func backButton() {
//        if let checkOut=checkOut{
//            super.backButton()
//        }
//        else{  super.backButton()  }
//    }
    
}

extension WebViewVC : WKNavigationDelegate,WKUIDelegate {
  private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
    print(error.localizedDescription)
    activityIndicator?.stopAnimating()
  }
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    print("Fail")
    activityIndicator?.stopAnimating()
  }
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    print("Strat to load")
    activityIndicator?.startAnimating()
  }
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
  print("finish to load")
  activityIndicator?.stopAnimating()
  DispatchQueue.main.async {
    self.webView?.evaluateJavaScript("{\n" + "document.getElementsByTagName(\"header\")[0].style.display = \"none\";\n" +
      "document.getElementsByTagName(\"footer\")[0].style.display = \"none\";\n" + "}") { (result, error) in
        debugPrint("Am here")
        self.activityIndicator?.stopAnimating()
    }}}

  
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
  }}

extension WebViewVC {
  func shouldStartLoad(_ request : URLRequest) -> Bool {
    let shouldLoad = true
    print("url--\(String(describing: request.url?.absoluteString))")
    if let urlString = request.url?.absoluteString,urlString.hasSuffix("/thank_you"){
        self.dismiss(animated: true){
            CartController.shared.removeAllItem()
            self.payment?.succussFullyPaid()
        }
        //navigationController?.pushViewController(vc!, animated: true)
    }
    return shouldLoad
  }
  func getQueryStringParameter(url: String, param: String) -> String? {
    guard let url = URLComponents(string: url) else { return nil }
    return url.queryItems?.first(where: { $0.name == param })?.value
  }
}

extension WebViewVC : NoInternetHandler {
  func retryAction(object : Any?) {
   
  }
}

