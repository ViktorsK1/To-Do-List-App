//
//  CategoryPresenter.swift
//  ToDoApp
//
//  Created by Виктор Куля on 25.05.2022.
//

import Foundation
import RealmSwift

//MARK: - CategoryPresenterDelegate 
protocol CategoryPresenterDelegate: AnyObject {
    init(view: CategoryViewDelegate)
    func viewDidLoad()
    func addButtonPressed(with name: String)
    func deleteSelected(for index: Int)
}

class CategoryPresenter: CategoryPresenterDelegate {
    //MARK: - Properties
    weak var viewDelegate: CategoryViewDelegate?
    
    private var categories: Results<Category>?
    private var realm = try! Realm()
    //MARK: - Initializers
    required init(view: CategoryViewDelegate) {
        self.viewDelegate = view
    }
    //MARK: - Private methods
    private func retrieveCategories() {
        print("Presenter retrieves an Category objects from the Realm Database.")
        self.categories = realm.objects(Category.self)
        
        let names: [String]? = self.categories?
            .compactMap({ $0.name })
        viewDelegate?.onCategoryRetrieval(names: names ?? [])
    }
    
    private func addCategory(name: String) {
        print("Presenter adds an Category object to the Realm Database.")
        let category = Category(name: name)
        do {
            try self.realm.write {
                self.realm.add(category)
            }
        } catch {
            viewDelegate?.onCategoryAddFailure(message: error.localizedDescription)
        }
        viewDelegate?.onCategoryAddSuccess(name: category.name)
    }
    
    private func deleteCategory(at index: Int) {
        print("Presenter deletes an Category object from the Realm Database.")
        if let categories = categories {
            do {
                try self.realm.write {
                    self.realm.delete(categories[index])
                }
            } catch {
                print("Couldn't delete a category")
            }
            viewDelegate?.onCategoryDeletion(index: index)
        }
    }
    //MARK: - CategoryPresenterDelegate methods
    func viewDidLoad() {
        print("View notifies the Presenter that it has loaded")
        retrieveCategories()
    }
    
    func addButtonPressed(with name: String) {
        print("View notifies thr Presenter that an add button was pressed.")
        addCategory(name: name)
    }
    
    func deleteSelected(for index: Int) {
        print("View notifies the Presenter that a delete action was performed.")
        deleteCategory(at: index)
    }
}
