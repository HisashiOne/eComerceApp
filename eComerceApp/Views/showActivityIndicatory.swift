//
//  showActivityIndicatory.swift
//  eComerceApp
//
//  Created by Oswaldo Morales on 6/28/20.
//  Copyright © 2020 Oswaldo Morales. All rights reserved.
//

import Foundation
import UIKit


func showActivityIndicatory(uiView: UIView, container: UIView, actInd: UIActivityIndicatorView) {
    
    
    container.frame = uiView.frame
    container.center = uiView.center
    container.backgroundColor = UIColor(red:0.10, green:0.10, blue:0.10, alpha:0.7)
    
    
    let loadingView: UIView = UIView()
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = uiView.center
    loadingView.backgroundColor = .black
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    loadingView.alpha = 0.9
    
    
    actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
    actInd.style = UIActivityIndicatorView.Style.whiteLarge
    actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y:
        loadingView.frame.size.height / 2);
    //actInd.assignColor(UIColor.green)
    loadingView.addSubview(actInd)
    container.addSubview(loadingView)
    uiView.addSubview(container)
    actInd.startAnimating()
}





