//
//  CategoryViewController.swift
//  Todoey2
//
//  Created by Ashwani  Agrawal on 29/06/18.
//  Copyright © 2018 Ashwani  Agrawal. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getData()
        tableView.separatorStyle = .none
        
     //   tableView.reloadData()

    }
    
    
    
    //MARK: add Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "Enter The New Category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            self.saveData()
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (text) in
            textField = text
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: data
    
    func saveData()
    {
        do{
        try context.save()
        }
        catch{
            print(error)
        }
    }
    
    func getData(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do{
            categories  = try context.fetch(request)
            
        }
        catch{
            print(error)
        }
       tableView.reloadData()
    }
   

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        

        return cell
    }
    
    


   
    

    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }

    }

}

