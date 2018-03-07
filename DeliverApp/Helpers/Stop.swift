//
//  Stop.swift
//  DeliverApp
//
//  Created by Florian Saurs on 07/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import Foundation

class Stop {
    
    private var _id: Int?
    private var _delivered: Bool?
    private var _name: String?

    init(id: Int, delivered: Bool, name: String) {
        _id = id
        _delivered = delivered
        _name = name
    }
    
    var id: Int {
        set { _id = newValue }
        get { return _id! }
    }
    
    var delivered: Bool {
        set { _delivered = newValue }
        get { return _delivered! }
    }
        
    var name: String {
        set { _name = newValue }
        get { return _name! }
    }
}
