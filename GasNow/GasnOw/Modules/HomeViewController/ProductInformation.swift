//
//  ProductInformation.swift
//  GasnOw
//
//  Created by Dev iOS on 8/5/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import Foundation

final class ProductInformation {
    var id: Int = 0
    var name: String = ""
    var image: String = ""
    var description: String = ""
    var price: Int = 0
    var emailId : String = ""
    var product_quantity: Int = 0
    var documentId : String = ""
}

final class OrderItems {
    var product_quantity: Int = 0
    var product_id: Int = 0
    var product_price: String = ""
    var delivery_date: String = ""
    var useremail: String = ""
    var product_orderid: String = ""
    var total_amount : String = ""
    var product_name: String = ""
    var documentId : String = ""
    var payment_mode: String = ""
    var product_image: String = ""
    /*
     ["no_of_items": 6, "product_id": 3, "product_price": 399, "delivery_date": 2020-08-14-22-2020-06:22:21, "useremail": iosdev@mailinator.com, "product_orderid": order_1597409541292, "total_amount": 2394, "product_name": 19 KG, "product_description": Gas Description, "payment_mode": payfast, "product_image": https://firebasestorage.googleapis.com/v0/b/gasnow-442eb.appspot.com/o/products%2FArtboard%201.png?alt=media&token=7cb26fd2-b89e-47d2-833d-b636b00d73d8]
     */
}
final class CartInforemation {
    var id: Int = 0
    var name: String = ""
    var image: String = ""
    var description: String = ""
    var price: Int = 0
}
