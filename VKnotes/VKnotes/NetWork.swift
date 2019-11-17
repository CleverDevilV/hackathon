//
//  NetWork.swift
//  VKnotes
//
//  Created by Дарья Витер on 17/11/2019.
//  Copyright © 2019 Fems. All rights reserved.
//

import Foundation

func downloadPosts(_ completionHandler: @escaping (_ genres: [Category]) -> ()) {
	
	let apiKey = "AIzaSyBAPlrsSs29-P4ogUO3D05pF0e5VRjEx9A"
    var noteLink: String {
        return "https://vknotes-5376e.firebaseio.com/0001/categories.json?avvrdd_token=AIzaSyBAPlrsSs29-P4ogUO3D05pF0e5VRjEx9A"
    }
	
	let config = URLSessionConfiguration.default
	let session = URLSession(configuration: config)
	
	let url = URL(string: noteLink)!
	let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
	
	let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
		do {
			let jsonText = try? JSONSerialization.jsonObject(with: data!, options: [])
			print(jsonText)
			let posts = try JSONDecoder().decode([String:Category].self, from: data!)
			print(posts)
			let postsFromFirebase = Array(posts.values)
//			AppDelegate.shared.categories = Array(posts.values)
//			self.categories = Array(posts.values)
			//                for (each) in self.categories{
			//                    self.category.append(each.title)
			//                }
			print("\n------\n\(posts)")
//			DispatchQueue.main.async {
//				self.tableView.reloadData()
//			}
			print(postsFromFirebase)
			completionHandler(postsFromFirebase)
		} catch {
			print("\n------\n\(error)")
			completionHandler([])
		}
	})
	task.resume()
}

func uploadPosts(_ posts: [Category], _ completionHandler: @escaping (_ genres: Bool) -> ()) {
	
	let apiKey = "AIzaSyBAPlrsSs29-P4ogUO3D05pF0e5VRjEx9A"
    var noteLink: String {
        return "https://vknotes-5376e.firebaseio.com/0001/categories.json?avvrdd_token=AIzaSyBAPlrsSs29-P4ogUO3D05pF0e5VRjEx9A"
    }
	
	var dataToLoad : [String : Category] = [:]
		for index in 0 ..< posts.count {
			dataToLoad["category\(index)"] = posts[index]
		}
	print(dataToLoad)
	//	let dataToLoad = posts
	let config = URLSessionConfiguration.default
	let session = URLSession(configuration: config)
	
	let url = URL(string: noteLink)!
	var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
	urlRequest.httpMethod = "PUT"
	urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
	urlRequest.httpBody = try! JSONEncoder().encode(dataToLoad)
	completionHandler(true)
	
	let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
		do {
			let posts = String(data: data!, encoding: .utf8)
			print("\n------\n\(posts)")
		}
	}).resume()
}
