//
//  Item.swift
//  Todoey2
//
//  Created by Ashwani  Agrawal on 01/07/18.
//  Copyright © 2018 Ashwani  Agrawal. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var isChecked = false
    @objc dynamic var value = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    @objc dynamic var date: Date?
}
