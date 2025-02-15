//
//  Prospect.swift
//  HotProspects
//
//  Created by 千々岩真吾 on 2025/02/15.
//

import Foundation
import SwiftData

@Model
final class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool

    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
}
