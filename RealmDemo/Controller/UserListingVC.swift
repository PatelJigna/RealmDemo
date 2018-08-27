//
//  UserListingVC.swift
//  RealmDemo
//
//  Created by Jigna Patel on 22.08.18.
//  Copyright © 2018 Jigna Patel. All rights reserved.
//

import UIKit
import RealmSwift

class UserListingVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var arrUser = [User]()
    
    @IBOutlet weak var tblViewUser: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAllUserRecords()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         getAllUserRecords()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableview Datasource Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblCellDetail") as? tblCellDetail
        cell?.lblName.text = arrUser[indexPath.row]["name"] as? String
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       goToUserDetailVC(editingMode: true, indexpath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //delete from realm
        let deleteUser: User = arrUser[indexPath.row]
        SharedClass.sharedInstance.deleteRecord(obj: deleteUser)
        
        //Delete from arr
        arrUser.remove(at: indexPath.row)
        
        //Delete from table
        tblViewUser.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    @IBAction func btnGoToUserDetailVC(_ sender: Any) {
        goToUserDetailVC(editingMode: false, indexpath: nil)
    }
    
    func goToUserDetailVC(editingMode: Bool?, indexpath: IndexPath?)  {
        
        let objUserDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as? UserDetailVC
        objUserDetailVC?.isEditingMode = editingMode
        
        if editingMode == true {
            objUserDetailVC?.getSelectedUser = arrUser[(indexpath?.row)!]
        }
       
        self.navigationController?.pushViewController(objUserDetailVC!, animated: true)
    }
    
    
    func getAllUserRecords() {
        
        arrUser.removeAll()
        let result = SharedClass.sharedInstance.getAllRecords(type: User.self)
        
        if let result = result {
            print(result)

            for element in result {
                if let user = element as? User {
                    arrUser.append(user)
                }
            }
            
            print(arrUser)
            tblViewUser.reloadData()
        }
        
    }
    

}
