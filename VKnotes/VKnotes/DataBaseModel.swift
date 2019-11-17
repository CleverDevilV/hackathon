//
//  DataBaseModel.swift
//  VKnotes
//
//  Created by Onie on 16.11.2019.
//  Copyright © 2019 Fems. All rights reserved.
//

import Foundation

struct Note: Codable{
    var title:String
    var url:String
	var isPicked: Bool = false
}

struct Category: Codable{
    var title: String
    var notes: [String: Note]?
}
