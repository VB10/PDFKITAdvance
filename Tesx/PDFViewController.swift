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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape{
            
//            (controllers[0].view as! PDFView).displayMode = .twoUp
//
            (controllers[0].view as! PDFView).autoScales = true
        }
        else{
//            (controllers[0].view as! PDFView).displayMode = .singlePage
//            (controllers[0].view as! PDFView).sizeToFit()
            (controllers[0].view as! PDFView).autoScales = false

        }
    }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index =  controllers.index(of: viewController) else { return nil}
            if index < 1 {
                return nil
            }
            return controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index =  controllers.index(of: viewController) else { return nil }
            return controllers[index + 2]
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            dataSource = self
            delegate = self
            guard let path = Bundle.main.path(forResource: "swift", ofType: "pdf") else { return }
            
            let url = URL(fileURLWithPath: path)
            pdfDocument = PDFDocument(url: url)
            // Do any additional setup after loading the view.
            
            addPageVC(start: 0, end: 15)
            setViewControllers([(controllers[0])], direction: .forward, animated: true, completion: nil)
        }
        
        
        
        func addPageVC(start : Int, end : Int)  {
            for index in start...end {
                let pdfView: PDFView = PDFView(frame: self.view.frame)
                let page: PDFPage = pdfDocument!.page(at: index)!
                pdfView.document = pdfDocument
                pdfView.displayMode = . twoUp
                pdfView.isUserInteractionEnabled = false
                pdfView.go(to: page)
                pdfView.autoScales = false
                
                pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
                //            pdfView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                //            pdfView.documentView?.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
                let vc = ViewController()
                vc.view = pdfView
                vc.view.backgroundColor = UIColor.gray
                self.controllers.append(vc)
            }
        }
        
}
