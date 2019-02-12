//
//  ViewController.swift
//  HitList2
//
//  Created by POST MD on 2/12/19.
//  Copyright © 2019 Grinning Zen Media and Design. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The Super Hero List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Hero", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            self.save(name: nameToSave)
            self.tableView.reloadData()
            }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)

    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Coud not save. \(error), \(error.userInfo)")
        }
    }
    
}

// MARK: - UITABLEVIEW DATASOURCE
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
    return people.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
}

}


//goas:
//add swipe cell kit to delete 
//1. add new attribute ie age
//2. add new entity such as powers
//3. add 2 new attributes to this entity.
//4. add swipe cell kit to delete\
//5. add checkmark

//code for checkmark? change the name of the cell. 
//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    yourtableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
//}
//
//func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//    yourtableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
//}
