//
//  PatientResult.swift
//  InterviewProject
//
//  Created by Dorde Ljubinkovic on 12/29/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

class PatientResult: NSObject, NSCoding {
    
    var toddSyndromProbability: Float
    
    init(toddSyndromProbability: Float) {
        self.toddSyndromProbability = toddSyndromProbability
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(toddSyndromProbability, forKey: "ToddSyndromProbability")
    }
    
    required init?(coder aDecoder: NSCoder) {
        toddSyndromProbability = aDecoder.decodeFloat(forKey: "ToddSyndromProbability")
        super.init()
    }
}
