//
//  PFViewController.swift
//  Tesx
//
//  Created by Veli Bacik on 19.02.2019.
//  Copyright © 2019 VB. All rights reserved.
//

import UIKit
import PDFKit

class PFViewController: UIViewController {

    var _pdfView : PDFView?
    @IBOutlet weak var pdfView: PDFView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pdfView = _pdfView

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
