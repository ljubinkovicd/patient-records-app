//
//  InterviewProjectTests.swift
//  InterviewProjectTests
//
//  Created by Dorde Ljubinkovic on 12/29/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import XCTest
@testable import InterviewProject

class InterviewProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPatientInitializationSuccessful() {
        // With name and valid age value.
        let withNameAndAgePatient = Patient.init(name: "Patient 1", age: 50, gender: Genders.male.rawValue, hasMigraine: false, takesDrugs: false, photo: nil, patientResults: nil)
        XCTAssertNotNil(withNameAndAgePatient)
    }
    
    func testPatientInitializationFailure() {
        // With name, but with invalid age value.
        let withNameAndInvalidAgePatient = Patient.init(name: "Patient 2", age: 151, gender: Genders.male.rawValue, hasMigraine: false, takesDrugs: false, photo: nil, patientResults: nil)
        XCTAssertNil(withNameAndInvalidAgePatient)
        
        // Without name, but with valid age value.
        let withoutNameAndValidAgePatient = Patient.init(name: "", age: 50, gender: Genders.male.rawValue, hasMigraine: false, takesDrugs: false, photo: nil, patientResults: nil)
        XCTAssertNil(withoutNameAndValidAgePatient)
        
        // Without name and with invalid age value.
        let withoutNameAndInvalidAgePatient = Patient.init(name: String(), age: -50, gender: Genders.male.rawValue, hasMigraine: false, takesDrugs: false, photo: nil, patientResults: nil)
        XCTAssertNil(withoutNameAndInvalidAgePatient)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
