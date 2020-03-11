//
//  DailyRecord.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class DailyRecord: NSObject {

    let date: Date
    let global1RM: Int
    var unitRecords = [UnitRecord]()
    
    init(date: Date, unitRecord: UnitRecord) {
        self.date = date
        self.global1RM = unitRecord.get1RM()
        self.unitRecords.append(unitRecord)
    }
    
    
}
