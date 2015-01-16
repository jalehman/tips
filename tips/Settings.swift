//
//  Settings.swift
//  tips
//
//  Created by Josh Lehman on 1/14/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class Settings: NSObject, NSCoding {
    var percentages: [TipPercent]!
    var splitBetween: Int = 1
    var billAmount: Double = 0
    
    override init() {}
    
    init(percentages: [TipPercent]) {
        self.percentages =  percentages
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.percentages = decoder.decodeObjectForKey("percentages") as [TipPercent]
        self.splitBetween = decoder.decodeIntegerForKey("splitBetween") as Int
        self.billAmount = decoder.decodeDoubleForKey("billAmount") as Double
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.percentages, forKey: "percentages")
        aCoder.encodeInteger(self.splitBetween, forKey: "splitBetween")
        aCoder.encodeDouble(self.billAmount, forKey: "billAmount")
    }
    
    func resetTemporalSettings() {
        self.splitBetween = 1
        self.billAmount = 0
    }
}