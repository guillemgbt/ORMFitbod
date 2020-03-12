//
//  PromiseObject.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 12/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

enum PromiseState {
    case success
    case error
    case loading
}

class PromiseObject<T>: NSObject {
    
    let state: PromiseState
    let object: T?
    let message: String?
    
    init(state: PromiseState, object: T? = nil, message: String? = nil) {
        self.state = state
        self.object = object
        self.message = message
    }

}
