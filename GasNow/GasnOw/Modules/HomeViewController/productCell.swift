//
//  productCell.swift
//  GasnOw
//
//  Created by Dev iOS on 8/1/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit

class productCell: UICollectionViewCell {
    @IBOutlet weak var containerView : UIView!
    static let identifier = "cell"
    @IBOutlet weak var lbl_product_price : UILabel!
    @IBOutlet weak var lbl_product_name : UILabel!
    @IBOutlet weak var img_produc: UIImageView!
    
    override func layoutSubviews() {
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        containerView.layer.shadowRadius = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowOpacity = 0.9
        containerView.layoutIfNeeded()
    }
}
