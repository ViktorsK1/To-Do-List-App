//
//  ItemPresenter.swift
//  ToDoApp
//
//  Created by Виктор Куля on 08.06.2022.
//

import Foundation
import RealmSwift

protocol ItemPresenterDelegate: AnyObject {
    init(view: ItemViewDelegate)
    func viewDidLoad()
    func addButtonPressed(with title: String)
    func deleteSelected(for indexTitle: Int)
}

class ItemPresenter: ItemPresenterDelegate {

    //MARK: - Properties
    weak var viewDelegate: ItemViewDelegate?
    
    private var items: Results<Item>?
    var selectedCategory: Category?
    private var realm = try! Realm()
    
    //MARK: - Initializers
    required init(view: ItemViewDelegate) {
        self.viewDelegate = view
    }
    
    //MARK: - Private methods
    private func retrieveItem() {
        print("Presenter retrieves an Item objects from the Realm Database.")
        self.items = realm.objects(Item.self)
//        self.items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        let titles: [String]? = self.items?
            .compactMap({ $0.title })
        viewDelegate?.onItemRetrieval(titles: titles ?? [])
        
        self.items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    private func addItem(title: String) {
        print("Presenter adds an Item object to the Realm Database.")
        let item = Item(title: title)
        do {
            try self.realm.write {
                self.realm.add(item)
            }
        } catch {
            viewDelegate?.onItemAddFailure(message: error.localizedDescription)
        }
        viewDelegate?.onItemAddSuccess(title: item.title)
    }
    
    private func deleteItem(at index: Int) {
        print("Presenter deletes an Item object from the Realm Database.")
        if let items = items {
            do {
                try self.realm.write {
                    self.realm.delete(items[index])
                }
            } catch {
                print("Couldn't delete a category")
            }
            viewDelegate?.onItemDeletion(indexTitle: index)
        }
    }
    
    //MARK: - ItemPresenterDelegate
    func viewDidLoad() {
        print("View notifies the Presenter that it has loaded")
        retrieveItem()
    }
    
    func addButtonPressed(with title: String) {
        print("View notifies thr Presenter that an add button was pressed.")
        addItem(title: title)
    }
    
    func deleteSelected(for indexTitle: Int) {
        print("View notifies the Presenter that a delete action was performed.")
        deleteItem(at: indexTitle)
    }
}
