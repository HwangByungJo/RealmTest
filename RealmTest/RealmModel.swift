//
//  RealmModel.swift
//  RealmTest
//
//  Created by Pang on 2017. 10. 18..
//

import Foundation
import RealmSwift

class Album: Object{

    @objc dynamic var title: String = ""
    @objc dynamic var saveDate: Date = Date()
    
    let photos: List<Photo> = List<Photo>()
}

class Photo : Object {
    
    @objc dynamic var saveDate: Date = Date()
    @objc dynamic var imageData: Data = Data()
}


