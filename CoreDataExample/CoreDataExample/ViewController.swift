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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataArray.removeAll()
        getData()
    }
    
    @objc func addItem() {
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
}

extension ViewController: UITableViewDelegate {
    
    
}
