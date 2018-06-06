//
//  ViewController.swift
//  Notes
//
//  Created by Alex Stroia on 6/5/18.
//  Copyright © 2018 Alex Stroia. All rights reserved.
//

import UIKit
import CoreData
class NoteNameVC: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var textField: UITextField!
    var notesArray = [Note]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromCoreData()
    }
    
    
    @IBAction func Tap(_ sender: UIButton) {
        if (textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            textField.placeholder = "Textfield is empty"
        } else {
            let note = Note(context: context)
            note.name = textField.text
            note.registredDate = Date()
            
            if notesArray.isEmpty {
                notesArray.append(note)
                saveToCoreData()
                textField.resignFirstResponder()
            } else {
            for note in notesArray {
                if !notesArray.contains(note) {
                    notesArray.append(note)
                    saveToCoreData()
                    textField.resignFirstResponder()
                } else {
                    textField.resignFirstResponder()
                    let controller = UIAlertController(title: "This name already exists", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel)
                    controller.addAction(action)
                    present(controller,animated: true)                
                }
            }
            updateUIAfterEdit()
        }
        }
    }
    
    
    private func updateUIAfterEdit() {
        textField.text = ""
        view.endEditing(true)
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
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            try notesArray = context.fetch(request)
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        let buttonPressedPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPressedPosition)
        context.delete(notesArray[indexPath!.row])
        notesArray.remove(at: indexPath!.row)
        saveToCoreData()
    }
}

extension NoteNameVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = notesArray[indexPath.row].name ?? "Invalid name"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        context.delete(usersArray[indexPath.row])
        //        usersArray.remove(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToData", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NotesTableVC {
            //DO THE STUFF, SET THE DELEGATE
            if let indexPath = tableView.indexPathForSelectedRow {
               destinationVC.note = notesArray[indexPath.row]
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

