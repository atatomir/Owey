//
//  FriendData.swift
//  Owey
//
//  Created by Alex Tatomir on 18/08/2019.
//  Copyright © 2019 Alex Tatomir. All rights reserved.
//

import Foundation
import UIKit

struct FriendData {
    var name: String
    var image: UIImage
    
    // Creates a NEW Friend 
    func toFriend() -> Friend {
        let friend = ModelManager.newFriend()
        
        friend.name = name
        friend.picture = image
        
        return friend
    }
}
