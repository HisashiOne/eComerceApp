//
//  MainViewController.swift
//  eComerceApp
//
//  Created by Oswaldo Morales on 6/28/20.
//  Copyright © 2020 Oswaldo Morales. All rights reserved.
//

import UIKit
import SWSegmentedControl
import TTGSnackbar
import CoreData
import Alamofire
import SwiftyJSON
import SDWebImage
import AVFoundation


class MainViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    let sc = SWSegmentedControl(items: ["Busqueda", "Historial", "Usuario"])
    
    var listView_: listView!
    var historyView_: historyView!
    var userView_: userView!
    
    var userDB: String!
    var indexUser: Int!
    var userCoreData = [User]()
    var userArray: Array<String> = []
    let imagePicker = UIImagePickerController()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    let container: UIView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        sc.frame = self.navigationView.frame
               sc.titleColor = .purple
               sc.font = UIFont.boldSystemFont(ofSize: 16.0)
               sc.indicatorColor = .systemPink
               sc.unselectedTitleColor = .systemPink
               sc.addTarget(self, action: #selector(updateView(_:)), for: UIControl.Event.valueChanged)
               self.view.addSubview(sc)
        
        let defaults = UserDefaults.standard
        userDB = defaults.string(forKey: "user")
               
        self.initView();
        self.setGradientBackground();
        
        

        // Do any additional setup after loading the view.
    }
    
    
    //PRAGMA MARK: Init Views
    
    private func initView(){
        
        var frame_1: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
            frame_1.size = self.containerView.frame.size
        
            //ListView
            let bundle_1 = Bundle(for: listView.self)
            let nib_1 = UINib(nibName: "listView", bundle: bundle_1)
            listView_ = nib_1.instantiate(withOwner: self, options: nil)[0] as? listView
            listView_.frame =  self.containerView.frame
            listView_.frame.origin.y =  self.containerView.frame.origin.y - 100
            containerView.addSubview(listView_)

             //HistoryView
            let bundle_2 = Bundle(for: historyView.self)
            let nib_2 = UINib(nibName: "historyView", bundle: bundle_2)
            historyView_ = nib_2.instantiate(withOwner: self, options: nil)[0] as? historyView
            historyView_.frame =  self.containerView.frame
            historyView_.frame.origin.y =  self.containerView.frame.origin.y - 100
            containerView.addSubview(historyView_)
        
        
            //UserView
            let bundle_3 = Bundle(for: userView.self)
            let nib_3 = UINib(nibName: "userView", bundle: bundle_3)
            userView_ = nib_3.instantiate(withOwner: self, options: nil)[0] as? userView
            userView_.frame =  self.containerView.frame
            userView_.frame.origin.y =  self.containerView.frame.origin.y - 100
            containerView.addSubview(userView_)
        
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
       
     
    @objc func updateView(_ sender: Any) {
        
       if sc.selectedSegmentIndex == 0 {
            userView_.isHidden = true
            historyView_.isHidden = true
            listView_.isHidden = false
                   
            }else if sc.selectedSegmentIndex == 1 {
            userView_.isHidden = true
            historyView_.isHidden = false
            listView_.isHidden = true
            }
            else{
            userView_.isHidden = false
            historyView_.isHidden = true
            listView_.isHidden = true
            
            }
        
    }

}
