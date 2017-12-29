//
//  PatientDetailsController.swift
//  InterviewProject
//
//  Created by Dorde Ljubinkovic on 12/29/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

class PatientDetailsController: UIViewController {
    
    // MARK: - Widgets
    let containerView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.clear
        
        return uiView
    }()
    
    let patientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "patient")
        imageView.layer.cornerRadius = 32.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let patientAgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let patientGenderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let hasDrugAbuseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let hasMigrainesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let toddSyndromeProbabilityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 10
        
        return label
    }()
    
    let resultHistoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Properties
    var patient: Patient?
    var dataModel: DataModel!
    var patientResultHistory: [Float]?
    var patientLastResult: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let patient = patient else { return }
        
        patientResultHistory = dataModel.readResultsFromUserDefaults(patient: patient)
        
        if let resultHistory = patientResultHistory {
            print(resultHistory)
        }
        
        setupLayout(patient)
    }

    // MARK: - Setup Layout
    func setupLayout(_ patient: Patient) {
        
        navigationItem.title = patient.name
        
        view.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        containerView.addSubview(patientImageView)
        containerView.addSubview(patientAgeLabel)
        containerView.addSubview(patientGenderLabel)
        containerView.addSubview(hasDrugAbuseLabel)
        containerView.addSubview(hasMigrainesLabel)
        containerView.addSubview(toddSyndromeProbabilityLabel)

        patientImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 64.0).isActive = true
        patientImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        patientImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        patientImageView.heightAnchor.constraint(equalTo: patientImageView.widthAnchor, multiplier: 0.5).isActive = true
        patientImageView.image = (patient.photo != nil) ? patient.photo : UIImage(named: "default")

        patientAgeLabel.topAnchor.constraint(equalTo: patientImageView.bottomAnchor, constant: 16.0).isActive = true
        patientAgeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0).isActive = true
        patientAgeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0).isActive = true
        patientAgeLabel.text = "Age: \(patient.age.description)"

        patientGenderLabel.topAnchor.constraint(equalTo: patientAgeLabel.bottomAnchor, constant: 16.0).isActive = true
        patientGenderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0).isActive = true
        patientGenderLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0).isActive = true
        patientGenderLabel.text = "Gender: \(patient.gender)"
        
        hasDrugAbuseLabel.topAnchor.constraint(equalTo: patientGenderLabel.bottomAnchor, constant: 16.0).isActive = true
        hasDrugAbuseLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0).isActive = true
        hasDrugAbuseLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0).isActive = true
        hasDrugAbuseLabel.text = "Drug Abuse: \(patient.takesDrugs ? "Yes" : "No")"
        
        hasMigrainesLabel.topAnchor.constraint(equalTo: hasDrugAbuseLabel.bottomAnchor, constant: 16.0).isActive = true
        hasMigrainesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0).isActive = true
        hasMigrainesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0).isActive = true
        hasMigrainesLabel.text = "Migraines: \(patient.hasMigraine ? "Yes" : "No")"
        
        toddSyndromeProbabilityLabel.topAnchor.constraint(equalTo: hasMigrainesLabel.bottomAnchor, constant: 16.0).isActive = true
        toddSyndromeProbabilityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0).isActive = true
        toddSyndromeProbabilityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0).isActive = true
//        toddSyndromeProbabilityLabel.text = "Todd's Syndrom Probability: \(dataModel.calculateToddSyndromeProbabilityOfPatient(patient))"
        
        var pastResults: String = ""
        
        if let result = patientResultHistory?.last {
            patientLastResult = result
            
            pastResults += patientResultHistory!.description
//            containerView.addSubview(resultHistoryLabel)
//
//            resultHistoryLabel.topAnchor.constraint(equalTo: toddSyndromeProbabilityLabel.bottomAnchor, constant: 16.0).isActive = true
//            resultHistoryLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16.0).isActive = true
//            resultHistoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0).isActive = true
//            resultHistoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0).isActive = true
//
//            resultHistoryLabel.text = "Patient's result history data: \(patientResultHistory!)"
        } else {
            patientLastResult = dataModel.calculateToddSyndromeProbabilityOfPatient(patient)
        }
        
        toddSyndromeProbabilityLabel.text = "Todd's Syndrom Probability: \(patientLastResult!)\nPast results: (\(pastResults))"
        
        
    }
}
