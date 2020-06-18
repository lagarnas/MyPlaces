//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Анастасия Лагарникова on 04.06.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        //запись в бд
        try! realm.write{
            realm.add(place)
        }
    }
    
    static func deleteObject(_ place: Place) {
        try! realm.write{
            realm.delete(place)
        }
    }
}

