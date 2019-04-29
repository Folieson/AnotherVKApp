//
//  LoginFormWebViewController.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 28/04/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit
//import Alamofire
import WebKit

class Session {
    static let instance = Session()
    private init(){}
    
    var token = ""
    var userId = 0
}

class LoginFormWebViewController: UIViewController{
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6964513"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.95")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
        // Do any additional setup after loading the view.
    }
}

extension LoginFormWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        //let token = params["access_token"]
        
        let session = Session.instance
        if let token = params["access_token"] {
            session.token = token
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        print(session.token)
        
        
        decisionHandler(.cancel)
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        let session = Session.instance
//        return session.token != "" ? true : false
//    }
}
