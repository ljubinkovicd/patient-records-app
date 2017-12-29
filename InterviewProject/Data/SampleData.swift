//
//  SampleData.swift
//  InterviewProject
//
//  Created by Dorde Ljubinkovic on 12/29/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

final class SampleData {
    
    static func generatePatientsData() -> [Patient] {
        return [
            // Probability of Todd's Syndrome should be 100%
            Patient(name: "100% Todd's Syndrome Patient", age: 15, gender: Genders.male.rawValue, hasMigraine: true, takesDrugs: true, photo: UIImage(named: "patient"), patientResults: nil)!,
            
            // Probability of Todd's Syndrome should be 75%
            Patient(name: "75% Todd's Syndrome Patient", age: 16, gender: Genders.male.rawValue, hasMigraine: true, takesDrugs: true, photo: nil, patientResults: nil)!,
            
            // Probability of Todd's Syndrome should be 50%
            Patient(name: "50% Todd's Syndrome Patient", age: 18, gender: Genders.female.rawValue, hasMigraine: true, takesDrugs: true, photo: nil, patientResults: nil)!,
            
            // Probability of Todd's Syndrome should be 25%
            Patient(name: "25% Todd's Syndrome Patient", age: 25, gender: Genders.male.rawValue, hasMigraine: false, takesDrugs: false, photo: UIImage(named: "patient"), patientResults: nil)!,
            
            // Probability of Todd's Syndrome should be 0%
            Patient(name: "0% Todd's Syndrome Patient", age: 72, gender: Genders.female.rawValue, hasMigraine: false, takesDrugs: false, photo: UIImage(named: "patient"), patientResults: nil)!,
            
//            guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
//                fatalError("Unable to instantiate meal1")
//            }
        ]
    }
}
