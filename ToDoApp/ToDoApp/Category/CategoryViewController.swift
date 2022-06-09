//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Виктор Куля on 06.05.2022.
//

import UIKit
//import RealmSwift

protocol CategoryViewDelegate: AnyObject {
    func onCategoryRetrieval(names: [String])
    func onCategoryAddSuccess(name: String)
    func onCategoryAddFailure(message: String)
    func onCategoryDeletion(index: Int)
}

class CategoryViewController: UIViewController {

    //MARK: - Properties
    private let mainView = CategoryView()
    var names: [String] = []
    
    private lazy var presenterDelegate: CategoryPresenterDelegate? = CategoryPresenter(view: self)

    //MARK: - Lifrcycle Methods
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationController()
        
        presenterDelegate?.viewDidLoad()
    }
    
    //MARK: - TableView Setup
    private func setupTableView() {
        mainView.categoryTableView.delegate = self
        mainView.categoryTableView.dataSource = self
        mainView.categoryTableView.register(CategoryCell.self, forCellReuseIdentifier: "reuseIdentifierTableView")
        mainView.categoryTableView.separatorInset = .zero
        if #available(iOS 15.0, *) {
            mainView.categoryTableView.sectionHeaderTopPadding = .zero
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
        
        navigationItem.title = "Category"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    //MARK: - Actions
    @objc private func addButtonPressed() {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let add = UIAlertAction(title: "Add Category", style: .default) { [weak self] _ in
            if let name = alert.textFields?.first!.text, !name.isEmpty {
                // presenter method
                self?.presenterDelegate?.addButtonPressed(with: name)
            }
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Add a new category"
        }
        alert.addAction(cancel)
        alert.addAction(add)
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - TableViewDataSource methods
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainView.categoryTableView.isHidden = self.names.isEmpty
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierTableView", for: indexPath) as! CategoryCell
        cell.categoryLabel.text = names[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenterDelegate?.deleteSelected(for: indexPath.row)
        }
    }
}

//MARK: - TableViewDelegate method
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ToDoListViewController()
        navigationController?.pushViewController(vc, animated: true)
        mainView.categoryTableView.deselectRow(at: indexPath, animated: true)
        
//        if let indexPath = tableView.indexPathForSelectedRow {
//            vc.selectedCategory = categoryModel?[indexPath.row]
//        }
    }
}

//MARK: CategoryViewDelegate 
extension CategoryViewController: CategoryViewDelegate {
    
    func onCategoryRetrieval(names: [String]) {
        print("View recives thr result from the Presenter.")
        self.names = names
        self.mainView.categoryTableView.reloadData()
    }
    
    func onCategoryAddSuccess(name: String) {
        print("View recieves the result from the Presenter.")
        self.names.append(name)
        self.mainView.categoryTableView.reloadData()
    }
    
    func onCategoryAddFailure(message: String) {
        print("View recieves a failure result from the Presenter: \(message)")
    }
    
    func onCategoryDeletion(index: Int) {
        print("View recieves a deletion result from the Presenter")
        self.names.remove(at: index)
        self.mainView.categoryTableView.reloadData()
    }
}
