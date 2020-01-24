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
        cell.personImageView.image = UIImage(contentsOfFile: getDocumentDirectory().appendingPathComponent(person.image).path)
        return cell
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
        
        if let jpgData = image.jpegData(compressionQuality: 0.8){
            try? jpgData.write(to: imagePath)
        }
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

