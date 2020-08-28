//

//  chatapp
//
//  Created by Lee Balser on 2/15/17.
//  Copyright © 2017 Outlook Amusements, Inc. All rights reserved.
//
import UIKit

/**
 A simple data source for the tutorial pages. Supplies a `detail` and `imageName`.
 */
struct SplashDataSource {
    let title: String
    let detail: String
    let pageIndex: String
    let imageName: String
}
// MARK: - Static data values
extension SplashDataSource {
    static let defaultDataSources: [SplashDataSource] = [.page1, .page2, .page3, .page4, ]
    static let page1 = SplashDataSource(title: "Sign Up",detail: "Sign up now and access the most affordable and innovative LPG Solutions",pageIndex:"1",imageName:"signUpAnimation")
    static let page2 = SplashDataSource(title: "Buy Gas Online",
                                            detail: "Order Online and PAy Securely With Your Credit Card or Pay ON DELIVERY.",pageIndex:"2",imageName: "orderanimation")
    static let page3 = SplashDataSource(title: "Get It Delivered",detail: "We value our customers and pride ourselves on Delivering best prices,brilliant service and the highest quality LP gas to you.",pageIndex:"3",imageName:"deliveredAnimation")
     static let page4 = SplashDataSource(title: "Friendly Support",detail: "Blazing fast order delivery within time!",pageIndex:"4",imageName:"laptopAnimation")
     
}

// MARK: - Create
extension SplashDataSource {
    /// A convenience accessor to populate and return an array of `TutorialPageViewController`s, setup with the `defaultDataSources`
    static var defaultTutorialPages: [SplashViewController] {
        return SplashDataSource.defaultDataSources.map { dataSource in tutorialPage(for: dataSource) }
    }
    
    /**
     A convenience to create and return a tutorial page.
     - Parameter dataSource: The `TutorialDataSource` with which the tutorial page will be setup.
     - Returns: A `TutorialPageViewController`, setup with the given `TutorialDataSource`.
     */
    static func tutorialPage(for dataSource: SplashDataSource) -> SplashViewController {
      
     let vc = UIStoryboard(name: "SplashViewController", bundle: nil).instantiateViewController(withIdentifier: SplashViewController.stringRepresentation) as! SplashViewController
        _ = vc.view
        vc.lbl_description.text = dataSource.detail
        vc.titleLabel.text = dataSource.title
        vc.img.image = UIImage.gif(name: dataSource.imageName)
     return vc
    }
}
