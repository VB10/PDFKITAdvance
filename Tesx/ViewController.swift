//
//  ViewController.swift
//  Tesx
//
//  Created by VB on 8.02.2019.
//  Copyright © 2019 VB. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pageController: UIPageViewController!
    var controllers = [UIViewController]()
    var pageCount : Int?
    var pdfDocument : PDFDocument?
    var currentCount : Int = 0
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        var x = controllers[currentCount].view as! PDFView
//        
//        if UIDevice.current.orientation.isLandscape{
//            (controllers[currentCount].view as! PDFView).usePageViewController(false, withViewOptions: nil)
//            
//            print("landscape")
//            (controllers[currentCount].view as! PDFView).displayMode = .twoUp
//            
//            (controllers[currentCount].view as! PDFView).sizeToFit()
//            //            (controllers[currentCount].view as! PDFView).sizeThatFits(CGSize(width: 100, height: 100))
//        }
//        else{
//            x.displayMode = .singlePage
//            x.autoScales = true
//            //            x.usePageViewController(true, withViewOptions: nil)
//            ////            x.layoutMargins = UIEdgeInsets(top: 1000, left: 0, bottom: 0, right: 0)
//            //            x.documentView?.layoutMargins = UIEdgeInsets(top: 1000, left: 0, bottom: 0, right: 0)
//            
//            //            (controllers[currentCount].view as! PDFView).siz = .singlePage
//            
//        }
//        //        if UIDevice.current.orientation.isLandscape{
//        //            print("landscape")
//        //    controllers[currentCount].view.backgroundColor = UIColor.red
//        //    (controllers[currentCount].view as! PDFView).displayMode = .twoUp
//        //        } else {
//        //            print("portrait")
//        //    controllers[currentCount].view.backgroundColor = UIColor.gray
//        //
//        //    (controllers[currentCount].view as! PDFView).displayMode = .singlePage
//        //
//        //        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        currentCount = 0
//        addChild(pageController)
        self.view = pageController.view
        pageCount = 0
        
        setupPDFView()
        //        addObservers()
    }
    
    //    private func addObservers() {
    //        NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange(notification:)), name: Notification.Name.PDFViewPageChanged, object: nil)
    //    }
    //    @objc private func handlePageChange(notification: Notification) {
    //        print("we changed pages")
    //    }
    func setupPDFView(){
        guard let path = Bundle.main.path(forResource: "swift", ofType: "pdf") else { return }
        
        let url = URL(fileURLWithPath: path)
        pdfDocument = PDFDocument(url: url)
        pageCount = pdfDocument!.pageCount - 1
        addPageVC(start: 0,end: 10)
        pageController.setViewControllers([controllers[0]], direction: .forward, animated: false, completion: nil)
        pageController.isDoubleSided = true
        //        pageController.setViewControllers([controllers[0]], direction: .forward, animated: true)
    }
    
    
    
    //    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
    //        switch toInterfaceOrientation {
    //
    //    }
    func addPageVC(start : Int, end : Int)  {
        for index in start...end {
            let pdfView: PDFView = PDFView(frame: self.view.frame)
            let page: PDFPage = pdfDocument!.page(at: index)!
            pdfView.document = pdfDocument
            pdfView.displayMode = UIDevice.current.orientation.isLandscape ? .singlePage :  .twoUp
            
            
            pdfView.isUserInteractionEnabled = false
            pdfView.go(to: page)
            pdfView.autoScales = true
            
            //            pdfView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            //            pdfView.documentView?.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            let vc = ViewController()
            vc.view = pdfView
            vc.view.backgroundColor = UIColor.gray
            controllers.append(vc)
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = controllers.index(of: viewController) {
            if index > 0 {
                currentCount = index - 1
                return controllers[index - 1]
            } else {
                return nil
            }
        }
        
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController) {
            currentCount = index + 1
            if index < controllers.count - 1 {
                if UIDevice.current.orientation.isLandscape{
                    print("landscape")
                    (controllers[currentCount].view as! PDFView).displayMode = .twoUp
                    
                }
                else{
                    (controllers[currentCount].view as! PDFView).displayMode = .singlePage
                }
                //                else {
                //                    print("portrait")
                //                    controllers[currentCount].view.backgroundColor = UIColor.gray
                //
                //                    (controllers[currentCount].view as! PDFView).displayMode = .singlePage
                //
                //                }
                return controllers[index + 1]
            } else {
                //pageleme mantığı 5 5 üzerine son gelen sayfalar için fix
                
                if index + 5 < pageCount! {
                    addPageVC(start: index, end: index + 5)
                }
                else  {
                    if index > controllers.count - 1 {
                        return nil
                    }
                    addPageVC(start: index, end: pageCount!)
                }
                
                return controllers[index + 1]
                
            }
            
            
        }
        
        return nil
    }
    
}
