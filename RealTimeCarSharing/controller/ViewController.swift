//
//  ViewController.swift
//  RealTimeCarSharing
//
//  Created by pop on 2/19/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var mytableview: UITableView!
    @IBOutlet weak var fromTXT: roundTxtFied!
    @IBOutlet weak var ToTXT: roundTxtFied!
    var tripdict = [TripModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(Add))
        navigationItem.title = "Car_Sharing"
        fromTXT.delegate = self
        ToTXT.delegate = self
        mytableview.delegate = self
        mytableview.dataSource = self
     
        }

   
    @objc func Add(){
       let vc = storyboard?.instantiateViewController(withIdentifier: "newtrip") as? NewTripVC
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fromTXT {
            textField.endEditing(true)
        } else if textField == ToTXT {
            textField.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != nil{
            return true
        }else{
           
            return false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       // textField.text = " "
    }
    
    @IBAction func GetBTN(_ sender: Any) {
        tripdict.removeAll()
        if let from = fromTXT.text?.trimming ,!from.isEmpty,let to = ToTXT.text?.trimming,!(ToTXT.text?.isEmpty)! {
            print("busy")
            getQuery(_from: from, _to: to)
        } else{
            let alert = UIAlertController(title: "Attention", message: "Fill Two record", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
}

extension ViewController{
    func getQuery(_from:String,_to:String){
        let  ref = FIRDatabase.database().reference().child("travel")
        let to = _to
        do{
            try
                ref.queryOrdered(byChild: "from").queryEqual(toValue: _from).observeSingleEvent(of: .value, with: { (snapshot) in
                    for child in snapshot.children {
                        let tripob = TripModel()
                        let childSnap = child as! FIRDataSnapshot
                        let dict = childSnap.value as? [String: Any]
                        tripob.from = dict!["from"] as? String
                        tripob.to = dict!["to"] as? String
                        if to == tripob.to{
                            tripob.car = dict!["car"] as? String
                            tripob.phone = dict!["phone"] as? String
                            tripob.nopass = dict!["nopass"] as? String
                            tripob.time = dict!["timestamp"] as? String
                            self.tripdict.append(tripob)
                            self.configrerowhight()
                            self.mytableview.reloadData()
                        }// end IF
                    }// end for loop
                    if self.tripdict.count == 0{
                        let alert = UIAlertController(title: "good luck next time", message: "unvalid entered", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })// end query
            
        }catch let error{
            print(error.localizedDescription)
            let alert = UIAlertController(title: "good luck next time", message: "unvalid entered", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
       
        fromTXT.text = ""
        ToTXT.text = ""
    }// end function
}


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripdict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytableview.dequeueReusableCell(withIdentifier: "tripcell", for: indexPath) as? CustomTripeCell
        cell?.destination.text = "\(tripdict[indexPath.row].from!)  to  \(tripdict[indexPath.row].to!)"
        cell?.dateLB.text = tripdict[indexPath.row].time
        cell?.carLB.text = tripdict[indexPath.row].car
        cell?.phoneLB.text = tripdict[indexPath.row].phone
        return cell!
    }
    
    func configrerowhight(){
        mytableview.rowHeight = UITableViewAutomaticDimension
        mytableview.estimatedRowHeight = 120.0
    }
    
}


// print("*********---***-----******")
// print("from - =\(tripob.from ) to - =\(tripob.to) car - =\(tripob.car)/ phone =\(tripob.phone) - time=\(tripob.time) ")

