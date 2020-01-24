//
//  Person.swift
//  Project10_NamesToFaces
//
//  Created by Amr Hesham on 1/24/20.
//  Copyright © 2020 Amr Hesham. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image:String
     init(name:String, image:String) {
        self.name = name
        self.image = image
    }
}

