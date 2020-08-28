//
//  InjectableScrollView.swift
//  chatapp
//
//  Created by Kris Rudolph on 2/15/17.
//  Copyright © 2017 Outlook Amusements, Inc. All rights reserved.
//
import UIKit

protocol InjectableScrollViewDelegate: UIScrollViewDelegate {
    func injectableScrollView(_ injectableScrollView: InjectableScrollView, didMoveToPage page: Int)
}

class InjectableScrollView: UIScrollView {
    weak var pagingDelegate: InjectableScrollViewDelegate?
    /// When set, the `pageControl`'s `currentPage` and `numberOfPages` will be magically set to match the scroll view's state.
    weak var pageControl: UIPageControl? {
        didSet {
            //  If user calls `addPages` before setting `pageControl`
            pageControl?.numberOfPages = pages.count
        }
    }
    
    /// The currently active page
    var currentPage: Int {
        return currentPage(for: self.contentOffset)
    }

    /// Keeps track of the pages that are added to the scrollview
    fileprivate(set) var pages = [UIViewController]() {
        didSet {
            //  If user sets `pageControl` before calling `addPages`
            pageControl?.numberOfPages = pages.count
        }
    }

//    override init(frame _: CGRect) {
//        FirebaseCrashMessage("InjectableScrollView is intended for use with storyboards.")
//        fatalError()
//    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        delegate = self
    }

    /**
     Adds view controllers as pages to the scroll view.
     - Important: Call only once.
     - Parameter pages: The view controllers (in order) to add as subviews of the scrollview.
     - Parameter pvc: The view controller that is the scrollView's parent.
     */
    func addPages(pages: [UIViewController], inParentViewController pvc: UIViewController) {
        precondition(self.pages.count == 0, "InjectableScrollView already has pages added.") // until support is added to remove pages etc.
        self.pages = pages

        for (index, page) in pages.enumerated() {
            addPage(page: page, atIndex: index, inParentViewController: pvc)
        }
    }

    fileprivate func addPage(page: UIViewController, atIndex _: Int, inParentViewController pvc: UIViewController) {
        page.willMove(toParent: pvc)
        pvc.addChild(page)
        insertSubview(page.view, at: 0)
        page.didMove(toParent: pvc)
    }
}

// MARK: - Adjustments
extension InjectableScrollView {
    override func layoutSubviews() {
        for (index, _) in pages.enumerated() {
            adjustFrame(forPageAtIndex: index)
        }

        updateContentSize()
    }

    /**
     When rotating, the `contentSize` changes for each page. We must also adjust the `contentOffset` to reflect the change.
     Unfortunately we cannot make changes to contentOffset in `layoutSubviews` because that interferes with swiping.
     - Parameter newSize: The size the scrollView will be after rotation.
     */
    func updateContentOffsetToAccountForRotation(newSize: CGSize) {
        let currentPg = currentPage(for: contentOffset)

        //  allow system to update layout first
        DispatchQueue.main.async(execute: {
            self.contentOffset = CGPoint(x: self.offset(forPageAtIndex: currentPg, inSize: newSize), y: 0)
        })
    }

    /**
     Adjusts the view frame for the page at the given index.
     - Parameter index: The index of the page to be adjusted.
     */
    fileprivate func adjustFrame(forPageAtIndex index: Int) {
        let page = pages[index]
        page.view.frame = frame.offsetBy(dx: offset(forPageAtIndex: index), dy: 0)
    }

    ///  Updates the `contentSize` to account for all added `pages`.
    fileprivate func updateContentSize() {
        contentSize = CGSize(width: offset(forPageAtIndex: pages.count), height: bounds.size.height)
    }

    fileprivate func offset(forPageAtIndex index: Int) -> CGFloat {
        return offset(forPageAtIndex: index, inSize: bounds.size)
    }

    fileprivate func offset(forPageAtIndex index: Int, inSize size: CGSize) -> CGFloat {
        return CGFloat(index) * size.width
    }
}

// MARK: - UIScrollViewDelegate / pageControl
extension InjectableScrollView: UIScrollViewDelegate {
    func goToPage(_ pageIndex: Int) {
        if pageIndex < 0 || pageIndex > pages.count - 1 { return }
        self.setContentOffset(CGPoint.init(x: CGFloat(pageIndex) * self.bounds.size.width, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageControl(withOffset: scrollView.contentOffset)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pagingDelegate?.injectableScrollView(self, didMoveToPage: currentPage)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pagingDelegate?.injectableScrollView(self, didMoveToPage: currentPage)
    }

    fileprivate func updatePageControl(withOffset offset: CGPoint) {
        pageControl?.currentPage = currentPage(for: offset)
    }

    fileprivate func currentPage(for target: CGPoint) -> Int {
        return Int((target.x + bounds.size.width / 2) / bounds.size.width)
    }
}
