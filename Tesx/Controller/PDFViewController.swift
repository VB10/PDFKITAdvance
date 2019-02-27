//
//  PDFViewController.swift
//  Tesx
//
//  Created by VB on 20.02.2019.
//  Copyright © 2019 VB. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIPageViewController , UIPageViewControllerDataSource , PDFViewDelegate , PDFDocumentDelegate  {
    
    
    var controllers = [UIViewController]()
    var pdfDocument : PDFDocument?
    var currentPageNumber : Int = 0
    var _isBack : Bool = false
    var viewd : PDFThumbnailView?
    
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
    
    /**
     Creates a add VC  for a page view controller.
     
     - Parameter : index current page
     
     - Condinitial : check last and next page add controller sate
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
        pdfView.isUserInteractionEnabled = true
        pdfView.go(to: page)
        let vc = UIViewController()
        vc.view = pdfView
        
        //if 3 use because is android native like fragmentstateadapter structure
         if _isBack {
            //left hand move ,  remove last data and new page add first index
            controllers.insert(vc, at: 0)
            if controllers.count > 3  {
                controllers.remove(at: 3)
            }
            
        } else {
            //right hand move ,  remove first data and new page add last index
            controllers.append(vc)
            if controllers.count > 3  {
                controllers.remove(at: 0)
            }
        }
        return true
    }
    
    
    /**
     Creates a curl animation left (back) comeback a one page.
     
     - Parameter pVC : main PVC , VCBefore a before page
     
     - Throws: `index out of range` ``
     
     - Returns: page idex vc or nil`.
     */
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        _isBack = true
        return currentPageNumber == 0 ? nil :  controllers.first
        
    }
    
    /**
     Creates a curl animation  right (next) comeback a one page.
     
     - Parameter pVC : main PVC , VCAfter a after page
     
     - Throws: `index out of range` ``
     
      - Returns: page idex vc or nil`.
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        _isBack = false
        return controllers.last
        
    }
    
}


extension PDFViewController: UIPageViewControllerDelegate {

    
    /**
     Page curl animation handle.
     
     - Parameter pVC : new page , finish param , pre vc , transition bool
     
     - Throws: `index out of range` ``
     
     - Returns: new page add main controller .
     */
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        currentPageNumber += _isBack ?   -1 :   1
        controllers.last?.view.isUserInteractionEnabled = true
        let nextPageNumber = _isBack ?  currentPageNumber - 1 : currentPageNumber + 1
        guard addViewController(to:  nextPageNumber) else {
            print("error not added")
            currentPageNumber = 0
            return
        }
        
    }
}
