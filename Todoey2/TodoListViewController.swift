//
//  ViewController.swift
//  Todoey
//
//  Created by Ashwani  Agrawal on 25/06/18.
//  Copyright © 2018 Ashwani  Agrawal. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var listItem = ["one","two","three"]
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            listItem = items
        }
        
        tableView.separatorStyle = .none
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Item", message: "enter the item", preferredStyle: .alert)
        let action =  UIAlertAction(title: "Add", style: .default) { (action) in
            
            self.listItem.append(textField.text!)
            self.defaults.set(self.listItem, forKey: "TodoListArray")
            
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
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = listItem[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(listItem[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}

