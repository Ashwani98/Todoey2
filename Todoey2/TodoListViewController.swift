//
//  ViewController.swift
//  Todoey
//
//  Created by Ashwani  Agrawal on 25/06/18.
//  Copyright © 2018 Ashwani  Agrawal. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        print(path!)
        getData()
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
//        var item1 = Item()
//        item1.value = "sddf"
//        var item2 = Item()
//        item2.value = "sknjfn"
//        var item3 = Item()
//        item3.value = "iiiii"
//        itemArray.append(item1)
//        itemArray.append(item2)
//        itemArray.append(item3)
//
        
        
        tableView.separatorStyle = .none
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Item", message: "enter the item", preferredStyle: .alert)
        let action =  UIAlertAction(title: "Add", style: .default) { (action) in
            
            let item = Item()
            item.value = textField.text!
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
    

    func saveData(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: path!)
        }
        catch{
            print(error)
        }
    }
    
    func getData(){
        if let data = try? Data(contentsOf: path!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print(error)
            }
        }
        
    }
    
    
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
        print(itemArray[indexPath.row].value)
        
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        saveData()
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}

