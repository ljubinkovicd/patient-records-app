//
//  Patient.swift
//  InterviewProject
//
//  Created by Dorde Ljubinkovic on 12/29/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

enum Genders: String {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

class Patient: NSObject, NSCoding {
    
    // MARK: - Properties
    var name: String = ""
    var age: Int = 0
    var gender: String
    var hasMigraine: Bool
    var takesDrugs: Bool
    var photo: UIImage?
    var patientResults: [Float]?
    
    // MARK: - Initialization    
    init?(name: String, age: Int, gender: String, hasMigraine: Bool, takesDrugs: Bool, photo: UIImage?, patientResults: [Float]?) {
        
        // Initialization of Patient object should fail if there is no name assigned to a patient.
        guard !name.isEmpty else { return nil }
        guard (age > 0) && (age <= 150) else { return nil } // The patient's age must be higher than 0 or lower than or equal than 150.
        
        self.name = name
        self.age = age
        self.gender = gender
        self.hasMigraine = hasMigraine
        self.takesDrugs = takesDrugs
        
        if let photo = photo {
            self.photo = photo
        } else {
            self.photo = UIImage(named: "default")
        }
        
        self.patientResults = patientResults
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(age, forKey: "Age")
        aCoder.encode(gender, forKey: "Gender")
        aCoder.encode(hasMigraine, forKey: "HasMigraine")
        aCoder.encode(takesDrugs, forKey: "TakesDrugs")
        aCoder.encode(photo, forKey: "Photo")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        age = aDecoder.decodeInteger(forKey: "Age")
        gender = aDecoder.decodeObject(forKey: "Gender") as! String
        hasMigraine = aDecoder.decodeBool(forKey: "HasMigraine")
        takesDrugs = aDecoder.decodeBool(forKey: "TakesDrugs")
        photo = aDecoder.decodeObject(forKey: "Photo") as? UIImage
        super.init()
    }
}


