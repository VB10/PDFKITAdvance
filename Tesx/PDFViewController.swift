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
    var _controllers = [Int: CustomViewController]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = UIColor.gray
        
        setupPDFView()
    }
    
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        
    }
    override func endAppearanceTransition() {
        
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
    }
    
    
    func setupPDFView(){
        guard let path = Bundle.main.path(forResource: "swift", ofType: "pdf") else {
            print("pdf file not found")
            return }
        let url = URL(fileURLWithPath: path)
        pdfDocument = PDFDocument(url: url)
        guard addViewController() else {
            return
        }
        //controllers[0] must because is required spinlocation.min params.
        setViewControllers([controllers[0]], direction: .forward, animated: true)
        
    }
    
    /**
     Creates a add VC  for a page view controller.
     
     - Parameter : -
     
     - Throws: `Index out of bound's fix guardlet.
     
     - Returns: A new boolean value saying add complete & add fail(last page & not found)
     */
    func addViewController() -> Bool {
       
            let pdfView: PDFView = PDFView(frame: self.view.frame)
            guard let page = self.pdfDocument?.page(at: 0) else {
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
        
        let _vcCustom = CustomViewController()
        
            controllers.append(vc)
         _controllers[currentPageNumber] = _vcCustom
        return true
    }
    
    func addViewController(to index: Int) -> Bool {
       

            let pdfView: PDFView = PDFView(frame: self.view.frame)
            guard let page = self.pdfDocument?.page(at: index) else {
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
            controllers.append(vc)
        
        let _vcCustom = CustomViewController()
        
        _controllers[index] = _vcCustom
        

        if controllers.count > 3  {
            controllers.remove(at: 0 )
        }
//
        
        return true
    }
    
    func addViewControllerBack(to index: Int) -> Bool {
        
        let pdfView: PDFView = PDFView(frame: self.view.frame)
        guard let page = self.pdfDocument?.page(at: currentPageNumber ) else {
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
        
        let _vcCustom = CustomViewController()
        
        _controllers[currentPageNumber] = _vcCustom
        
        if controllers.count > 3  {
            controllers.remove(at: 3 )
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
        
        

        guard addViewControllerBack(to:  1) else {
            return nil
        }
        return _controllers[currentPageNumber]

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
        
        
        //        currentPageNumber += 1
        //        guard addViewControllerBack(to: index - 1 ) else {
        //            return nil
        //        }
        
        
        let currentController = _controllers[currentPageNumber]
        
        var x = _controllers[currentPageNumber]?.islock ? false : r
        

        guard (_controllers[currentPageNumber] as! CustomViewController).islock == false else {
            print("gelmediki")
            return nil
        }
        currentPageNumber += 1
        guard addViewController(to:  1) else {
            return nil
        }
        return _controllers[currentPageNumber]

    }
    
}
