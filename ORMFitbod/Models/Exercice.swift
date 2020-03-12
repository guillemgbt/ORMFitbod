//
//  Exercice.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class Exercice: NSObject, OneRepMaxProvider {

    let name: String
    private var global1RM: Float
    private var dailyRecords = [DailyRecord]()
    
    init?(name: String, record: DailyRecord) {
        
        if name.isEmpty { return nil }
        
        self.name = name
        self.global1RM = record.get1RM()
        self.dailyRecords.append(record)
    }
    
    func get1RM() -> Float {
        return self.global1RM
    }
    
    func update1RM(provider: OneRepMaxProvider) {
        self.global1RM = max(provider.get1RM(), self.global1RM)
    }
    
    func addRecord(_ dailyRecord: DailyRecord) {
        self.update1RM(provider: dailyRecord)
        self.dailyRecords.append(dailyRecord)
    }
    
    func addRecord(_ unitRecord: UnitRecord, date: Date) {
        
        if let dailyRecord = self.dailyRecords.filter({ $0.date == date }).first {
            dailyRecord.addRecord(unitRecord)
            self.update1RM(provider: unitRecord)
        } else {
            let dailyRecord = DailyRecord(date: date, unitRecord: unitRecord)
            self.addRecord(dailyRecord)
        }
    }
    
    func getRecord(for date: Date) -> DailyRecord? {
        return self.dailyRecords.filter({ $0.date == date }).first
    }
}
