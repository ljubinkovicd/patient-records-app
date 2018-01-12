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
    @IBOutlet weak var patientGenderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var hasMigrainesSwitch: UISwitch!
    @IBOutlet weak var takesDrugsSwitch: UISwitch!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: AddPatientControllerDelegate?
    
    var patientToEdit: Patient?
    var dateOfBirth = Date()
    var datePickerVisible = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        patientNameTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let patient = patientToEdit {
            title = "Edit Patient"
            patientNameTextField.text = patient.name
            
            if patient.gender == Genders.male.rawValue {
                patientGenderSegmentedControl.selectedSegmentIndex = 0
            } else {
                patientGenderSegmentedControl.selectedSegmentIndex = 1
            }
            
            hasMigrainesSwitch.setOn(patient.hasMigraine, animated: true)
            takesDrugsSwitch.setOn(patient.takesDrugs, animated: true)
            
            doneBarButton.isEnabled = true
            
            dateOfBirth = patient.dateOfBirth
        }
        
        updateDateOfBirthLabel()
    }
    
    // MARK: - Custom Methods
    func updateDateOfBirthLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateOfBirthLabel.text = formatter.string(from: dateOfBirth)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDateRow = IndexPath(row: 4, section: 0)
        let indexPathDatePicker = IndexPath(row: 5, section: 0) // make it show up under the dateOfBirth label
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateOfBirthLabel.textColor = UIColor(red: 0, green: 122, blue: 255)
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
    }
    
    func hideDatePicker() {
        
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 4, section: 0)
            let indexPathDatePicker = IndexPath(row: 5, section: 0)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                dateOfBirthLabel.textColor = UIColor.lightGray
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func calculateAgeBasedOnDateOfBirth(dateOfBirth: Date) -> Int {
        let currentDate = Date()
        let interval = currentDate.years(from: dateOfBirth)
        print("DIFFERENCE BETWEEN TODAY AND THE SELECTED DATE (IN YEARS): \(interval)")
        
        return interval
    }
    
    // MARK: - Button Tap Methods
    @IBAction func cancel() {
        delegate?.addPatientControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        if let patient = patientToEdit {
            patient.name = patientNameTextField.text!
            
            patient.dateOfBirth = dateOfBirth
            
            patient.age = calculateAgeBasedOnDateOfBirth(dateOfBirth: patient.dateOfBirth)
            
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
            
            let patient: Patient? = Patient()
            
            if let patient = patient {
                patient.name = patientNameTextField.text!
                patient.dateOfBirth = dateOfBirth
                
                patient.age = calculateAgeBasedOnDateOfBirth(dateOfBirth: patient.dateOfBirth)
                patient.gender = patientGender
                patient.hasMigraine = hasMigrainesSwitch.isOn
                patient.takesDrugs = takesDrugsSwitch.isOn
                patient.photo = UIImage(named: "default")
                patient.patientResults = nil
                
                delegate?.addPatientController(self, didFinishAdding: patient)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dateOfBirth = datePicker.date
        updateDateOfBirthLabel()
    }
}

// MARK: - Data Source
extension AddPatientController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If we have clicked on date label, we want to display date picker in a new row.
        if section == 0 && datePickerVisible {
            return 6
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 5 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 0 && indexPath.row == 5 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
}

// MARK: - Delegate
extension AddPatientController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        patientNameTextField.resignFirstResponder()
        
        if indexPath.section == 0 && indexPath.row == 4 {
            
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 0 && indexPath.row == 4 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 5 {
            let datePickerHeight: CGFloat = 217.0
            
            return datePickerHeight
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}

extension AddPatientController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        doneBarButton.isEnabled = (newText.count > 0)
        
        return true
    }
}
