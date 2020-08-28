//
//  MainTabBarController.swift
//  Psychic Connections
//
//  Created by Mac PC 2 on 4/9/18.
//  Copyright © 2018 Office Mac. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    var indicatorImage: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = UIColor.orange
        //self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let width = (tabBar.frame.width / CGFloat(tabBar.items!.count))
        let height = tabBar.frame.height
        let rect: CGRect = CGRect.init(x: 0, y: 0, width:width, height:height)
        indicatorImage = UIImageView(image:imageWithColor(color: UIColor.white,cgrect:rect))
        indicatorImage?.center.x =  tabBar.frame.width/4/2
        self.tabBar.addSubview(indicatorImage!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
       //Tab bar options
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
          tabItem(tag: item.tag,tabBar: tabBar)
    }
    
    //create Image for tab item background
    func imageWithColor(color: UIColor,cgrect:CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: cgrect.size.width, height: cgrect.size.height), false, 0)
        color.setFill()
        UIRectFill(cgrect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func tabItem(tag: Int,tabBar: UITabBar){
           if tag == 1{
               self.indicatorImage?.center.x =  tabBar.frame.width/4/2
           }else if tag == 2{
            
               self.indicatorImage?.center.x =  tabBar.frame.width/4/2 + tabBar.frame.width/4
           }else if tag == 3{

               self.indicatorImage?.center.x =  tabBar.frame.width/4/2 + tabBar.frame.width/2
           }else if tag == 4{

               self.indicatorImage?.center.x = tabBar.frame.width - tabBar.frame.width/4/2
           }else if tag == 5{
               // Log added to Firebase & Mixpanel
           }
          // bounceAnimation(forItem: tag)
       }
}
extension UITabBar {
    func hiddenTabBar(_ active: Bool){
         isHidden = active
         isTranslucent = active
    }
}
