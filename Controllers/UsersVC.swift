//
//  UsersVC.swift
//  RealZagChat
//
//  Created by Mohamed Arafa on 3/9/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import UIKit

class UsersVC: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Constants
    
    var users = [FUser]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUsersData()
    }
    
    //MARK: - IBAction
    
    
    
    //MARK: - Helper Functions
    
    func getUsersData(){
        
      DBref.child(reference(.User)).observe(.value) { (snapshot) in
                
                let snap = snapshot.value as! [String:Any]
                
                for (_,value) in snap{
                    
                    let Fuser = FUser(_dictionary: value as! NSDictionary)

                    if Fuser.objectId != FUser.currentId(){
                        self.users.append(Fuser)
                    }
                    
                    
                }
                
                self.tableView.reloadData()
            }
            
        
        
    }
    
    
}

extension UsersVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UsersTVCell
        
        cell.nameLBL.text = users[indexPath.row].fullname
        cell.emailLBL.text = users[indexPath.row].email
        
        imageFromString(pictureData: users[indexPath.row].avatar) { (Img) in
            
            guard let myImg = Img else {return}
            
            cell.userImageView.image = myImg.circleMasked
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
      
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let VC = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(identifier: "MessagesVC") as! MessagesVC
            
            VC.users = [FUser.currentUser()!, users[indexPath.row]]
            VC.usersId = [FUser.currentId(), users[indexPath.row].objectId]
            
            
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
