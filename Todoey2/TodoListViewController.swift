//
//  ViewController.swift
//  Todoey
//
//  Created by Ashwani  Agrawal on 25/06/18.
//  Copyright © 2018 Ashwani  Agrawal. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController, UISearchBarDelegate {
    
    var itemArray = [Item]()
   // var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category? { didSet{ getData()}}
    
    
    
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
            
            let item = Item(context: self.context)
            item.value = textField.text!
            item.isChecked = false
            item.parentCategory = self.selectedCategory
            self.itemArray.append(item)
            self.saveData()
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
    
    
    
    
    

    func saveData(){
        
        do{
            try context.save()
        }
        catch{
            print("errors are \(error)")
        }
    }
    
    func getData(with request: NSFetchRequest<Item> = Item.fetchRequest(),_ predicate: NSPredicate? = nil){
        let mustPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let check = predicate{
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [check, mustPredicate])
            request.predicate = compoundPredicate
        }
        else{
            request.predicate = mustPredicate
        }
        
        
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print(error)
        }
        tableView.reloadData()

    }
    
    //MARK: table view appear
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].value
        
        cell.accessoryType = itemArray[indexPath.row].isChecked ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row].value!)
        
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        saveData()
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count != 0{
            let request: NSFetchRequest<Item> = Item.fetchRequest()

            let predicate = NSPredicate(format: "value CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]

            getData(with: request, predicate)
        }
        else{
            getData()
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
           
        }
        
    }

}

