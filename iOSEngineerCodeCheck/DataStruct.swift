//
//  DataStruct.swift
//  iOSEngineerCodeCheck
//
//  Created by 矢嶋丈 on 2021/01/04.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct ItemData: Codable{
    let name: String?
    let language: String?
    let stars: Int?
    let watchers: Int?
    let forks: Int?
    let issues: Int?
    let url: String?
}

struct OwnerData: Codable {
    let name: String?
    let imageURL: String?
}
