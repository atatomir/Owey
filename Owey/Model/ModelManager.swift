//
//  ModelManager.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ModelManager {
    static let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    static let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    static var friendFetcher: NSFetchedResultsController<Friend>!
    
    
}
