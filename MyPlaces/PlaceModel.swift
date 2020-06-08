//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Анастасия Лагарникова on 03.06.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import RealmSwift

class Place: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    @objc dynamic var rating = 0.0
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?, rating: Double) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
        self.rating = rating
    }

}
