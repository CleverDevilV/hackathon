//
//  FirstViewControllers.swift
//  Network
//
//  Created by  AnnyOG on 16.11.2019.
//  Copyright © 2019 Leonid Serebryanyy. All rights reserved.
//


import UIKit

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var tableView = UITableView()
    
    let apiKey = "AIzaSyBAPlrsSs29-P4ogUO3D05pF0e5VRjEx9A"
    var noteLink: String {
        return "https://vknotes-5376e.firebaseio.com/0001/categories.json?avvrdd_token=AIzaSyBAPlrsSs29-P4ogUO3D05pF0e5VRjEx9A"
    }
    
    var categories:[Category] = []
    
   // var category : [String] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "First"
//        self.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        self.tabBarItem = UITabBarItem(title: "Категории", image: UIImage(named: "categories"), tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func viewWillAppear(_ animated: Bool) {
			super.viewWillAppear(animated)
			
			downloadPosts {
				posts in
				print(posts)
				self.categories = posts.sorted {$0.title < $1.title}
				AppDelegate.shared.categories = self.categories
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
			
	//        let config = URLSessionConfiguration.default
	//        let session = URLSession(configuration: config)
	//
	//        let url = URL(string: noteLink)!
	//        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
	//
	//        let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
	//            do {
	//                let posts = try JSONDecoder().decode([String:Category].self, from: data!)
	//                self.categories = Array(posts.values)
	////                for (each) in self.categories{
	////                    self.category.append(each.title)
	////                }
	//                print("\n------\n\(posts)")
	//				print(self.categories)
	//                DispatchQueue.main.async {
	//                    self.tableView.reloadData()
	//                }
	//            } catch {
	//                print("\n------\n\(error)")
	//            }
	//        })
	//        task.resume()
		}
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = .white
        
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.viewControllers[0].title = "Категории"
        
//        tableView.register(UITableViewCell.self.self, forCellReuseIdentifier: "catagory")
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseId)
        tableView.tableFooterView = UIView()
		tableView.backgroundView = UIImageView(image: UIImage(named: "back2"))
        
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editList)) // create a bat button
        navigationController?.viewControllers[0].navigationItem.leftBarButtonItem = editButton // assign button
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategory))
        navigationController?.viewControllers[0].navigationItem.rightBarButtonItem = addButton
        
    }
    
    @objc
    private func editList() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    @objc
    func addCategory() {
        
        let addTaskAllert = UIAlertController(title: "Введите название новой ", message: nil, preferredStyle: .alert)
        
        addTaskAllert.addTextField(configurationHandler: nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default){
            _ in
            
            let textField = addTaskAllert.textFields![0] as UITextField
            
            guard let text = textField.text else {return}
			
			AppDelegate.shared.categories.append(Category(title: text, notes: ["note0": Note(title: "tite0", url: "url0"), "note1": Note(title: "tite1", url: "url1") ]))
            
			self.categories.append(Category(title: text, notes: ["note0": Note(title: "tite0", url: "url0"), "note1": Note(title: "tite1", url: "url1") ]))
			print(self.categories.count)
			
			uploadPosts(self.categories) {
				result in
				if result {
					DispatchQueue.main.async {
						self.tableView.reloadData()
					}
				}
			}
			
         //   self.categories.append(newCategory)
//            let dataToLoad = ["Cat":newCategory]
//            let config = URLSessionConfiguration.default
//            let session = URLSession(configuration: config)
//
//            let url = URL(string: self.noteLink)!
//            var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
//            urlRequest.httpMethod = "PUT"
//            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            urlRequest.httpBody = try! JSONEncoder().encode(dataToLoad)
//
//            let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
//                do {
//                    let posts = String(data: data!, encoding: .utf8)
//                    print("\n------\n\(posts)")
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//            }).resume()
            
            self.tableView.reloadData()
        }
        
        addTaskAllert.addAction(cancelAction)
        addTaskAllert.addAction(okAction)
        
        present(addTaskAllert, animated: true, completion: nil)
        
        
        
        
        tableView.reloadData()
    }
    
    
}

//MARK: - Protocols
extension CategoriesViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories.count
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseId, for: indexPath) as! CategoryTableViewCell
        
        cell.noteLabel.text = categories[indexPath.row].title
//           cell.noteImage.image = UIImage(named: "tick")
        cell.noteImage.isHidden = true
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        let postsVC = PostTableViewController()
        let oneCategory = categories[indexPath.row].title
		postsVC.posts = categories[indexPath.row].notes ?? [:]
		postsVC.index = indexPath.row
        postsVC.title = oneCategory
        
        navigationController?.pushViewController(postsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            categories.remove(at: indexPath.row)
			AppDelegate.shared.categories.remove(at: indexPath.row)
			uploadPosts(categories) {
				result in
				if result {
					DispatchQueue.main.async {
						self.tableView.reloadData()
					}
				}
			}
            tableView.reloadData()
        }
    }
        
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
}
