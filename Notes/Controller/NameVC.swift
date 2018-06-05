//
//  ViewController.swift
//  Notes
//
//  Created by Alex Stroia on 6/5/18.
//  Copyright © 2018 Alex Stroia. All rights reserved.
//

import UIKit
import CoreData
class NameVC: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var textField: UITextField!
    var usersArray = [User]()
 
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromCoreData()
    }


    @IBAction func Tap(_ sender: UIButton) {
        if (textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            textField.placeholder = "Textfield is empty"
        } else {
            let user = User(context: context)
            user.name = textField.text
            user.registredDate = Date()
            usersArray.append(user)
            saveToCoreData()
        }
    }
    
    private func saveToCoreData() {
        do {
            try context.save()
            print("Saved user with succes")
        } catch {
            print("Error has thrown: \(error)")
        }
        tableView.reloadData()
    }
    
    private func loadFromCoreData() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            try usersArray = context.fetch(request)
        } catch {
            print("Error: \(error)")
        }
    }
    

    @IBAction func deleteBtnAction(_ sender: UIButton) {
        let buttonPressedPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPressedPosition)
        context.delete(usersArray[indexPath!.row])
        usersArray.remove(at: indexPath!.row)
        saveToCoreData()
    }
}

extension NameVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = usersArray[indexPath.row].name ?? "Invalid name"
        tableView.cellForRow(at: indexPath)?.addGestureRecognizer(longPressGestureRecognizer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(usersArray[indexPath.row])
//        usersArray.remove(at: indexPath.row)
        performSegue(withIdentifier: "goToData", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NotesTableVC {
            //DO THE STUFF, SET THE DELEGATE
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}

