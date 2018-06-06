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
        initBarBtn()

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
    
    private func initBarBtn() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleSelection))
        self.navigationItem.setRightBarButton(barButtonItem, animated: true)
    }
    
    @objc func handleSelection() {
        var textField = UITextField()
        let alertController = UIAlertController(title: "ADD", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "", style: .default) { (action) in
            guard let note = self.note else { return }
            let item = Item(context: self.context)
            item.name = textField.text
            item.date = Date()
            item.parentNote = note
            if let note = self.note {
                item.noteName = note.name
            }
            self.itemArray.append(item)
        }
        alertController.addTextField { (text) in
            textField = text
        }
        alertController.addAction(action)
    }
}

//TODO: LOAD,SAVE ITEMS, DEPENDING ON THE DESCRIPTION

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
        let predicate = NSPredicate(format: "parentNote.note matches %@", note.name!)
        request.predicate = predicate
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Exception has thrown: \(error)")
        }
    }
}
