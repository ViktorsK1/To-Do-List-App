//
//  RealmManager.swift
//  ToDoApp
//
//  Created by Виктор Куля on 24.05.2022.
//

import Foundation
import RealmSwift

class RealmManager: NSObject {
    
//    static let shared = RealmManager()
    
//    private override init() {}
    
    //Потоки могут меняться, используя здесь вычисляемые свойства, можно изменить поток, в котором находится область, в любое время.
    var realm: Realm {
        return try! Realm()
    }
    
//    func saveCategoryModel(model: CategoryModel) {
//
//        try! realm.write {
//            realm.add(model)
//        }
//    }
    
    func createModel <T> (model: T) {
        do {
            try realm.write({
                realm.add(model as! Object)
            })
        } catch {
            print("Error adding model \(error)")
        }
    }
    
//    func loadCategoryModel(model: CategoryModel) {
//
//        //        categoryModel = realm.objects(CategoryModel.self)
//        realm.objects(CategoryModel.self)
//
//    }
    
    func readModel <T> (model: T.Type, filter: String? = nil) -> [T] {
        
        var results: Results<Object>
        
        if filter != nil {
            
            results = realm.objects((model as! Object.Type).self).filter(filter!)
        } else {
            
            results = realm.objects((model as! Object.Type).self)
        }
        
        guard results.count > 0 else { return [] }
        var modelArray = [T]()
        for model in results {
            modelArray.append(model as! T)
        }
        
        return modelArray
    }
    
    //Модель, для которой вызывается этот метод, должна иметь первичный ключ.
    func updateModel <T> (model: T) {
        do {
            try realm.write({
                realm.add(model as! Object, update: Realm.UpdatePolicy.all)
            })
        } catch {
            print("Error updating model \(error)")
        }
    }
    
    
    func deleteModel <T> (model: T) {
        do {
            try realm.write({
                realm.delete(model as! Object)
            })
        } catch {
            print("Error deleting model \(error)")
        }
    }
    
    func deleteModelList <T> (model: T) {
        do {
            try realm.write({
                realm.delete(realm.objects((T.self as! Object.Type).self))
            })
        } catch {
            print("Error deleting model list \(error)")
        }
    }
    
}
