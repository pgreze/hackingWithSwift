//
//  Person.swift
//  hacking10
//
//  Created by pgreze on 2021/07/12.
//

import UIKit

class Person: NSObject, Codable { //, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
//    func encode(with coder: NSCoder) {
//        coder.encode(name, forKey: "name")
//        coder.encode(image, forKey: "image")
//    }
//
//    required init?(coder: NSCoder) {
//        name = coder.decodeObject(forKey: "name") as? String ?? ""
//        image = coder.decodeObject(forKey: "image") as? String ?? ""
//    }
}
