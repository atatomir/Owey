//
//  Observer.swift
//  Owey
//
//  Created by Alex Tatomir on 03/09/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation

protocol Observer {
    func update(by subject: Subject)
}

class Subject {
    private var observers: [Observer] = []
    
    func clearObservers() {
        observers.removeAll()
    }
    
    func addObserver(observer: Observer) {
        observers.append(observer)
    }
    
    func notify() {
        for observer in observers {
            observer.update(by: self)
        }
    }
}
