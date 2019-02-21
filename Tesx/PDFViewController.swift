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
        for index in 0...5 {
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
        }
        return true
    }
    
    
    /**
     Creates a curl animation left (back) comeback a one page.
     
     - Parameter pVC : main PVC , VCBefore a before page
     
     - Throws: `index out of range` ``
     
     - Returns: A new string saying hello to `recipient`.
     */
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.index(of: viewController) else { return nil }
        guard index > 0 else {
            return nil
        }
        return controllers[index - 1]
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
        guard let index = controllers.index(of: viewController) else { return nil }
        guard index < controllers.count - 1 else {
            return nil
        }
        return controllers[index + 1]

    }
    
}
