//
//  SimpleObservable.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class SimpleObservable<T>: NSObject {
    
    private var value: T {
        didSet {
            self.onUpdate?(self.value)
        }
    }
    
    private var onUpdate: ((T)->())? = nil
    
    
    init(value: T) {
        self.value = value
    }
    
    func accept(_ value: T) {
        self.value = value
    }
    
    func current() -> T {
        return self.value
    }
    
    func observe(_ onUpdate: @escaping ((T)->())) {
        self.onUpdate = onUpdate
        self.onUpdate?(self.value)
    }
    
    func observeInUI(_ onUpdate: @escaping ((T)->())) {
        let onUpdateUI: (T)->() = { value in
            DispatchQueue.main.async {
                onUpdate(value)
            }
        }
        
        self.onUpdate = onUpdateUI
    }
}
