//
//  ViewController.swift
//  Tesx
//
//  Created by VB on 8.02.2019.
//  Copyright © 2019 VB. All rights reserved.
//

import UIKit
import PDFKit

class XViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pageController: UIPageViewController!
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        
        
        addChild(pageController)
        view.addSubview(pageController.view)
        
       setupPDFView()
        
       
    }
    
    func setupPDFView(){
        guard let path = Bundle.main.path(forResource: "swift", ofType: "pdf") else { return }
        let url = URL(fileURLWithPath: path)
       
        guard let pdfDocument = PDFDocument(url: url) else { return }
        let pageCount = pdfDocument.pageCount - 1
//
//        pdfView.displayDirection = .horizontal
//        pdfView.usePageViewController(true)
//        pdfView.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        pdfView.autoScales = true
        for index in 0...5 {
            let pdfView: PDFView = PDFView(frame: self.view.frame)
            let page: PDFPage = pdfDocument.page(at: index)!
            pdfView.document = pdfDocument
            
            pdfView.displayMode = .singlePage
                pdfView.usePageViewController(true)
            pdfView.isUserInteractionEnabled = false
            pdfView.go(to: page)
            pdfView.autoScales = true
            let vc = UIViewController()
            vc.view = pdfView
//            vc.view = pdfView
           controllers.append(vc)
        }
        
        
        
         pageController.setViewControllers([controllers[0]], direction: .forward, animated: true)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController) {
            if index > 0 {
                return controllers[index - 1]
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            } else {
                return nil
            }
        }
        
        return nil
    }
}
