//
//  PDFViewController.swift
//  Tesx
//
//  Created by VB on 20.02.2019.
//  Copyright © 2019 VB. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIPageViewController , UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var controllers = [UIViewController]()
    var pdfDocument : PDFDocument?
    var currentPageNumber : Int = 0
    var _controllers = [Int: UIViewController]()
    var _isBack : Bool = false
    var _isAnimationComplete : Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = UIColor.gray
        setupPDFView()
  
    }
    
    
 

    
    func setupPDFView(){
        guard let path = Bundle.main.path(forResource: "swift", ofType: "pdf") else {
            print("pdf file not found")
            return }
        let url = URL(fileURLWithPath: path)
        pdfDocument = PDFDocument(url: url)
        guard addViewController(to : 0) else {
            return
        }
        guard addViewController(to: 1) else {
            return
        }
        //controllers[0] must because is required spinlocation.min params.
        setViewControllers([controllers[0]], direction: .forward, animated: true)
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed  &&  finished {
            
            _isAnimationComplete = true
            currentPageNumber += _isBack ?   -1 :   1
            let nextPageNumber = _isBack ?  currentPageNumber - 1 : currentPageNumber + 1
            guard addViewController(to:  nextPageNumber) else {
                print("error not added")
                currentPageNumber = 0
                return
            }
        }
  
    }
    /**
     Creates a add VC  for a page view controller.
     
     - Parameter : -
     
     - Throws: `Index out of bound's fix guardlet.
     
     - Returns: A new boolean value saying add complete & add fail(last page & not found)
     */

    func addViewController(to index: Int) -> Bool {
        
        
        let pdfView: PDFView = PDFView(frame: self.view.frame)
        guard let page = self.pdfDocument?.page(at: index) else {
            if currentPageNumber == 0 {
                if controllers.count > 2 {
                    controllers.remove(at: 2)
                }
            }

            print("page not found.")
            return  false}
        pdfView.document = pdfDocument
        pdfView.displayMode = .singlePage
        pdfView.usePageViewController(true)
        pdfView.isUserInteractionEnabled = false
        pdfView.go(to: page)
        pdfView.autoScales = true
        let vc = UIViewController()
        vc.view = pdfView
      
        vc.viewDidAppear(true)
        
      
        if _isBack {
        
                controllers.insert(vc, at: 0)
                if controllers.count > 3  {
                    controllers.remove(at: 3)
                }
            
          
        } else {
            controllers.append(vc)
            if controllers.count > 3  {
                controllers.remove(at: 0)
            }
        }
      
       
      
        //
        
        return true
    }
    
    
    /**
     Creates a curl animation left (back) comeback a one page.
     
     - Parameter pVC : main PVC , VCBefore a before page
     
     - Throws: `index out of range` ``
     
     - Returns: A new string saying hello to `recipient`.
     */
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        _isBack = true
        if currentPageNumber == 0  {
            return nil
        }
        return controllers.first
        
    }
    
    /**
     Creates a personalized greeting for a recipient.
     
     - Parameter recipient: The person being greeted.
     
     - Throws: `MyError.invalidRecipient`
     if `recipient` is "Derek"
     (he knows what he did).
     
     - Returns: A new string saying hello to `recipient`.
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //        guard let index = controllers.index(of: viewController) else { return nil }
        //        guard currentPageNumber <= controllers.count else {
        //            return nil
        //        }
        
        _isBack = false
        return controllers.last
        
    }
    
}

//extension MyPageVC: UIPageViewControllerDelegate {
//
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        self.view.isUserInteractionEnabled = false
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        self.view.isUserInteractionEnabled = true
//    }
//}
