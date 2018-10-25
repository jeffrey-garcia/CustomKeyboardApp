//
//  ViewController.swift
//  CustomKeyboardApp
//
//  Created by jeffrey on 25/10/2018.
//  Copyright © 2018 Jeffrey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initData()
    }

    private func initData() {
        let userDefaults = UserDefaults.init(suiteName: "group.custom.keyboard.app")
        userDefaults?.set("12345", forKey: "CustomNumber")
        userDefaults?.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

