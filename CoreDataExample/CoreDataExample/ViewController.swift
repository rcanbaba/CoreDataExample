//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Can Babaoğlu on 2.05.2022.
//

import UIKit
import CoreData

struct imageData {
    var name: String?
    var id: UUID?
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray = [imageData]()
    
    var sourceName = ""
    var sourceId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Can Photo Book"
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataArray.removeAll()
        getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondVC" {
            let destiationVC = segue.destination as! ViewController2
            destiationVC.targetName = sourceName
            destiationVC.targetId = sourceId
        }
    }
    
    @objc func addItem() {
        sourceName = ""
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    
    func getData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gallery")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                
                var tempData = imageData()
                
                if let name = result.value(forKey: "name") as? String {
                    tempData.name = name
                }
                if let id = result.value(forKey: "id") as? UUID {
                    tempData.id = id
                }
                
                dataArray.append(tempData)
                self.tableView.reloadData()
            }
        } catch {
            print("Error: fetch request")
        }
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dataArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sourceName = dataArray[indexPath.row].name ?? ""
        sourceId = dataArray[indexPath.row].id
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gallery")
        
        let idString = dataArray[indexPath.row].id?.uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                if (result.value(forKey: "id") as? UUID) != nil {
                    context.delete(result)
                    dataArray.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    
                    do {
                        try context.save()
                    } catch {
                        print("Error: save request")
                    }
                    
                }
            }
        } catch {
            print("Error: delete request")
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    
}
