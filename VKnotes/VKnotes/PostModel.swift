//
//  PostModel.swift
//  VKnotes
//
//  Created by Дарья Витер on 16/11/2019.
//  Copyright © 2019 Fems. All rights reserved.
//

import UIKit

//class PostModel {
//    static var shared: PostModel = {
//        let instance = PostModel()
//
//        return instance
//    }()
//    public var posts: [Post] = []
//    public var isPicked: Bool = false
//}

struct Post {
    var text: String
    var image: Data?
	var url: String
    var isPicked: Bool
}
