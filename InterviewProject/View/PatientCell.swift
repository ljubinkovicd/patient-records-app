//
//  PatientCell.swift
//  InterviewProject
//
//  Created by Dorde Ljubinkovic on 12/29/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

class PatientCell: UITableViewCell {

    let cellId = "PatientCell"

    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientInfoLabel: UILabel!
    @IBOutlet weak var patientImageView: UIImageView!
    
    // MARK: - Properties
//  Whenever the patient property is set, it’ll verify there’s a value and if so, update the IBOutlets with the correct information.
    var patient: Patient? {
        didSet {
            guard let patient = patient else { return }
            
            patientNameLabel.text = patient.name
            patientInfoLabel.text = "Age: \(patient.age), Gender: \(patient.gender)"
            patientImageView.image = patient.photo
        }
    }
}
