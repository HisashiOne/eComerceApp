//
//  listCell.swift
//  eComerceApp
//
//  Created by Oswaldo Morales on 6/28/20.
//  Copyright © 2020 Oswaldo Morales. All rights reserved.
//

import UIKit

class listCell: UITableViewCell {

    @IBOutlet weak var productView: UIImageView!
    
    @IBOutlet weak var idTXT: UILabel!
    
    @IBOutlet weak var tittleTXT: UILabel!
    
    @IBOutlet weak var priceTXT: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
