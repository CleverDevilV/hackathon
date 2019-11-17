//
//  RegistrationViewController.swift
//  VKnotes
//
//  Created by Onie on 16.11.2019.
//  Copyright © 2019 Fems. All rights reserved.
//
import WebKit
import UIKit

class EnterViewController: UIViewController, WKNavigationDelegate {
    var webView:WKWebView!
    var loader:UIActivityIndicatorView!
    let tabbar = UITabBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        signInButton.center = CGPoint(x: view.center.x, y: view.center.y)
//        view.addSubview(signInButton)
       
        
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.frame = view.frame
        
        let request = URLRequest(url: URL(string: "https://oauth.vk.com/authorize?client_id=7210663&display=page&response_type=token&state=login")!)
        
        webView.load(request)
        
        view.addSubview(webView)
        
       
        
//
//
//        AppDelegate.defaults.set(true, forKey: "loggedIn")
//        AppDelegate.shared.rootViewController.switchToMainScreen()
    }
    
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        print(navigationAction.request.allHTTPHeaderFields)
//    }
   
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let text = webView.url?.absoluteString{
            print("------------------\(text)----------------")
            if let token = text.slice(from: "=", to: "&") {
                print(token)
                if token.count > 10 {
                    let newNoteVC = CategoriesViewController()
                    navigationController?.pushViewController(newNoteVC, animated: true)
                }
            }
        }
        webView.goBack()
        
        
    }
    

//    var signInButton: UIButton = {
//         let signInButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//         signInButton.backgroundColor = .systemBlue
//         signInButton.setTitle("Sign In", for: .normal)
//         signInButton.layer.cornerRadius = 15
//         signInButton.addTarget( self, action: #selector(signIn), for: .touchUpInside)
//         return signInButton
//     }()
    
   
    
//    @objc
//    func signIn(){
//        AppDelegate.defaults.set(true, forKey: "loggedIn")
//        AppDelegate.shared.rootViewController.switchToMainScreen()
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension EnterViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {

        if (message.name == "setToken"){
            if let token = message.body as? String{
                 AppDelegate.defaults.set(true, forKey: "loggedIn")
                print("TOKEN\(token)")
            }

        }
        print("Received message from native: \(message)")
    }
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
