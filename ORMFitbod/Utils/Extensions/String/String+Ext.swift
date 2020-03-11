//
//  String+Ext.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

extension String {
    
    func toInt() -> Int? {
        return Int(self)
    }
    
    func toDate(withFormat format: String = "MM dd yyyy") -> Date? {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
      return dateFormatter.date(from: self)
    }
}
