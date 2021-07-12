//
//  Person.swift
//  hacking10
//
//  Created by pgreze on 2021/07/12.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
