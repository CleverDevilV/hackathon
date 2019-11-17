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
    let webVkAuth = WKWebView(frame:.zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        signInButton.center = CGPoint(x: view.center.x, y: view.center.y)
        view.addSubview(signInButton)
        
        webVkAuth.frame = view.frame
        if let url = URL(string: "https://oauth.vk.com/authorize?client_id=7210663&display=page&response_type=token&state=login") {
            let request = URLRequest(url: url)
            let config = WKWebViewConfiguration()
            config.userContentController.add(self, name: "setToken")
            webVkAuth.load(request)
        }
        view.addSubview(webVkAuth)

        
     AppDelegate.defaults.set(true, forKey: "loggedIn")
//        AppDelegate.shared.rootViewController.switchToMainScreen()
    }
    
    var signInButton: UIButton = {
         let signInButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
         signInButton.backgroundColor = .systemBlue
         signInButton.setTitle("Sign In", for: .normal)
         signInButton.layer.cornerRadius = 15
         signInButton.addTarget( self, action: #selector(signIn), for: .touchUpInside)
         return signInButton
     }()
     
   
    
    @objc
    func signIn(){
        AppDelegate.defaults.set(true, forKey: "loggedIn")
        AppDelegate.shared.rootViewController.switchToMainScreen()
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension EnterViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {

        if (message.name == "setToken"){
            if let token = message.body as? String{
                print("TOKEN\(token)")
            }

        }
        print("Received message from native: \(message)")
    }
}
