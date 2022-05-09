//
//  ViewController.swift
//  ToDoApp
//
//  Created by Виктор Куля on 01.05.2022.
//

import UIKit
import RealmSwift

class ToDoListViewController: UIViewController {
    
    private let mainView = ToDoListView()
    private var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? //{
//        didSet {
//            loadItems()
//        }
//    }
        
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        setupSearchBar()
        setupTableView()
        setupNavigationController()
//        loadItems()
    }
    
    private func setupSearchBar() {
//        mainView.searchBarButton.delegate = self
    }
    
    private func setupTableView() {
        mainView.itemsTableView.delegate = self
        mainView.itemsTableView.dataSource = self
        mainView.itemsTableView.register(ToDoListCell.self, forCellReuseIdentifier: "reuseIdentifierTableView")
//        mainView.itemsTableView.separatorInset = .zero
        if #available(iOS 15.0, *) {
            mainView.itemsTableView.sectionHeaderTopPadding = .zero
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
        
        navigationItem.title = "Items"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))

    }

    
    //MARK: Add new items
    @objc private func addButtonPressed() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { [self] action in
            
            //what will happen after click Add Item button
            
            if let currentCategory = self.selectedCategory {
                do {
                    try realm.write({
                        let newItem = Item()
                        newItem.title = textField.text ?? ""
                        currentCategory.items.append(newItem)
                    })
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            mainView.itemsTableView.reloadData()
            
            
            //            self.save(item: <#T##Item#>)
            //            let newItem = Item()
            //            newItem.title = textField.text ?? ""
            //            selectedCategory?.items.append(newItem)
            //            save(item: newItem)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: Model Manipulation Methods
    
//    func save(item: Item) {
//        
//        do {
//            try realm.write({
//                realm.add(item)
//            })
//        } catch {
//            print("Error saving context \(error)")
//        }
//        
//        self.mainView.itemsTableView.reloadData()
//    }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        mainView.itemsTableView.reloadData()
    }
}


//MARK: - Table View Datasource methods
extension ToDoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierTableView", for: indexPath) as! ToDoListCell
        if let item = todoItems?[indexPath.row] {
//            cell.apply(text: item.title)
            cell.textInputLabel.text = item.title

            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textInputLabel.text = "No Items Added"
        }
        
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.systemPink
        cell.selectedBackgroundView = bgColorView
        return cell
    }
}


//MARK: - Table View Delegate methods

extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}


//MARK: - SearchBar Delegate

//extension ToDoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//           loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
