//
//  Exercice.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class Exercice: NSObject {

    let name: String
    let global1RM: Int
    var dailyRecords = [DailyRecord]()
    
    init(name: String, record: DailyRecord) {
        self.name = name
        self.global1RM = record.global1RM
        self.dailyRecords.append(record)
    }
}
