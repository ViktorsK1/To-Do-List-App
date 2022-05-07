//
//  Category.swift
//  ToDoApp
//
//  Created by Виктор Куля on 07.05.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
