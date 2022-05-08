//
//  MemoDataModel.swift
//  MyColorMemoApp
//
//  Created by 大迫洋平 on 2022/05/03.
//

import Foundation
import RealmSwift

class MemoDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var text: String = ""
    @objc dynamic var recordDate: Date = Date()
}
