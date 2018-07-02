//
//  Category.swift
//  Todoey2
//
//  Created by Ashwani  Agrawal on 01/07/18.
//  Copyright © 2018 Ashwani  Agrawal. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {

    @objc dynamic var name = ""
    var items = List<Item>()
    
}
