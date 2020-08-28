//
//  OnboardPagingViewController.swift
//  chatapp
//
//  Created by Lee Balser on 2/15/17.
//  Copyright © 2017 Outlook Amusements, Inc. All rights reserved.
//

import UIKit


protocol SplashPagingViewControllerDelegate: class {
//    func comoPagingViewControllerDidFinish(_ onboardPagingViewController: ComoPagingViewController)
//    func comoPagingViewControllerSetupAddFundsWasTapped(_ onboardPagingViewController: ComoPagingViewController)
}

class SplashPagingViewController: UIViewController, UIScrollViewDelegate {
    var coordinationDelegate: SplashPagingViewControllerDelegate?
    @IBOutlet weak var scrollView: InjectableScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnLogin: UIButton!
     @IBOutlet weak var btnContinueWithoutRegister: UIButton!
    @IBOutlet weak var btnRegister: UIButton!

    
    @IBOutlet weak var loginButtonHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Log Screen Name in Firebase & Mixpanel
         self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.hideNavigationLine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPage(0)
        let tutorialPages = SplashDataSource.defaultTutorialPages
        tutorialPages.forEach({ vc in
            vc.pagingViewController = self
            vc.coordinatorDelegate = self.coordinationDelegate
        })
        scrollView.addPages(pages: tutorialPages, inParentViewController: self)
        scrollView.pageControl = pageControl
        scrollView.pagingDelegate = self
        scrollView.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        let accountVC = storyBoard.instantiateViewController(withIdentifier: AccountVC.stringRepresentation) as! AccountVC
        self.navigationController?.pushViewController(accountVC, animated:true)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        //  Tell the scrollView that the viewController is experiencing a rotation
        if scrollView != nil {
           scrollView.updateContentOffsetToAccountForRotation(newSize: size)
        }
    }
}

//  MARK: - Paging

extension SplashPagingViewController: InjectableScrollViewDelegate {
    func injectableScrollView(_ injectableScrollView: InjectableScrollView, didMoveToPage page: Int) {
      //  setPage(page)
        print("didMoveToPage")
    }
    
    
    @IBAction func NextBtnTapped(_: UIButton) {
        if scrollView.currentPage < SplashDataSource.defaultDataSources.count - 1 {
        scrollView.goToPage(scrollView.currentPage + 1)
        }else if scrollView.currentPage == SplashDataSource.defaultDataSources.count - 1  {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let accountVC = storyBoard.instantiateViewController(withIdentifier: AccountVC.stringRepresentation) as! AccountVC
            self.navigationController?.pushViewController(accountVC, animated:true)
        }
    }
    
    fileprivate func setPage(_ pageIndex: Int) {
//        UIView.animate(withDuration: 0.15) {
//            if pageIndex == 0 {
//                self.leftArrow.alpha = 0
//                self.rightArrow.alpha = 1
//                // Log added to Firebase & Mixpanel
//            } else if pageIndex == self.scrollView.pages.count - 1 {
//               self.leftArrow.alpha = 1
//                self.rightArrow.alpha = 0
//                // Log added to Firebase & Mixpanel
//            } else {
//             self.leftArrow.alpha = 1
//                self.rightArrow.alpha = 1
//                // Log added to Firebase & Mixpanel
//            }
//        }
    }
    
   
}
