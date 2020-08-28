//
//  CartCell.swift
//  GasnOw
//
//  Created by Dev iOS on 8/2/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var lbl_product_price : UILabel!
    @IBOutlet weak var lbl_product_name : UILabel!
    @IBOutlet weak var img_product: UIImageView!
   // @IBOutlet weak var lbl_product_delivery_type : UILabel!
    @IBOutlet weak var lbl_product_quantity : UILabel!
    @IBOutlet weak var btn_delete_item : UIButton!
    @IBOutlet weak var btn_add_to_cart : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
