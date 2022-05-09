//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Виктор Куля on 06.05.2022.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {

    private let mainView = CategoryView()
    private var categories: Results<Category>?
    let realm = try! Realm()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationController()
        loadCategories()
    }
    
    private func setupTableView() {
        mainView.categoryTableView.delegate = self
        mainView.categoryTableView.dataSource = self
        mainView.categoryTableView.register(CategoryCell.self, forCellReuseIdentifier: "reuseIdentifierTableView")
//        mainView.categoryTableView.separatorInset = .zero
        if #available(iOS 15.0, *) {
            mainView.categoryTableView.sectionHeaderTopPadding = .zero
        }
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.backgroundColor = UIColor.systemBlue
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        }
        
        navigationItem.title = "To Do List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
    }

    
    //MARK: - Data Manipulation methods
    
    func save(category: Category) {
        
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving category \(error)")
        }
        
        mainView.categoryTableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        mainView.categoryTableView.reloadData()
    }
    
    //MARK: - Add new Categories
    
    @objc private func addButtonPressed() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category()
            newCategory.name = textField.text ?? ""
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
}


extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - TableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        categories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierTableView", for: indexPath) as! CategoryCell
        let category = categories?[indexPath.row]
        cell.applyCategory(text: category?.name ?? "No Categories Added yet")
        
        return cell
    }
    
    //MARK: - TableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ToDoListViewController()
        navigationController?.pushViewController(vc, animated: true)
        mainView.categoryTableView.deselectRow(at: indexPath, animated: true)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            vc.selectedCategory = categories?[indexPath.row]
        }
    }

}
