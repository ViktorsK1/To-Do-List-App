//
//  ItemViewController.swift
//  ToDoApp
//
//  Created by Виктор Куля on 08.06.2022.
//

import UIKit


protocol ItemViewDelegate: AnyObject {
    func onItemRetrieval(titles: [String])
    func onItemAddSuccess(title: String)
    func onItemAddFailure(message: String)
    func onItemDeletion(indexTitle: Int)
}
class ItemViewController: UIViewController {

    //MARK: - Properties
    private let mainView = ToDoListView()
    var titles: [String] = []
    var doneTitles: [Bool] = []
    private lazy var presenterDelegate = ItemPresenter(view: self)
    //: ItemPresenterDelegate?
    //MARK: - Lifecycle Methods
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationController()
        setupSearchBar()
        presenterDelegate.viewDidLoad()
    }

    
    //MARK: - TableView Setup
    private func setupTableView() {
        mainView.itemsTableView.delegate = self
        mainView.itemsTableView.dataSource = self
        mainView.itemsTableView.register(ToDoListCell.self, forCellReuseIdentifier: "reuseIdentifierTableView")
//        mainView.itemsTableView.separatorInset = .zero
        if #available(iOS 15.0, *) {
            mainView.itemsTableView.sectionHeaderTopPadding = .zero
        }
    }
    
    //MARK: - NavigationController Setup
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
    
    //MARK: - SearchBar Setup
    private func setupSearchBar() {
//        mainView.searchBarButton.delegate = self
    }
    
    //MARK: - Add new items ||||Actions
    @objc private func addButtonPressed() {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let add = UIAlertAction(title: "Add Item", style: .default) { [weak self] _ in
            
            //what will happen after click Add Item button
                if let title = alert.textFields?.first?.text, !title.isEmpty {
                    // presenter method
                    self?.presenterDelegate.addButtonPressed(with: title)
                }
            }
        
        alert.addTextField { textField in
            textField.placeholder = "Add a new item"
        }
        alert.addAction(cancel)
        alert.addAction(add)
        
        self.present(alert, animated: true, completion: nil)
    }
}
    
//    func loadItems() {
//
//        titles = self.presenterDelegate.selectedCategory?.items.sorted(by: "title", ascending: true)
//        mainView.itemsTableView.reloadData()
//    }

//}

//MARK: - TableViewDataSource methods
extension ItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainView.itemsTableView.isHidden = self.titles.isEmpty
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierTableView", for: indexPath) as! ToDoListCell
        cell.textInputLabel.text = titles[indexPath.row]
//        if titles[indexPath.row] {
//            cell.textInputLabel.text = item.title
//
//            cell.accessoryType = item.done ? .checkmark : .none
//        } else {
//            cell.textInputLabel.text = "No Items Added"
//        }
        
        
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

//MARK: - TableViewDelegate methods
extension ItemViewController: UITableViewDelegate {
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

//MARK: ItemViewDelegate
extension ItemViewController: ItemViewDelegate {
    func onItemRetrieval(titles: [String]) {
        print("View recives the result from the Presenter.")
        self.titles = titles
        self.mainView.itemsTableView.reloadData()
    }

    func onItemAddSuccess(title: String) {
        print("View recieves the result from the Presenter.")
        self.titles.append(title)
        self.mainView.itemsTableView.reloadData()
    }
    
    func onItemAddFailure(message: String) {
        print("View recieves a failure result from the Presenter: \(message)")
    }
    
    func onItemDeletion(indexTitle: Int) {
        print("View recieves a deletion result from the Presenter")
        self.titles.remove(at: indexTitle)
        self.mainView.itemsTableView.reloadData()
    }
}
