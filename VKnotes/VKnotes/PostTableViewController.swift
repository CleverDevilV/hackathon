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
    
    var postsInCategories = PostModel.shared
    
//    var posts : [String] = []

    var pick = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        //    self.title = "Second"
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsInCategories.posts = [Post(text: "first", image: nil, isPicked: false)]
        
        self.view.backgroundColor = .white
        
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.register(UITableViewCell.self.self, forCellReuseIdentifier: "posts")
        tableView.register(PostsTableViewCell.self, forCellReuseIdentifier: PostsTableViewCell.reuseId)
        
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
        
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
            
            guard let text = textField.text else {
                 return
            }
            
            let post = Post(text: textField.text!, image: nil, isPicked: false)
            
            self.postsInCategories.posts.append(post)
//            self.posts.append(text)
                                    
            self.tableView.reloadData()
        }
        
        addTaskAllert.addAction(cancelAction)
        addTaskAllert.addAction(okAction)
        present(addTaskAllert, animated: true, completion: nil)
        tableView.reloadData()
    }
    
    @objc
    private func editList() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }
}

//MARK: - protocols
extension PostTableViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsInCategories.posts.count//posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.reuseId, for: indexPath) as! PostsTableViewCell
        
        let post = postsInCategories.posts[indexPath.row]
        
        cell.noteLabel.text = post.text //posts[indexPath.row]
        print("cell indexPath: ", indexPath)
        cell.noteImage.isHidden = !post.isPicked
		
		print("---------------")
		print("posts", postsInCategories.posts)
		cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
			postsInCategories.posts.remove(at: indexPath.row)
            
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
		postsVC.title = postsInCategories.posts[indexPath.row].text
		
		navigationController?.pushViewController(postsVC, animated: true)
	}
    
   func tableView(_ tableView: UITableView,
				   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
	{
		let tickAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
			print("indexPath", indexPath)
			
			let posts = self.postsInCategories.posts
			if !self.postsInCategories.posts[indexPath.row].isPicked {
				
				self.postsInCategories.posts[indexPath.row].isPicked = !self.postsInCategories.posts[indexPath.row].isPicked
				
				self.pickPost(numbOfPickPost: indexPath.row)
			} else {
				let t = self.postsInCategories.posts[indexPath.row].isPicked
				print(t)
				self.postsInCategories.posts[indexPath.row].isPicked = !self.postsInCategories.posts[indexPath.row].isPicked
				print(self.postsInCategories.posts[indexPath.row].isPicked)
				self.postsInCategories.posts = self.postsInCategories.posts.sorted {$0.text < $1.text}
				tableView.reloadData()
			}
			
			success(true)
		})
		tickAction.image = UIImage(named: "tick")
		tickAction.backgroundColor = .purple
		
		
		
		return UISwipeActionsConfiguration(actions: [tickAction])
		
	}
	
	func pickPost(numbOfPickPost : Int) {
		
		for index in stride(from: numbOfPickPost, to: pick, by: -1) {
			let t = self.postsInCategories.posts[index]
			self.postsInCategories.posts[index] = self.postsInCategories.posts[index - 1]
			self.postsInCategories.posts[index - 1] = t
		}
		
		pick += 1
		
		tableView.reloadData()
	}
}
