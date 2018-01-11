//
//  PatientsController.swift
//  InterviewProject
//
//  Created by Dorde Ljubinkovic on 12/29/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

struct TableViewCellIdentifiers {
    static let patientCellId = "PatientCell"
}

class PatientsController: UITableViewController {
    
    var containerView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.white
        
        return uiView
    }()
    
    let noRecordsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = NSLocalizedString("No data available", comment: "Describes the state of table view, if it is empty or not.")
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        return label
    }()
    
    let addRecordsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addRecord), for: .touchUpInside)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        button.backgroundColor = UIColor.blue
        button.setTitle(NSLocalizedString("Add a patient", comment: "Button that adds a patient."), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.layer.cornerRadius = 16.0
        button.layer.masksToBounds = true
        
        return button
    }()
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataModel.patients.count == 0 {
            
            tableView.addSubview(containerView)
            containerView.addSubview(noRecordsLabel)
            containerView.addSubview(addRecordsButton)
            
            containerView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
            containerView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
            
            noRecordsLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            noRecordsLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            
            addRecordsButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            addRecordsButton.topAnchor.constraint(equalTo: noRecordsLabel.bottomAnchor, constant: 16.0).isActive = true
            
            tableView.backgroundView = containerView
            tableView.separatorStyle = .none
            
            return 0
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            
            return dataModel.patients.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.patientCellId, for: indexPath) as? PatientCell else { fatalError("The dequeued cell is not an instance of PatientCell.") }
        
        let patient = dataModel.patients[indexPath.row]
        cell.patient = patient
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        dataModel.patients.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        dataModel.savePatients()
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Segue
    @objc fileprivate func addRecord() {
        performSegue(withIdentifier: Constants.SegueIdentifiers.addPatientSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.SegueIdentifiers.addPatientSegue {
            
            let navigationController = segue.destination as! UINavigationController
            let addPatientController = navigationController.topViewController as! AddPatientController
            
            addPatientController.delegate = self
        }
        
        if segue.identifier == Constants.SegueIdentifiers.editPatientSegue {
            let navigationController = segue.destination as! UINavigationController
            let addPatientController = navigationController.topViewController as! AddPatientController
            
            addPatientController.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! PatientCell) {
                addPatientController.patientToEdit = dataModel.patients[indexPath.row]
            }
        }
        
        if segue.identifier == Constants.SegueIdentifiers.patientDetailsSegue {
            guard let cell = sender as? PatientCell,
                let indexPath = tableView.indexPath(for: cell) else {
                    return
            }
            
            let index = indexPath.row
            //            //____________________________________________________________
            //            UserDefaults.standard.set(index, forKey: "PatientIndex")
            //            let selectedPatient = self.dataModel.patients[index]
            //            //____________________________________________________________
            
            let selectedPatient = self.dataModel.patients[index]
            
            let patientDetailsController = segue.destination as? PatientDetailsController
            patientDetailsController?.patient = selectedPatient
            patientDetailsController?.dataModel = dataModel
        }
    }
    
    // MARK: - Custom Methods
    func configureText(for cell: PatientCell,
                       with patient: Patient) {
        
        let label1 = cell.viewWithTag(1000) as! UILabel
        label1.text = patient.name
        let label2 = cell.viewWithTag(1001) as! UILabel
        label2.text = "Age: \(patient.age), Gender: \(patient.gender)"
    }
}

extension PatientsController: AddPatientControllerDelegate {
    
    func addPatientControllerDidCancel(_ controller: AddPatientController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addPatientController(_ controller: AddPatientController, didFinishAdding patient: Patient) {
        
        let newRowIndex = dataModel.patients.count
        dataModel.patients.append(patient)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
        
        dataModel.savePatients()
        
        print("\(patient.name) + \(patient.age)")
        let result = dataModel.calculateToddSyndromeProbabilityOfPatient(patient)
        
        dataModel.saveResultToUserDefaults(patient: patient, result: result)
    }
    
    func addPatientController(_ controller: AddPatientController, didFinishEditing patient: Patient) {
        
        if let index = dataModel.patients.index(of: patient) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? PatientCell {
                configureText(for: cell, with: patient)
            }
        }
        dismiss(animated: true, completion: nil)
        
        dataModel.savePatients()
        let result = dataModel.calculateToddSyndromeProbabilityOfPatient(patient)
        
        dataModel.saveResultToUserDefaults(patient: patient, result: result)
    }
}

extension PatientsController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        // Checks if the back button was tapped
        if viewController === self {
            UserDefaults.standard.set(-1, forKey: "PatientIndex")
        }
    }
}
