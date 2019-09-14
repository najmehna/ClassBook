//
//  RegisterViewController.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-14.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate{

    @IBAction func cameraBtnClicked(_ sender: UIButton) {
    }
    
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    var datePicker: UIDatePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        fullnameTextField.delegate = self
        emailTextField.delegate = self
        birthdayTextField.delegate = self
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        birthdayTextField.inputView = datePicker
        
        // Do any additional setup after loading the view.
    }
    @objc func dateValueChanged(picker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        birthdayTextField.text = dateFormatter.string(from: picker.date)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
