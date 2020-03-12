//
//  DailyRecord.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class DailyRecord: NSObject, OneRepMaxProvider {

    let date: Date
    private var global1RM: Float
    private var unitRecords = [UnitRecord]()
    
    
    init(date: Date, unitRecord: UnitRecord) {
        self.date = date
        self.global1RM = unitRecord.get1RM()
        self.unitRecords.append(unitRecord)
    }
    
    func get1RM() -> Float {
        return self.global1RM
    }
    
    func addRecord(_ unitRecord: UnitRecord) {
        self.global1RM = max(unitRecord.get1RM(), self.global1RM)
        self.unitRecords.append(unitRecord)
    }
    
    
    
    
}
