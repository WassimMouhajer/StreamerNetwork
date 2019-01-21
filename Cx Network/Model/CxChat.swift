//
//  CxChat.swift
//  Cx Network
//
//  Created by ElectroZone on 2018-09-10.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//

import Foundation

class CxChat {
    
    private var _totalResults: Int!
    private var _message: String!
    
    var message: String {
        if _message == nil {
            _message = ""
        }
        return _message
        
    }
    
    var totalResults: Int {
        if _totalResults == nil {
            _totalResults = 0
        }
        return _totalResults
        
    }
    
    init(chatDict: Dictionary<String, AnyObject>) {
        if let snippet = chatDict["snippet"] as? Dictionary<String,AnyObject> {
            if let messages = snippet["displayMessage"] as? String {
                self._message = messages
            }
        }
        
    }
    
    init() {
        
    }
    
    
}
