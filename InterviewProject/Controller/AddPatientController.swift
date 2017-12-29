//
//  AddPatientController.swift
//  InterviewProject
//
//  Created by Dorde Ljubinkovic on 12/29/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

protocol AddPatientControllerDelegate: class {
    // MARK: - Adding
    func addPatientControllerDidCancel(_ controller: AddPatientController)
    func addPatientController(_ controller: AddPatientController, didFinishAdding patient: Patient)
    
    // MARK: - Editing
    func addPatientController(_ controller: AddPatientController, didFinishEditing patient: Patient)
}

class AddPatientController: UITableViewController {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var patientNameTextField: UITextField!
    @IBOutlet weak var patientAgeTextField: UITextField!
    @IBOutlet weak var patientGenderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var hasMigrainesSwitch: UISwitch!
    @IBOutlet weak var takesDrugsSwitch: UISwitch!
    
    weak var delegate: AddPatientControllerDelegate?
    
    var patientToEdit: Patient?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        patientNameTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let patient = patientToEdit {
            title = "Edit Patient"
            patientNameTextField.text = patient.name
            patientAgeTextField.text = patient.age.description
            
            if patient.gender == Genders.male.rawValue {
                patientGenderSegmentedControl.selectedSegmentIndex = 0
            } else {
                patientGenderSegmentedControl.selectedSegmentIndex = 1
            }
            
            hasMigrainesSwitch.setOn(patient.hasMigraine, animated: true)
            takesDrugsSwitch.setOn(patient.takesDrugs, animated: true)
            
            doneBarButton.isEnabled = true
        }
    }
    
    // Bar Button Taps
    @IBAction func cancel() {
        delegate?.addPatientControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        if let patient = patientToEdit {
            patient.name = patientNameTextField.text!
            patient.age = Int(patientAgeTextField.text!)!
            let patientGender: String
            if patientGenderSegmentedControl.selectedSegmentIndex == 0 {
                patientGender = Genders.male.rawValue
            } else {
                patientGender = Genders.female.rawValue
            }
            patient.gender = patientGender
            patient.hasMigraine = hasMigrainesSwitch.isOn
            patient.takesDrugs = takesDrugsSwitch.isOn
            
            delegate?.addPatientController(self, didFinishEditing: patient)
            
        } else {
            let patientGender: String
            if patientGenderSegmentedControl.selectedSegmentIndex == 0 { patientGender = Genders.male.rawValue } else { patientGender = Genders.female.rawValue }
            let patient = Patient(name: patientNameTextField.text!, age: Int(patientAgeTextField.text!)!, gender: patientGender, hasMigraine: hasMigrainesSwitch.isOn, takesDrugs: takesDrugsSwitch.isOn, photo: nil, patientResults: nil)
            
            if let patient = patient {
                delegate?.addPatientController(self, didFinishAdding: patient)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension AddPatientController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
       
        doneBarButton.isEnabled = (newText.count > 0)
        
        return true
    }
}
