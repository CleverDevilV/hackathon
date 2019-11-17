//
//  PostWebViewController.swift
//  VKnotes
//
//  Created by Дарья Витер on 16/11/2019.
//  Copyright © 2019 Fems. All rights reserved.
//

import UIKit
import WebKit

class PostWebViewController: UIViewController, WKNavigationDelegate {
	let webVkAuth = WKWebView(frame:.zero)
	var urlOfPost = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		webVkAuth.frame = view.frame
		view.addSubview(webVkAuth)
		
		if let url = URL(string: urlOfPost) {
			let request = URLRequest(url: url)
			webVkAuth.load(request)
		}
	}
}
