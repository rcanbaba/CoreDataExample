//
//  ViewController2.swift
//  CoreDataExample
//
//  Created by Can Babaoğlu on 2.05.2022.
//

import UIKit
import CoreData

class ViewController2: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func imageTap() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let dataToSave = NSEntityDescription.insertNewObject(forEntityName: "Gallery", into: context)
        
        dataToSave.setValue(nameTextField.text, forKey: "name")
        dataToSave.setValue(locationTextField.text, forKey: "location")
        
        if let year = Int(yearTextField.text ?? "1995") {
            dataToSave.setValue(year, forKey: "year")
        }
        
        let compressedImage = imageView.image?.jpegData(compressionQuality: 0.5)
        dataToSave.setValue(compressedImage, forKey: "image")
        
        dataToSave.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("context save succeeded")
        } catch {
            print("Error")
        }
        
        self.navigationController?.popViewController(animated: true)
    }    

}

extension ViewController2: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController2: UINavigationControllerDelegate {
    
    
}
