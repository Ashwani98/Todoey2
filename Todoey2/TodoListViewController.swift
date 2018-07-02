//
//  ViewController.swift
//  Todoey
//
//  Created by Ashwani  Agrawal on 25/06/18.
//  Copyright © 2018 Ashwani  Agrawal. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData


class TodoListViewController: UITableViewController, UISearchBarDelegate {
    
    let realm = try! Realm()
    var items: Results<Item>?
   // var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
 //   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category? { didSet{ getData() }}
    
    
    
 //   let longPress = UILongPressGestureRecognizer()
    let searchBar = UISearchBar()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
//        longPress.delegate = self
        
//        longPress.numberOfTouchesRequired = 1
//        longPress.allowableMovement = 5.0
//        longPress.minimumPressDuration = 1
//        longPress.numberOfTapsRequired = 1
//        tableView.addGestureRecognizer(longPress)
       // print(path!)
        getData()
        tableView.separatorStyle = .none
        }
    
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Item", message: "enter the item", preferredStyle: .alert)
        let action =  UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                try! self.realm.write {
                    let newItem = Item()
                    newItem.value = textField.text!
                    newItem.date = Date()
                    currentCategory.items.append(newItem)
           // item.parentCategory = self.selectedCategory
           // self.items.append(item)
            
                    self.realm.add(newItem)
                }
            }
            
            self.tableView.reloadData()
            
            
          //  print("333")
        }
        
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "enter item"
            textField = alertTextField
            //print("1" + textField.text!)
        }
        //print("2" + textField.text!)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
    
    
    func getData(){
        items = selectedCategory?.items.sorted(byKeyPath: "value", ascending: true)
        tableView.reloadData()
    }
    

//    func saveData(){
//        do{
//            try context.save()
//        }
//        catch{
//            print("errors are \(error)")
//        }
        
    
//    }
    
//    func getData(with request: NSFetchRequest<Item> = Item.fetchRequest(),_ predicate: NSPredicate? = nil){
//        let mustPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let check = predicate{
//            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [check, mustPredicate])
//            request.predicate = compoundPredicate
//        }
//        else{
//            request.predicate = mustPredicate
//        }
//
//
//        do{
//            itemArray = try context.fetch(request)
//        }
//        catch{
//            print(error)
//        }
//        tableView.reloadData()
//
//    }
//
    //MARK: table view appear
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = items?[indexPath.row]{
            
            cell.textLabel?.text = item.value

            cell.accessoryType = item.isChecked ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "no items"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            try! realm.write {
                item.isChecked = !item.isChecked
            }
        }
        //items[indexPath.row].isChecked = !items[indexPath.row].isChecked
        //saveData()
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    
    //MARK: search bar

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        request.predicate = NSPredicate(format: "value CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
//
//        getData(with: request)
//
//
//    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count != 0{
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//            let predicate = NSPredicate(format: "value CONTAINS[cd] %@", searchBar.text!)
//            request.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
//
//            getData(with: request, predicate)
//        }
//        else{
//            getData()
//            DispatchQueue.main.async {
//                 searchBar.resignFirstResponder()
//            }
//
//        }
//
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            getData()
        }else{
            items = items?.filter("value CONTAINS[cd] %@", searchText).sorted(byKeyPath: "date", ascending: true)
            tableView.reloadData()
        }
        
    }
    
    
}

