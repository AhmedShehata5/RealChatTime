//
//  ViewController.swift
//  RealChatTestProject
//
//  Created by Ahmed on 4/5/20.
//  Copyright © 2020 AHMED. All rights reserved.
//

import UIKit
import ImagePicker
import Firebase
import ProgressHUD

class WelcomeVc: UIViewController {
    
    
    
    
    
    override func viewDidLoad() {
          super.viewDidLoad()

          setSwips()
          profileImageTapped()
      }

    
    
    
    
    
     //MARK:-OUTLETS

     @IBOutlet weak var profileImageView: UIImageView!
     
     @IBOutlet weak var firstnameTf: UITextField!{
         didSet{
             firstnameTf.layer.cornerRadius = firstnameTf.frame.height / 2
             firstnameTf.attributedPlaceholder = NSAttributedString(string: "  Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(1)])
             firstnameTf.layer.borderWidth = 2
                        firstnameTf.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                     firstnameTf.layer.cornerRadius =  firstnameTf.frame.height / 2
         }
     }
     
     @IBOutlet weak var lastnameTf: UITextField!{
         didSet{
             lastnameTf.layer.cornerRadius = lastnameTf.frame.height / 2
                 lastnameTf.attributedPlaceholder = NSAttributedString(string: "  Last Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(1)])
             lastnameTf.layer.borderWidth = 2
                        lastnameTf.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                     lastnameTf.layer.cornerRadius =  lastnameTf.frame.height / 2
             }
     }
     
     @IBOutlet weak var emailTF: UITextField!{
         didSet{
             emailTF.layer.cornerRadius = emailTF.frame.height / 2
                 emailTF.attributedPlaceholder = NSAttributedString(string: "  Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(1)])
             emailTF.layer.borderWidth = 2
                        emailTF.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                     emailTF.layer.cornerRadius =  emailTF.frame.height / 2
             }
     }
     
     @IBOutlet weak var passwordTF: UITextField!{
         didSet{
             passwordTF.layer.cornerRadius = passwordTF.frame.height / 2
                 passwordTF.attributedPlaceholder = NSAttributedString(string: "  Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(1)])
             passwordTF.layer.borderWidth = 2
                        passwordTF.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                     passwordTF.layer.cornerRadius =  passwordTF.frame.height / 2
             }
     }
    
     @IBOutlet weak var confirmpasswordTF: UITextField!{
         didSet{
             confirmpasswordTF.layer.cornerRadius = confirmpasswordTF.frame.height / 2
                 confirmpasswordTF.attributedPlaceholder = NSAttributedString(string: "  Confirm Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(1)])
             confirmpasswordTF.layer.borderWidth = 2
                        confirmpasswordTF.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                     confirmpasswordTF.layer.cornerRadius =  confirmpasswordTF.frame.height / 2
             }
     }
     
     @IBOutlet weak var signOutLet: UIButton!{
         didSet{
             signOutLet.layer.borderWidth = 2
                signOutLet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
             signOutLet.layer.cornerRadius =  signOutLet.frame.height / 2
         }
     }
    //MARK: - Constants
    
    let leftSwipGes = UISwipeGestureRecognizer()
    let rightSwipGes = UISwipeGestureRecognizer()
    let imageTapped = UITapGestureRecognizer()
    
    var profileImage: UIImage?
    
  
    
    //MARK: - IBAction
    
    @objc func Swipped(){
        
        if signOutLet.titleLabel?.text == "Sign up"{
            
            signOutLet.setTitle("Sign in", for: .normal)
            firstnameTf.isHidden = true
             lastnameTf.isHidden = true
             confirmpasswordTF.isHidden = true
            profileImageView.isHidden = true
            
            
        }else{
            signOutLet.setTitle("Sign up", for: .normal)
            firstnameTf.isHidden = false
            profileImageView.isHidden = false
            lastnameTf.isHidden = false
            confirmpasswordTF.isHidden = false
        }
    }

    @IBAction func signBtnPressed(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Sign up"{

           registerBtnPressed()
            
        }else{
            
            loginBtnPressed()
            
        }
        
    }
    
    @objc func imagePressed(){
        
        let imagePickerView = ImagePickerController()
        imagePickerView.imageLimit = 1
        imagePickerView.delegate = self
        
        self.present(imagePickerView, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions

    func setSwips(){
        
        leftSwipGes.direction = .left
        rightSwipGes.direction = .right
        
        self.view.addGestureRecognizer(leftSwipGes)
        self.view.addGestureRecognizer(rightSwipGes)
        
        leftSwipGes.addTarget(self, action: #selector(self.Swipped))
        rightSwipGes.addTarget(self, action: #selector(self.Swipped))
    }
    
    func profileImageTapped(){
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTapped)
        imageTapped.addTarget(self, action: #selector(self.imagePressed))
    }
      func loginBtnPressed(){
            
            guard !emailTF.text!.isEmpty,
                !passwordTF.text!.isEmpty else{return}
            
            Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (result, error) in
                
                if error != nil{
                    
                    ProgressHUD.showError(error!.localizedDescription)
                    print(error!.localizedDescription)
                    return
                }
                
                print(result!.user.uid)
                
                SaveCurrentUser(uId: result!.user.uid) { (isSaved) in
                    
                    if isSaved{
                        //TODO: - go Home Screen
                        self.goToHome()
                        
                    }else{
                        ProgressHUD.showError("User Not Saved")
                    }
                }
            }
            
        }
        
        func registerBtnPressed(){
            
            guard !emailTF.text!.isEmpty,
                !passwordTF.text!.isEmpty,
                !firstnameTf.text!.isEmpty,
                profileImage != nil
                else{ ProgressHUD.showError("Fill Empty Fields") ;return}
            
            Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { (result, error) in
                
                if error != nil{
                    
                    ProgressHUD.showError(error!.localizedDescription)
                    print(error!.localizedDescription)
                    return
                }
                
                print(result!.user.uid)
                
                self.saveUserToDatabase(uID: result!.user.uid)
                
            }
        }

        func saveUserToDatabase(uID: String){

            let userFuser = FUser(_objectId: uID, _createdAt: Date(), _updatedAt: Date(), _email: emailTF.text!, _fullname: firstnameTf.text!, _avatar: stringFromImage(image: profileImage!))
            
            let userDic = userDictionaryFrom(user: userFuser)
            
            DBref.child(reference(.User)).child(uID).setValue(userDic) { (error, ref) in
                
                if error != nil{
                    
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                print("User Saved Succ")
                
                saveUserLocally(fUser: userFuser)
                
                //TODO: - go Home Screen
                self.goToHome()
                
            }
        }
        
        func goToHome(){
            let vc = UIStoryboard(name: "Users", bundle: nil).instantiateViewController(identifier: "myUserNav")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }

    }
    
     
    
    






extension WelcomeVc: ImagePickerDelegate{
    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        if images.count > 0{
            
            profileImage = images.first
            profileImageView.image = profileImage!.circleMasked
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
