//
//  Constants.swift
//  InterviewProject
//
//  Created by Dorde Ljubinkovic on 12/28/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import Foundation

struct Constants {
    
    struct SegueIdentifiers {
        static let patientDetailsSegue = "patientDetailsSegue"
        static let addPatientSegue = "addPatientSegue"
        static let editPatientSegue = "editPatientSegue"
    }
    
    struct EdamamApi {
        static let baseUrl = "https://api.edamam.com/search"
        static let appId = "1d665fb5"
        static let appKey = "6de7e45e6d43e9593921c4137c6d2abc"
    }
}
