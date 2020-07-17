//
//  MessagesVc.swift
//  RealChatTestProject
//
//  Created by Ahmed on 4/6/20.
//  Copyright © 2020 AHMED. All rights reserved.
//

import UIKit
import ImagePicker
class MessagesVC: UIViewController {

    //MARK: - OutLets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageBodyTF: UITextField!
    @IBOutlet weak var senderBtnOutLEt: UIButton!
    
    //MARK: - Constants
    
    var ChatRoomId: String!
    var usersId: [String]!
    var messages = [Messages]()
    var users = [FUser]()
    var selectedimage: UIImage?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
       // tableView.rowHeight = UITableView.automaticDimension
        
        messages = []
         ChatRoomId = getChatRoomId(fUserId:  usersId.first!, sUserId: usersId.last!)
   
    
        getMessages()
    }
    
    //MARK: - IBAction
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        if messageBodyTF.text != ""{
            
            senderBtnOutLEt.isEnabled = false
            
            sendMyMessage(text: messageBodyTF.text!, photo: nil)
            
        }
        
    }
    
    @IBAction func imagepickerpressed(_ sender: Any) {
        let picker = ImagePickerController()
        picker.imageLimit = 1
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Helper Functions
    
    func sendMyMessage(text: String?, photo: String?){
        
        // Going Message
        
        if let text = text{
            
            let encryptedText = Encryption.encryptText(chatRoomId: ChatRoomId, message: text)
            
            let MessageID = UUID().uuidString
            
            let goingMessage = OutgoingMessages(message: encryptedText, senderId: FUser.currentId(), senderName: FUser.currentUser()?.fullname ?? "", date: Date(), messageType: kPRIVATE, type: messageType(.text), messageId: MessageID)
            
            goingMessage.sendMessage(chatRoomId: ChatRoomId, messageDictionary: goingMessage.messagesDictionary, membersIds: usersId)
            
            messageBodyTF.text = ""
            senderBtnOutLEt.isEnabled = true
        }
        if let photo = photo {
            
               let encryptedText = Encryption.encryptText(chatRoomId: ChatRoomId, message: "[Image]")
            
              let MessageID = UUID().uuidString
            let goingMessage = OutgoingMessages(message: encryptedText, senderId:  FUser.currentId(), senderName: FUser.currentUser()?.fullname ?? "", date:  Date(), messageType: kPRIVATE, imageLink: photo, type:  messageType(.image), messageId: MessageID)
            goingMessage.sendMessage(chatRoomId: ChatRoomId, messageDictionary: goingMessage.messagesDictionary, membersIds: usersId)
        }
        
    }
    
    func getMessages(){
        
        DBref.child(reference(.Message)).child(FUser.currentId()).child(ChatRoomId).queryOrdered(byChild: kDATE).observe(.childAdded) { (snapshot) in
            
            
            let snap = snapshot.value as! NSDictionary
            
            let newMessage = Messages(_dictionary: snap, chatRoomId: self.ChatRoomId)
            
            self.messages.append(newMessage)
            
            self.tableView.reloadData()
            self.ScrollDown()
        }
    }
    
    func ScrollDown(){
        
        DispatchQueue.main.async {
            
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
               
            if (indexPath.row > 0){
                   
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }
    }

}


//MARK: - TableView Delegates

extension MessagesVC: UITableViewDataSource, UITableViewDelegate{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].type == kTEXT{
            if messages[indexPath.row].senderId == FUser.currentId(){
                      
                      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! myMessageTVCell
                      
                      cell.messageLBL.text = messages[indexPath.row].message
                      cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
                      
                      return cell
                      
                  }else{
                      
                      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! myFriendsMessageTVCell
                          
                      cell.messageLBL.text = messages[indexPath.row].message
                      cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
                      
                      return cell
                  }
            
        }else{
            if messages[indexPath.row].senderId == FUser.currentId(){
                      
                      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! myimageTvCell
                      //TODO:- Download Image
                       
                downloadImage(imageUrl: messages[indexPath.row].picture) { (myImage) in
                    if let myImage = myImage {
                        
                        cell.myimagesend.image = myImage
                    }
                }
                      cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
                      
                      return cell
                      
                  }else{
                      
                      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! myfriendimageTvCell
                          
                    downloadImage(imageUrl: messages[indexPath.row].picture) { (myImage) in
                                    if let myImage = myImage {
                                        
                                        cell.myfriendimagesend.image = myImage
                                    }
                                }
                      cell.dateLBL.text = timeElapsed(date: messages[indexPath.row].date)
                      
                      return cell
                  }
        }
            
        
      

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }


}
extension MessagesVC: ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        if images.count > 0 {
            selectedimage = images.last
            //TODO:- Upload image to fire store
            // return image link
            
            
            uploadImage(image: selectedimage!, chatRoomId: self.ChatRoomId, view: self.navigationController!.view) { (imageURL) in
                guard let imageURL = imageURL else {return}
                
                  //TODO:- Upload message to firebase database
                
                self.sendMyMessage(text: nil, photo: imageURL)
            }
          
            
            
        }
        
          self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
          self.dismiss(animated: true, completion: nil)
    }
    
    
}
