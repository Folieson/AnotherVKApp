//
//  LoginFormWebViewController.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 28/04/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit
import WebKit
import KeychainAccess

class Session {
    static let instance = Session()
    private init(){}
    
    var token = ""
    var userId = "0"
    var userName = ""
}

class LoginFormWebViewController: UIViewController{
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    let keychain = Keychain(service: "new.AnotherVKApp")
    let session = Session.instance
    
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
        
        if let token = params["access_token"] {
            do {
                try keychain.set(token, key: "token")
                print("token setted")
            }
            catch let error {
                print(error)
            }
            self.session.token = token
            if let user_id = params["user_id"]{
                do {
                    try keychain.set(user_id, key: "userId")
                    print("userId setted")
                }
                catch let error {
                    print(error)
                }
                self.session.userId = user_id
            }
            let vkServices = VKServices<User>()
            vkServices.loadUser { users in
                print("getting username")
                if let user = users.first {
                    print("username = \(user.fullName)")
                    let userDefaults = UserDefaults.standard
                    let session = Session.instance
                    userDefaults.set(user.fullName, forKey: "userName")
                    session.userName = user.fullName
                }
            }
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        decisionHandler(.cancel)
    }
}
