//
//  Friend+CoreDataClass.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Friend)
public class Friend: NSManagedObject {
    
    // Creates a FriendData with these values
    func toFriendData() -> FriendData {
        return FriendData(name: self.name, image: self.picture as! UIImage)
    }
}
