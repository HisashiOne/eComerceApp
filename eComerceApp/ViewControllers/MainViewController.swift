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


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    let sc = SWSegmentedControl(items: ["Busqueda", "Historial", "Usuario"])
    
    var listView_: listView!
    var historyView_: historyView!
    var userView_: userView!
    
    var userDB: String!
    var indexUser: Int!
    var userCoreData = [User]()
    var historyCoreData = [History]()
    var userArray: Array<String> = []

    var dateArray: Array<String> = []
    let imagePicker = UIImagePickerController()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    let container: UIView = UIView()
    
    var searchString: String!
    
    var tittleArray : [String] = [];
    var imageArray : [String] = [];
    var priceArrayArray : [Int] = [];
    var idArrayArray : [String] = [];
    
    var historyArray : [String] = [];
    var dateArray_ : [String] = [];

    
    var isDataLoading:Bool=false
    var pageNo:Int=1
    var limit:Int=20
    var offset:Int=0
    var didEndReached:Bool=false
    
    
    
    
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
        self.loadUsers()
        self.loadHistory()
        

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Init Views
    
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
    
            listView_.saerchBTN.addTarget(self, action: #selector(searchProduct(_:)), for: .touchUpInside);
        
            listView_.mainTableView.delegate = self
            listView_.mainTableView.dataSource = self
            self.listView_.mainTableView.isHidden = true
        
            let nibCell = UINib(nibName: "listCell", bundle:nil)
            listView_.mainTableView.register(nibCell, forCellReuseIdentifier: "listCell")
           
        

             //HistoryView
            let bundle_2 = Bundle(for: historyView.self)
            let nib_2 = UINib(nibName: "historyView", bundle: bundle_2)
            historyView_ = nib_2.instantiate(withOwner: self, options: nil)[0] as? historyView
            historyView_.frame =  self.containerView.frame
            historyView_.frame.origin.y =  self.containerView.frame.origin.y - 100
            containerView.addSubview(historyView_)
        
            historyView_.mainTableView.delegate = self
            historyView_.mainTableView.dataSource = self
            let nibCell_ = UINib(nibName: "historyCell", bundle:nil)
            historyView_.mainTableView.register(nibCell_, forCellReuseIdentifier: "historyCell")
        
        
        
        
            //UserView
            let bundle_3 = Bundle(for: userView.self)
            let nib_3 = UINib(nibName: "userView", bundle: bundle_3)
            userView_ = nib_3.instantiate(withOwner: self, options: nil)[0] as? userView
            userView_.frame =  self.containerView.frame
            userView_.frame.origin.y =  self.containerView.frame.origin.y - 100
            containerView.addSubview(userView_)
        
    
            userView_.isHidden = true
            historyView_.isHidden = true
            listView_.isHidden = false
        
        
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
        
        view.endEditing(true)
               
        
       if sc.selectedSegmentIndex == 0 {
            userView_.isHidden = true
            historyView_.isHidden = true
            listView_.isHidden = false
                   
            }else if sc.selectedSegmentIndex == 1 {
            userView_.isHidden = true
            historyView_.isHidden = false
            listView_.isHidden = true
            self.loadHistory()
            }
            else{
            userView_.isHidden = false
            historyView_.isHidden = true
            listView_.isHidden = true
            
            }
        
    }
    
    //MARK: Search Product
    @objc func searchProduct(_ sender: Any){
        
        view.endEditing(true)
        
        if listView_.searchTXT.text != "" {
             if Reachability_A.isConnectedToNetwork(){
                
                showActivityIndicatory(uiView: listView_, container: container , actInd: actInd)
                self.tittleArray.removeAll()
                self.imageArray.removeAll()
                self.priceArrayArray.removeAll()
                self.idArrayArray.removeAll()
                           
                           
                self.listView_.mainTableView.reloadData()
                self.listView_.mainTableView.isHidden = true
                self.loadProducts()
                self.saveProduct()
                
                
                
            }
             else{
                let snackbar = TTGSnackbar(message: "Sin Conexion a Internet", duration: .middle)
                snackbar.show()
            }
            
            
        }else{
            listView_.searchTXT.layer.borderColor = UIColor.red.cgColor
            listView_.searchTXT.layer.borderWidth = 1
            let snackbar = TTGSnackbar(message: "Introduce un producto", duration: .middle)
            snackbar.show()
            
        }
        
    }
    
    
    
    private func loadProducts(){
    
        searchString = listView_.searchTXT.text
        
        let trm = searchString.trimmingCharacters(in: .whitespaces)
        
        
        
        let baseURL = "https://shoppapp.liverpool.com.mx/appclienteservices/services/v3/plp?force-plp=true&search-string=\(trm)&page-number=\(pageNo)&number-of-items-per-page=20"
        
        debugPrint("Base URL \(baseURL)")
        
        
        Alamofire.request(baseURL, method: .get , parameters: nil ,encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
                  
                  self.actInd.stopAnimating()
                  self.container.isHidden = true
            
           
              
                  
                  if let status = response.response?.statusCode {
                                 switch(status){
                                 case 200:
                                    
                                    self.listView_.mainTableView.isHidden = false
                                   
                                  if let result = response.result.value {
                                  
                                  let json_ = JSON(result)
                                  let data =  json_["status"];
                                    
                                    let status = json_["status"]["status"].string
                                    
                                    if status == "OK"{
                                        let results = json_["plpResults"]
                                        let records = results["records"].array!
                                       
                                        if records.count > 0{
                                            
                                            for i in 0..<records.count{
                                                let tittle_ =   records[i]["productDisplayName"].string!
                                                let id_ = records[i]["productId"].string!
                                                let price = records[i]["maximumListPrice"].int!
                                                let image_ =  records[i]["smImage"].string!
                                                    
                                                self.tittleArray.append(tittle_)
                                                self.idArrayArray.append(id_)
                                                self.priceArrayArray.append(price)
                                                self.imageArray.append(image_)
                                            }
                                            
                                            
                                            debugPrint("Result Data \(self.tittleArray)")
                                            
                                            self.listView_.mainTableView.reloadData()
                                            
                                        }else{
                                            let snackbar = TTGSnackbar(message: "No encontramos ningun criterio", duration: .middle)
                                                snackbar.show()
                                            
                                              self.listView_.mainTableView.isHidden = true
                                        }
                                       
                                        
                                    }else{
                                        let snackbar = TTGSnackbar(message: "Hubo un error intenta mas tarde", duration: .middle)
                                            snackbar.show()
                                                                         
                                    }
                                
                                      
                                  }
                                   
                                  
                                  
                                  break
                              
                                 default:
                                  
                                  let snackbar = TTGSnackbar(message: "Hubo un error intenta mas tarde", duration: .middle)
                                      snackbar.show()
                                  
                                  
                                  break
                                  
                                  
                      }
                  }
                            
                
              
              }
        
    }
    
    
    //MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == listView_.mainTableView{
          return tittleArray.count
         }else{
            return historyArray.count
        }
          
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView ==  listView_.mainTableView{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as!listCell
              
            cell.tittleTXT.text = tittleArray[indexPath.row]
            cell.idTXT.text = idArrayArray[indexPath.row]
            cell.priceTXT.text = "$\(priceArrayArray[indexPath.row])"

            cell.productView.sd_setImage(with: URL(string: imageArray[indexPath.row]))
                  
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as!historyCell
            
            cell.productTXT.text = historyArray[indexPath.row]
            cell.dateTXT.text = dateArray_[indexPath.row]
            
            return cell
            
        }
        
      
       
     }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == listView_.mainTableView{
            return 150
            
        }else{
            return 50
        }
       
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if ((listView_.mainTableView.contentOffset.y + listView_.mainTableView.frame.size.height) >= listView_.mainTableView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.limit * self.pageNo
                
                debugPrint("Load new Page \(pageNo)")
                
                showActivityIndicatory(uiView: listView_, container: container , actInd: actInd)
                self.loadProducts()
                
                //loadCallLogData(offset: self.offset, limit: self.limit)

            }
        }


    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        listView_.searchTXT.text = historyArray[indexPath.row]
        
        userView_.isHidden = true
        historyView_.isHidden = true
        listView_.isHidden = false
        
        sc.selectedSegmentIndex = 0
        
        
    }
    
    
    //MARK: Save History
    

    private func saveProduct(){
       
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        print("date XT " + dateFormatter.string(from: date))
        
        let searchString = listView_.searchTXT.text!
        let trm = searchString.trimmingCharacters(in: .whitespaces)
        let product = History(context: persitantService.context)
        product.search = trm
        product.date = dateFormatter.string(from: date)
        
        persitantService.saveContext()
        
        self.historyView_.mainTableView.reloadData()
        
    }
    
    //MARK: Keyboard
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
    
    
    //MARK: Core Data
        private func loadUsers(){
                 let  fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            
                do{
                    let userCoreData = try
                        persitantService.context.fetch(fetchRequest)
                           self.userCoreData = userCoreData
                           if userCoreData.count > 0 {
                            let userNames = userCoreData[0].user!
                            debugPrint("User CoreData  DB Total  \(userCoreData)")
                            debugPrint("User Array 0 \(userNames)")
                            for index in 0..<userCoreData.count{
                                               
                            let user_ =  userCoreData[index].user!
                            userArray.append(user_)
                                
                            }
                            
                           }else{
                            
                              
                            }
                           
                       }catch{}
            }
    
    
    func loadHistory(){
     
        let  fetchRequest: NSFetchRequest<History> = History.fetchRequest()
                   
                       do{
                           let historyCoreData = try
                               persitantService.context.fetch(fetchRequest)
                                  self.historyCoreData = historyCoreData
                                  if historyCoreData.count > 0 {
                                    let product_ = historyCoreData[0].search!
                                  
                                   debugPrint("History  DB Total  \(product_)")
                                   debugPrint("Hsitory Array 0 \(product_)")
                                   for index in 0..<historyCoreData.count{
                                    
                                    let pr = historyCoreData[index].search!
                                    let dt = historyCoreData[index].date!
                                    
                                    historyArray.append(pr)
                                    dateArray_.append(dt)
                                                      
                                       
                                   }
                                self.historyView_.mainTableView.reloadData()
                                   
                                  }else{
                                   
                                     
                                   }
                                  
                              }catch{}
    }


}
