//
//  CustomViewController.swift
//  Tesx
//
//  Created by Veli Bacik on 21.02.2019.
//  Copyright © 2019 VB. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    var islock : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        islock = true
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
