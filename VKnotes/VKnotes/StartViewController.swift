//
//  StartViewController.swift
//  VKnotes
//
//  Created by Onie on 16.11.2019.
//  Copyright © 2019 Fems. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		
		helloLabel.center = CGPoint(x: view.center.x, y: view.center.y - 50)
		view.addSubview(helloLabel)
		
		startButton.center = CGPoint(x: view.center.x, y: view.center.y + 50)
		view.addSubview(startButton)
	}
	
	var helloLabel: UILabel = {
		let helloLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
		helloLabel.text = "Добро пожаловать!"
		helloLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 25)
		helloLabel.numberOfLines = 2
		helloLabel.textAlignment = .center
		return helloLabel
	}()
	
	var startButton: UIButton = {
		let startButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
		startButton.backgroundColor = .systemBlue
		startButton.setTitle("Начать", for: .normal)
		startButton.layer.cornerRadius = 15
		startButton.addTarget( self, action: #selector(start(_:)), for: .touchUpInside)
		return startButton
	}()
	
	@objc
	func start(_ sender: UIButton){
		
		UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
			self.startButton.layer.opacity = 0
			self.helloLabel.layer.opacity = 0
		}, completion: {
			_ in
			if AppDelegate.defaults.bool(forKey: "loggedIn"){
				AppDelegate.shared.rootViewController.switchToMainScreen()
			} else {
				AppDelegate.shared.rootViewController.switchToLogout()
			}
		})
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
}
