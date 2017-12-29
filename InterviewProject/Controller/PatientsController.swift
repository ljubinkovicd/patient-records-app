//
//  PatientsController.swift
//  InterviewProject
//
//  Created by Dorde Ljubinkovic on 12/29/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

struct PatientCellIdentifiers {
    static let patientCellId = "PatientCell"
}

class PatientsController: UITableViewController {
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.patients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PatientCellIdentifiers.patientCellId, for: indexPath) as? PatientCell else { fatalError("The dequeued cell is not an instance of PatientCell.") }
        
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
