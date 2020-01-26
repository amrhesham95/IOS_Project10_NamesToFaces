//
//  ViewController.swift
//  Project10_NamesToFaces
//
//  Created by Amr Hesham on 1/24/20.
//  Copyright © 2020 Amr Hesham. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var people = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        // Do any additional setup after loading the view.
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else{
            fatalError("Unable to dequeue PersonCell")
        }
        let person = people[indexPath.item]
        cell.personNameLabel.text = person.name
        
        //contentsOfFiles expects String so .path get the string value of the URL
        cell.personImageView.image = UIImage(contentsOfFile: getDocumentDirectory().appendingPathComponent(person.image).path)
        
        cell.personImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.personImageView.layer.borderWidth = 2
        cell.personImageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // to take text from popup alert controller
        let ac = UIAlertController(title: "Rename", message: "Enter the person name", preferredStyle: .alert)
        
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default){
            // to save the text coming from the textfield to the array and then refresh the collection view to see the effect
            [weak self,weak ac] _ in
            guard let newName = ac?.textFields?[0].text else{
                return
            }
            
            
            self?.people[indexPath.row].name = newName
            self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Delete", style: .default){
            // to save the text coming from the textfield to the array and then refresh the collection view to see the effect
            [weak self,weak ac] _ in
            self?.people.remove(at: indexPath.row)
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{
            return
        }
        let imageUniqueName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageUniqueName)
        
        //converting the image to Data so we can write it on the disk
        if let jpgData = image.jpegData(compressionQuality: 0.8){
            try? jpgData.write(to: imagePath)
        }
        
        //creating person object after we have chosen a picture for him
        let person = Person(name: "person\(people.count)", image: imageUniqueName)
        people.append(person)
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentDirectory() -> URL {
        // used userDomainMask as said by Apple (if you open the class you will see that) that it should be used to save user's personal items
        let Paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // we got the value of the first element as the paths returned from the method contained only one element
        return Paths[0]
    }
    
    
}

