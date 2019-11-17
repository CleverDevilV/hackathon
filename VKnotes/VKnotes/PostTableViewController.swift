//
//  SecondView.swift
//  Network
//
//  Created by  AnnyOG on 16.11.2019.
//  Copyright © 2019 Leonid Serebryanyy. All rights reserved.
//

import UIKit

class PostTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	var tableView = UITableView()
	
	var postsInCategories: [Note] = []
	var posts : [String: Note]? = [:]
	
	var index = 0
	var pick = 0
	
	init() {
		super.init(nibName: nil, bundle: nil)
		//    self.title = "Second"
		self.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		postsInCategories = Array(posts!.values)
		tableView.reloadData()
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = .white
		
		tableView.frame = self.view.frame
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.register(PostsTableViewCell.self, forCellReuseIdentifier: PostsTableViewCell.reuseId)
		
		tableView.tableFooterView = UIView()
		view.addSubview(tableView)
		
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
		let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editList))
		
		navigationItem.rightBarButtonItems = [addButton, editButton]
	}
	
	@objc
	func addPost() {
		
		let addTaskAllert = UIAlertController(title: "Введите ссылку на новый пост", message: nil, preferredStyle: .alert)
		
		addTaskAllert.addTextField(configurationHandler: nil)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		let okAction = UIAlertAction(title: "OK", style: .default){
			_ in
			
			let textField = addTaskAllert.textFields![0] as UITextField
			
			guard let text = textField.text else { return }
			
			let note = Note(title: text, url: "url0", isPicked: false)
			
			self.postsInCategories.append(note)
			
			let t = AppDelegate.shared.categories[self.index].notes![""]
			let noteForUpload = ["note\(self.postsInCategories.count - 1)" : note]
			let p = AppDelegate.shared.categories[self.index].notes![""]
			let posts = (AppDelegate.shared.categories[self.index].notes)?["note\(self.postsInCategories.count - 1)"]
			self.loadToServer()
		}
		
		addTaskAllert.addAction(cancelAction)
		addTaskAllert.addAction(okAction)
		present(addTaskAllert, animated: true, completion: nil)
		tableView.reloadData()
	}
	
	func loadToServer() {
		let posts = AppDelegate.shared.categories
		uploadPosts(posts) {
			result in
			if result {
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}
	}
	
	@objc
	private func editList() {
		tableView.setEditing(!tableView.isEditing, animated: true)
		navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//		loadToServer()
	}
}

//MARK: - protocols
extension PostTableViewController {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return postsInCategories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.reuseId, for: indexPath) as! PostsTableViewCell
		
		let post = postsInCategories[indexPath.row]
		
		cell.noteLabel.text = post.title
		
		cell.noteImage.isHidden = post.isPicked
		
		print("---------------")
		print("posts", postsInCategories)
		cell.accessoryType = .disclosureIndicator
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			postsInCategories.remove(at: indexPath.row)
			(AppDelegate.shared.categories[self.index].notes)!["note\(indexPath.row)"] = nil
			loadToServer()
			tableView.reloadData()
		}
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return UITableViewCell.EditingStyle.delete
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		cell?.isSelected = false
		
		let postsVC = PostWebViewController()
		postsVC.title = postsInCategories[indexPath.row].title
		postsVC.urlOfPost = postsInCategories[indexPath.row].url
		
		navigationController?.pushViewController(postsVC, animated: true)
	}
	
	func tableView(_ tableView: UITableView,
				   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
	{
		let tickAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
			print("indexPath", indexPath)
			
			let isPostPicked = self.postsInCategories[indexPath.row].isPicked ?? false
			
			if isPostPicked{
				
				self.postsInCategories[indexPath.row].isPicked = !isPostPicked
				self.pickPost(numbOfPickPost: indexPath.row)
			} else {
				self.postsInCategories[indexPath.row].isPicked = !isPostPicked
				//				print(self.postsInCategories[indexPath.row].isPicked)
				self.postsInCategories = self.postsInCategories.sorted {$0.title < $1.title}
				tableView.reloadData()
			}
			print(self.postsInCategories)
			(AppDelegate.shared.categories[self.index].notes)!["note\(indexPath.row)"] = self.postsInCategories[indexPath.row]
			
			self.loadToServer()
			
			success(true)
		})
		tickAction.image = UIImage(named: "tick")
		tickAction.backgroundColor = .purple
		
		
		
		return UISwipeActionsConfiguration(actions: [tickAction])
		
	}
	
	func pickPost(numbOfPickPost : Int) {
		
		for index in stride(from: numbOfPickPost, to: pick, by: -1) {
			let t = self.postsInCategories[index]
			self.postsInCategories[index] = self.postsInCategories[index - 1]
			self.postsInCategories[index - 1] = t
		}
		
		pick += 1
		
		tableView.reloadData()
	}
}
