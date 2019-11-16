//
//  ViewController.swift
//  VKnotes
//
//  Created by Onie on 16.11.2019.
//  Copyright © 2019 Fems. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    

      private var current: UIViewController
        
        init() {
            self.current = StartViewController()
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            addChild(current)
            current.view.frame = view.bounds
            view.addSubview(current.view)
            current.didMove(toParent: self)
            
        }
        

        func switchToMainScreen() {
            let mainViewController = BaseTabBarController()
            animateFadeTransition(to: mainViewController)
        }

        func switchToLogout() {
            let loginViewController = EnterViewController()
            let logoutScreen = UINavigationController(rootViewController: loginViewController)
            animateDismissTransition(to: logoutScreen)
        }

        private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
            current.willMove(toParent: nil)
            addChild(new)

            transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            }) { completed in
                self.current.removeFromParent()
                new.didMove(toParent: self)
                self.current = new
                completion?()
            }
        }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        new.view.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
}
