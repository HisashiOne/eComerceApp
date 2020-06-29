//
//  LoginViewController.swift
//  eComerceApp
//
//  Created by Oswaldo Morales on 6/28/20.
//  Copyright © 2020 Oswaldo Morales. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setGradientBackground()

        // Do any additional setup after loading the view.
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
      
    

}
