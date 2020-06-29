//
//  RegisterViewController.swift
//  eComerceApp
//
//  Created by Oswaldo Morales on 6/28/20.
//  Copyright © 2020 Oswaldo Morales. All rights reserved.
//

import UIKit
import TTGSnackbar
import CoreData


class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITextViewDelegate {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarBTN: UIButton!
    @IBOutlet weak var userTXT: UITextField!
    @IBOutlet weak var passTXT: UITextField!
    @IBOutlet weak var bithBTN: UIButton!
    @IBOutlet weak var registerBTN: UIButton!
    
    let imagePicker = UIImagePickerController()
    var userCoreData = [User]()
    var userArray: Array<String> = []
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.setGradientBackground()
        self.loadUsers()
    }
    
     //PRAGAMA MARK: Init Views
          private func initView(){
              
              avatarImageView.layer.cornerRadius = 50
              userTXT.layer.cornerRadius = 10
              bithBTN.layer.cornerRadius = 10
              passTXT.layer.cornerRadius = 10
              registerBTN.layer.cornerRadius = 10
    
          
              bithBTN.addTarget(self, action: #selector(datePicker(sender:)), for: .touchUpInside)
              avatarBTN.addTarget(self, action: #selector(photoPicker(sender:)), for: .touchUpInside)
                registerBTN.addTarget(self, action: #selector(validateRegister(_:)), for: .touchUpInside)
              
              imagePicker.delegate = self
              
              
             // let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
              
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                 NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
              //view.addGestureRecognizer(tap)
              
              self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
              self.navigationController?.navigationBar.shadowImage = UIImage()
              self.navigationController?.navigationBar.isTranslucent = true
              self.navigationController?.view.backgroundColor = UIColor.clear
              
              
          }
        
        
    //PRAGMA MARK: Keyboard
        @objc func dismissKeyboard() {
                    //Causes the view (or one of its embedded text fields) to resign the first responder status.
                    view.endEditing(true)
             }
        
        
        @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                 if self.view.frame.origin.y == 0{
                     self.view.frame.origin.y -= keyboardSize.height - 100
                 }
             }
         }
         
         @objc func keyboardWillHide(notification: NSNotification) {
            if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                 if self.view.frame.origin.y != 0{
                     //self.view.frame.origin.y += keyboardSize.height
                     
                     let screenSize: CGRect = UIScreen.main.bounds
                     
                     self.view.backgroundColor = .white
                     self.view.frame =  CGRect.init(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
                     
                 }
             }
         }
         
           
        
        func setGradientBackground() {
            let colorTop = UIColor(red: 0.98, green: 0.82, blue: 0.76, alpha: 1.00).cgColor
            let colorBottom = UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 1.00).cgColor
        
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = self.view.bounds

            self.view.layer.insertSublayer(gradientLayer, at:0)
        }
        
        
          //PRAGMA MARK: Image Picker
          
          func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
              
              if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
              
              debugPrint("Selected Image")
              avatarImageView.contentMode = .scaleAspectFill
              avatarImageView.image = pickedImage
              }
              
              dismiss(animated: true, completion: nil)
          }
          
          

        
          func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
              
              dismiss(animated: true, completion: nil)
              
          }
          
          
          
          @objc func photoPicker(sender: Any){
              
              imagePicker.allowsEditing = false
              imagePicker.sourceType = .photoLibrary
                    
              present(imagePicker, animated: true, completion: nil)
              
          }
        
        //PRAGMA MARK: Date Picker
         
         @objc func datePicker(sender: Any){
             
         view.endEditing(true)
             
          let myDatePicker: UIDatePicker = UIDatePicker()
          myDatePicker.timeZone = NSTimeZone.local
          myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
             myDatePicker.datePickerMode = .date
          let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert)
          alertController.view.addSubview(myDatePicker)
          let selectAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
             
             
             
             let formatter = DateFormatter()
             formatter.dateFormat = "dd-MM-yyyy"
             formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone?
             let dateSelected = (formatter.string(from: myDatePicker.date)).uppercased()
             self.bithBTN.setTitle(dateSelected, for: .normal)
            // print("Selected Date: \(myDatePicker.date)")
             
          })
          let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
          alertController.addAction(selectAction)
          alertController.addAction(cancelAction)
          present(alertController, animated: true, completion:{})
             
         }
         
         
        
        //PRAGMA MARK: CoreData
         
         func saveUser(){
             
             let image = avatarImageView.image
             let data = image?.jpegData(compressionQuality: 0.5)
             
             let user_ = User(context: persitantService.context)
             user_.user = userTXT.text!
             user_.password = passTXT.text!
             user_.birthdate = bithBTN.currentTitle
             user_.avatar = data
             
             persitantService.saveContext()
             
         }
        
        func loadUsers(){
             let  fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            
            do{
                let userCoreData = try
                    persitantService.context.fetch(fetchRequest)
                       self.userCoreData = userCoreData
                       if userCoreData.count > 0 {
                        
                        debugPrint("User CoreData  DB Total  \(userCoreData)")
                        userArray.removeAll()
                        
                        for index in 0..<userCoreData.count{
                                           
                        let user_ =  userCoreData[index].user!
                        userArray.append(user_)
                            
                        }
                        
                       }else{
                        
                             debugPrint("User CoreData  No Data ")
                        }
                       
                   }catch{}
        }
        
        //PRAGMA MARK: RegisterUser
          
          @objc func validateRegister(_ sender: Any){
              
              view.endEditing(true)
              
               let userBool = checkEmptyLBL(uiTXT: userTXT!)
               let passBool = checkEmptyLBL(uiTXT: passTXT!)
              
              
              if userBool && passBool && bithBTN.currentTitle != "Fecha de Nacimiento"{
                  debugPrint("All Fields OK")
                  
                  if userCoreData.count > 0{
                      
                      
                      if userArray.contains(userTXT.text!){
                          
                          let indexExist = userArray.firstIndex(of: userTXT.text!)
                          debugPrint("User Alredy Exist Index \(indexExist ?? 0)")
                          let snackbar = TTGSnackbar(message: "Ese Nombre de usuario ya existe escoje otro", duration: .middle)
                          snackbar.show()
                                         
                          userTXT.layer.borderWidth = 1
                          userTXT.layer.borderColor = UIColor.red.cgColor
                          
                          
                      }else{
                          
                          userTXT.layer.borderWidth = 0
                          self.saveUser()
                          
                          let defaults = UserDefaults.standard
                          defaults.set(userTXT.text, forKey: "user")
                          self.performSegue(withIdentifier: "goToMain", sender: self)
                        
                      }

                  }else{
                      
                      self.saveUser()
                      let defaults = UserDefaults.standard
                      defaults.set(userTXT.text, forKey: "user")
                      self.performSegue(withIdentifier: "goToMain", sender: self)
                  }
                  
                  
              }else{
                 
                  let snackbar = TTGSnackbar(message: "Completa los datos faltantes", duration: .middle)
                            snackbar.show()
                  
                  
                  
              }
              
          }
          

          private func checkEmptyLBL (uiTXT: UITextField) -> Bool{
                if uiTXT.text!.isEmpty{
                   
                    uiTXT.layer.borderWidth = 1
                    uiTXT.layer.borderColor = UIColor.red.cgColor
                    return false
                }else{
                    
                    uiTXT.layer.borderWidth = 0
                    return true
                }
            }
        

}
