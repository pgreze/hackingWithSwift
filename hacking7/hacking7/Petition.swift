//
//  Petition.swift
//  hacking7
//
//  Created by pgreze on 2021/07/09.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
