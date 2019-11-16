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
    
    var category : [String] = ["first", "second"]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "First"
//        self.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        self.tabBarItem = UITabBarItem(title: "Категории", image: UIImage(named: "categories"), tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.viewControllers[0].title = "Категории"
        
//        tableView.register(UITableViewCell.self.self, forCellReuseIdentifier: "catagory")
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseId)
        tableView.tableFooterView = UIView()
        
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
            
            guard let text = textField.text else {
                 return
            }
            
            self.category.append(text)
                                    
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
            return category.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseId, for: indexPath) as! CategoryTableViewCell
            
            cell.noteLabel.text = category[indexPath.row]
//            cell.noteImage.image = UIImage(named: "tick")
            cell.noteImage.isHidden = true
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.isSelected = false
            
            let postsVC = PostTableViewController()
            let oneCategory = category[indexPath.row]
            postsVC.title = oneCategory
            
            navigationController?.pushViewController(postsVC, animated: true)
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                category.remove(at: indexPath.row)
                
                tableView.reloadData()
            }
        }
        
        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return UITableViewCell.EditingStyle.delete
        }
}
