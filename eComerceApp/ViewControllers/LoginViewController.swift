//
//  LoginViewController.swift
//  eComerceApp
//
//  Created by Oswaldo Morales on 6/28/20.
//  Copyright © 2020 Oswaldo Morales. All rights reserved.
//

import UIKit
import TTGSnackbar
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var userTXT: UITextField!
    @IBOutlet weak var passTXT: UITextField!
    @IBOutlet weak var loginBTN: UIButton!
    
    var userCoreData = [User]()
    var userArray: Array<String> = []
    
    
    
    
    override func viewDidLoad() {
        
           let defaults = UserDefaults.standard
            let user_ = defaults.string(forKey: "user")
            if user_ != nil{
            self.performSegue(withIdentifier: "goToMain", sender: self)
            }
            
            super.viewDidLoad()
            
            self.initViews()
            self.setGradientBackground()
            self.loadUsers()
    }
    
    //PRAGMA MARK: Init
    
      private func initViews(){
          
          userTXT.layer.cornerRadius = 10
          passTXT.layer.cornerRadius = 10
          loginBTN.layer.cornerRadius = 10
        
          loginBTN.addTarget(self, action: #selector(login_(Sender:)), for: .touchUpInside)
          
          self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
          self.navigationController?.view.backgroundColor = UIColor.clear
        
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
      
    
    //PRAGMA MARK: Login
   
       @objc func login_(Sender: Any){
          
          view.endEditing(true)
          
          if (!userTXT.text!.isEmpty || !passTXT.text!.isEmpty){
              
              if userCoreData.count > 0 {
                  
                   if userArray.contains(userTXT.text!){
                      
                      let indexUser = userArray.firstIndex(of: userTXT.text!)!
                      let pass = userCoreData[indexUser].password
                      
                      if pass == passTXT.text{
                          
                          
                          userTXT.layer.borderWidth = 0
                          passTXT.layer.borderWidth = 0
                          let defaults = UserDefaults.standard
                          defaults.set(userTXT.text, forKey: "user")
                          self.performSegue(withIdentifier: "goToMain", sender: self)
                                    
                          
                      }else{
                          self.showErrorLogin()
                      }
                      
                    
                   }else{
                      self.showErrorLogin()
                      
                  }
                  
                  
              }else{
                  showErrorLogin()
              }
              
            
          }else{
              debugPrint("Error Login 1")
              userTXT.layer.borderColor = UIColor.red.cgColor
              passTXT.layer.borderColor = UIColor.red.cgColor
              userTXT.layer.borderWidth = 1
              passTXT.layer.borderWidth = 1
              let snackbar = TTGSnackbar(message: "Completa los datos faltantes", duration: .middle)
              snackbar.show()
          }
          
      }

    private func showErrorLogin(){
           
           userTXT.layer.borderColor = UIColor.red.cgColor
           passTXT.layer.borderColor = UIColor.red.cgColor
           userTXT.layer.borderWidth = 1
           passTXT.layer.borderWidth = 1
           let snackbar = TTGSnackbar(message: "Usuario o Contraseña incorrectos", duration: .middle)
           snackbar.show()

       }
       
       

      //PRAGMA MARK: Core Data
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
      
    

}
