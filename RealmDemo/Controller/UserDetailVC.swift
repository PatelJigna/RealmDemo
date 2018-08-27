//
//  UserDetailVC.swift
//  RealmDemo
//
//  Created by Jigna Patel on 22.08.18.
//  Copyright © 2018 Jigna Patel. All rights reserved.
//

import UIKit
import RealmSwift

class UserDetailVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
   
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtGender: UITextField!

    @IBOutlet weak var txtOccupation: UITextField!
    
    @IBOutlet weak var txtAge: UITextField!
    
    @IBOutlet weak var txtContact: UITextField!
    
    @IBOutlet weak var btnAddOrEdit: UIButton!
    
    @IBOutlet weak var viewPicker: UIView!
    
    @IBOutlet weak var pickerGender: UIPickerView!
    
    var isEditingMode: Bool?
    
    var getSelectedUser: User?
    
    var arrGender = ["Male","Female"]
    
    var strSelectedGender: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Get Path
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        
        viewHide()
        
        if isEditingMode == true {
            btnAddOrEdit.setTitle("Update", for: .normal)
            setSelectedUserDetail()
        }
        else {
            btnAddOrEdit.setTitle("Save", for: .normal)
        }
      
        btnAddOrEdit.addTarget(self, action: #selector(btnaddOrEditAction(sender:)), for: .touchUpInside)
    }

    func setSelectedUserDetail() {
        
        txtName.text = getSelectedUser?.name ?? ""
        txtOccupation.text = getSelectedUser?.occupation ?? ""
        
        if let intAge = getSelectedUser?.age.value {
            txtAge.text = String(intAge)
        }
      
        if let intContact = getSelectedUser?.contact.value {
             txtContact.text = String(intContact)
        }
        
        if let intGender = getSelectedUser?.gender.value {
            txtGender.text = arrGender[intGender]
        }
        
    }
    
    
    //MARK: - Button Actions
    @IBAction func btnGenderAction(_ sender: Any) {
        viewShow()
    }
    
    
    @IBAction func btnPickerDoneAction(_ sender: Any) {
         txtGender.text = strSelectedGender
         txtGender.resignFirstResponder()
        viewHide()
    }
    
    @objc func btnaddOrEditAction(sender: UIButton) {
    
        self.view.endEditing(true)
        
        let id = SharedClass.sharedInstance.incrementID()
        let intContact = Int(txtContact.text!)
        let intGender = arrGender.index(of: txtGender.text!)
        let intAge = Int(txtAge.text!)
        
        if isEditingMode == true {
            
            //Update
            let updatedUser = User(id: (getSelectedUser?.id)!, name: txtName.text!, gender: RealmOptional<Int>(intGender), occupation: txtOccupation.text ?? "", age: RealmOptional<Int>(intAge), contact: RealmOptional<Int>(intContact))
            
            SharedClass.sharedInstance.updateRecord(obj: updatedUser)
        }
        else {
            
            //Save
        
            do {
                try checkDetails()
                
                let objUser = User(id: id, name: txtName.text!, gender: RealmOptional<Int>(intGender), occupation: txtOccupation.text ?? "", age: RealmOptional<Int>(intAge) , contact: RealmOptional<Int>(intContact))
                
                SharedClass.sharedInstance.saveRecord(obj: objUser)
            }
            catch UserValidation.emptyName {
                UIAlertController.showAlertWithOkButton(self, aStrMessage: Constant.kMsgEmptyName, completion: nil)
            }
            catch UserValidation.emptyGender {
                UIAlertController.showAlertWithOkButton(self, aStrMessage: Constant.kMsgEmptyGender, completion: nil)

            }
            catch {
                UIAlertController.showAlertWithOkButton(self, aStrMessage: Constant.kMsgDefault, completion: nil)

            }
            
           
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Pickerview Datasource Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrGender.count
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        strSelectedGender = arrGender[row]
        return strSelectedGender
    }
    
    //MARK: - Textfield Delegate Method
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            txtOccupation.becomeFirstResponder()
        } else if textField == txtOccupation {
            textField.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: - Validations
    
    enum UserValidation : Error {
        case emptyName
        case emptyGender
    }
    
    
    func checkDetails() throws {
        
        if (txtName.text?.isEmpty)! {
            throw UserValidation.emptyName
        }
        
        if (txtGender.text?.isEmpty)! {
            throw UserValidation.emptyGender
        }
    }
    
    
    //MARK: - Other Methods
    
    func viewShow() {
        
        self.view.endEditing(true)
        viewPicker.isHidden = false
        
        viewPicker.frame = CGRect(x: viewPicker.frame.origin.x, y: self.view.frame.size.height, width: self.view.frame.size.width, height: viewPicker.frame.size.height)
        
        UIView.animate(withDuration: 0.3) {
            self.viewPicker.frame = CGRect(x: self.viewPicker.frame.origin.x, y: self.view.frame.size.height - self.viewPicker.frame.size.height, width: self.viewPicker.frame.size.width, height: self.viewPicker.frame.size.height)
        }
    }
    
    
    func viewHide()  {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewPicker.frame = CGRect(x: self.viewPicker.frame.origin.x, y: self.view.frame.size.height, width: self.viewPicker.frame.size.width, height: self.viewPicker.frame.size.height)
            
        }) { (boolCompletion) in
            self.viewPicker.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
