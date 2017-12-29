//
//  DataModel.swift
//  InterviewProject
//
//  Created by Dorde Ljubinkovic on 12/29/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import Foundation


class DataModel {
    
    var patients = [Patient]()
    let userDefaults = UserDefaults.standard
    
    init() {
        loadPatients()
    }
    
    // Convenience method to get the full path to Documents folder.
    // Here we store patient list items.
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("InterviewProject.plist")
    }
    
    // Take the contents of patients array and serialize it to a file
    func savePatients() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(patients, forKey: "PatientItems")
        archiver.finishEncoding()
        
        data.write(to: dataFilePath(), atomically: true)
    }
    
    // Load the entire array from the file, if it exists.
    func loadPatients() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            patients = unarchiver.decodeObject(forKey: "PatientItems") as! [Patient]
            
            unarchiver.finishDecoding()
        }
    }
    
    // Save result to UserDefaults results array.
    func saveResultToUserDefaults(patient: Patient?, result: Float) {
        
        guard let patient = patient else { return }
        
//        let result = Float(calculateToddSyndromeProbabilityOfPatient(patient))
        
        var array = readResultsFromUserDefaults(patient: patient)
        array?.append(result)
        userDefaults.set(array, forKey: patient.name) // Associate with patient's name so that we get only results for that patient. Should use something like UUID instead here, so that the key associated with the value is unique.
    }
    
    // Read the results array from UserDefaults.
    func readResultsFromUserDefaults(patient: Patient?) -> [Float]? {
        
        guard let patient = patient else { return nil }
        
        let results = userDefaults.object(forKey: patient.name) as? [Float] ?? [Float]()
        
        return results
    }
    
    // Each time we add/edit a patient, we instantly need to calculate their probability of having a Todd's Syndrome
    func calculateToddSyndromeProbabilityOfPatient(_ patient: Patient) -> Float {

        let numberOfSymptoms: Int = 4
        var count: Int = 0
        var result: Float = 10.0

        if patient.hasMigraine {
            count += 1
        }
        if patient.age <= 15 {
            count += 1
        }
        if patient.gender == Genders.male.rawValue {
            count += 1
        }
        if patient.takesDrugs {
            count += 1
        }

        result = Float(count) / Float(numberOfSymptoms)
        result *= 100.0 // Convert to percentage

//        return "\(result.clean.description)%"
        return result
    }

}
