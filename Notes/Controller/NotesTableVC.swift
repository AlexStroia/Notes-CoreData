//
//  NotesTableVC.swift
//  Notes
//
//  Created by Alex Stroia on 6/5/18.
//  Copyright © 2018 Alex Stroia. All rights reserved.
//

import UIKit
import CoreData

class NotesTableVC: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var note: Note?
    var itemArray = [Item]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].name
        return cell
    }
}

extension NotesTableVC {
    fileprivate func saveToCoreData() {
        do {
           try context.save()
        } catch {
            print("Exception has thrown: \(error)")
        }
    }
    
    fileprivate func loadFromCoreData() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        guard let note = note else { return }
        let predicate = NSPredicate(format: "noteName matches %@", note.name!)
        request.predicate = predicate
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Exception has thrown: \(error)")
        }
    }
}
