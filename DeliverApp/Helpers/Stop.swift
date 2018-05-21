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
    private var _longitude: Double?
    private var _latitude: Double?

    init(id: Int, delivered: Bool, name: String, latitude: Double, longitude: Double) {
        _id = id
        _delivered = delivered
        _name = name
        _latitude = latitude
        _longitude = longitude
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
    
    var latitude: Double {
        set { _latitude = newValue }
        get { return _latitude! }
    }
    
    var longitude: Double {
        set { _longitude = newValue }
        get { return _longitude! }
    }
}
