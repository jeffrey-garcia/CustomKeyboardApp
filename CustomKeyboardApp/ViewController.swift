//
//  ViewController.swift
//  CustomKeyboardApp
//
//  Created by jeffrey on 25/10/2018.
//  Copyright © 2018 Jeffrey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var inputTextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initData()
        
        self.initUI()
    }

    private func initUI() {
        print("\(NSStringFromClass(object_getClass(self)!)) - initUI()")
        
        if let view = self.view.viewWithTag(1) { // follow the tag defined in the Interface Builder of the button
            if view is UITextField {
                print("view 1 is \(NSStringFromClass(object_getClass(view)!))")
                self.inputTextField = view as? UITextField
                //inputTextField?.addTarget(self, action: #selector(initData), for: .touchUpInside)
            }
        }
        
        if let view = self.view.viewWithTag(2) { // follow the tag defined in the Interface Builder of the button
            if view is UIButton {
                print("view 1 is \(NSStringFromClass(object_getClass(view)!))")
                let updateButton = view as? UIButton
                updateButton?.addTarget(self, action: #selector(initData), for: .touchUpInside)
            }
        }
    }
    
    @objc private func initData() {
        let userDefaults = UserDefaults.init(suiteName: "group.custom.keyboard.app")
        
        if let customValue = self.inputTextField?.text {
            userDefaults?.set(customValue, forKey: "CustomNumber")
        } else {
            userDefaults?.set("12345", forKey: "CustomNumber") // default
        }
        
        userDefaults?.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

