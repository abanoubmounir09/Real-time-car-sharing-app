//
//  NewTripVC.swift
//  RealTimeCarSharing
//
//  Created by pop on 2/19/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

class NewTripVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var destFrom: UITextField!
    @IBOutlet weak var destTo: UITextField!
    @IBOutlet weak var carTypeTXT:UITextField!
    @IBOutlet weak var phontTXT:UITextField!
    @IBOutlet weak var noPassTXT:UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "new journey"
        destFrom.delegate = self
        destTo.delegate = self
        carTypeTXT.delegate = self
        phontTXT.delegate = self
        noPassTXT.delegate = self
    }


    @IBAction func sendBTN(_ sender: Any) {
        let ref = FIRDatabase.database().reference().child("travel")
        let childREf = ref.childByAutoId()
        guard let from  = destFrom.text , destFrom.text != nil else{return}
        guard let to  = destTo.text , destTo.text != nil else{return}
        guard let car  = carTypeTXT.text , carTypeTXT.text != nil else{return}
        guard let phone  = phontTXT.text , phontTXT.text != nil else{return}
        guard let noPass  = noPassTXT.text , noPassTXT.text != nil else{return}
         let dateFormatter = DateFormatter()
         dateFormatter.dateStyle = DateFormatter.Style.short
         dateFormatter.timeStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        let values2 = ["from":from,"to":to,"car":car,"phone":phone,"nopass":noPass,"timestamp":strDate] as? [String:Any]
        childREf.setValue(values2) { (error, ref) in
            if error != nil{
                print(error)
                return
            }else{
                print("tripe saved")
                print(strDate)
            }
        }
      
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == destFrom {
            textField.endEditing(true)
        } else if textField == destTo {
            textField.endEditing(true)
        }else if textField == carTypeTXT {
            textField.endEditing(true)
        }else if textField == phontTXT {
            textField.endEditing(true)
        }else if textField == noPassTXT {
            textField.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != nil{
            return true
        }else{
            textField.placeholder = "enter start ?"
            return false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       // textField.text = " "
    }
    
    
    
    
    
    
}
