//
//  TipPercent.swift
//  tips
//
//  Created by Josh Lehman on 1/14/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class TipPercent: NSObject, NSCoding {
    var percentage: Double!
    var checked: Bool = false
    
    override init() {}
    
    
    init(_ percentage: Double) {
        self.percentage = percentage
    }
    
    init(_ percentage: Double, checked: Bool) {
        self.percentage = percentage
        self.checked = checked
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.percentage = decoder.decodeDoubleForKey("percentage") as Double?
        self.checked = decoder.decodeBoolForKey("checked")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(self.percentage, forKey: "percentage")
        aCoder.encodeBool(self.checked, forKey: "checked")
    }
    
    func display() -> String {
        return String(format: "%.2f%%", percentage * 100)
    }
}