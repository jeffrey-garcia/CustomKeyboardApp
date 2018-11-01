//
//  KeyboardViewController.swift
//  CustomKeyboardExtension
//
//  Created by jeffrey on 25/10/2018.
//  Copyright © 2018 Jeffrey. All rights reserved.
//

import UIKit
import WebKit

class KeyboardViewController: UIInputViewController {

//    @IBOutlet var nextKeyboardButton: UIButton!
    
//    override func updateViewConstraints() {
//        // adjust a custom keyboard’s height, change its primary view's height constraint
////        let heightConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 500)
////        self.view.addConstraint(heightConstraint)
//        
//        super.updateViewConstraints()
//    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(NSStringFromClass(object_getClass(self)!)) - viewDidLoad()")

        // Init custom Keyboard View
        self.initCustomKeyboardView()
        
        // Observe for user default changes
        NotificationCenter.default.addObserver(self, selector: #selector(self.userDefaultsDidChange(_:)), name:UserDefaults.didChangeNotification, object: nil)
        
        // adjust a custom keyboard’s height, change its primary view's height constraint
        let widthConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0)
        self.view.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 350)
        self.view.addConstraint(heightConstraint)
//        self.nextKeyboardButton.setTitle(NSLocalizedString("Switch Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
//        self.nextKeyboardButton.sizeToFit()
//        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
//
//        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
//
//        self.view.addSubview(self.nextKeyboardButton)
//
//        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(NSStringFromClass(object_getClass(self)!)) - viewDidAppear()")
    }
    
    private func initCustomKeyboardView() {
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        guard let keyboardView = objects[0] as? UIView else {
            fatalError()
        }
        
        if let view = keyboardView.viewWithTag(2),
            let uiButtonOpenHostApp = view as? UIButton
        {
            uiButtonOpenHostApp.setTitle("open host app", for: UIControlState.normal)
            uiButtonOpenHostApp.addTarget(self, action: #selector(openHostApp), for: .touchUpInside)
        }
        
        if let view = keyboardView.viewWithTag(1) {
            if let wkWebView = view as? WKWebView {
                if let url = URL(string:"https://www.manulife.com.hk") {
                    let request = URLRequest(url: url)
                    wkWebView.load(request)
                }
            }
        }
        
        if let view = keyboardView.viewWithTag(3),
            let uiButtonUpdateText = view as? UIButton
        {
            uiButtonUpdateText.setTitle("update text", for: UIControlState.normal)
            uiButtonUpdateText.addTarget(self, action: #selector(updateTextInput), for: .touchUpInside)
        }
        
        if let view = keyboardView.viewWithTag(4),
            let uiButtonSwitchKey = view as? UIButton
        {
            uiButtonSwitchKey.setTitle("switch key", for: UIControlState.normal)
            uiButtonSwitchKey.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .touchUpInside)
        }
        
        self.view.addSubview(keyboardView)
    }
    
    @objc func updateTextInput() {
        // Inserts the string "hello " at the insertion point
        let userDefaults = UserDefaults.init(suiteName: "group.custom.keyboard.app")
        let customValue = userDefaults?.string(forKey: "CustomNumber")
        self.textDocumentProxy.deleteBackward()
        self.textDocumentProxy.insertText(customValue ?? "")
    }
    
    @objc func userDefaultsDidChange(_ notification: Notification) {
        print("userDefaultsDidChange")
        let userDefaults = UserDefaults.init(suiteName: "group.custom.keyboard.app")
        let customValue = userDefaults?.string(forKey: "CustomNumber")
        print("\(customValue ?? "")")
        self.textDocumentProxy.deleteBackward()
        self.textDocumentProxy.insertText(customValue ?? "")
    }
    
    @objc func openHostApp() {
        print("openHostApp")
        // call the host app via custom URL scheme
        if let url = URL.init(string: "testscheme://test") {
            let _ = self.openURL(url: url)
        }
    }

    private func openURL(url: URL) -> Bool {
        do {
            let application = try self.sharedApplication()
            application.performSelector(inBackground: "openURL:", with: url)
            return true
        }
        catch {
            return false
        }
    }
    
    private func sharedApplication() throws -> UIApplication {
        /**
         * Whether the hack of traversing UIResponder chain to open the parent app
         * using openURL will be allowed by apple or not is unknown.
         *
         * However the fact that +[UIApplication sharedApplication], and hence -openURL:,
         * is not available to extensions should be an important hint here.Ignoring that
         * restriction and looking up the symbols via the Objective-C runtime is not a
         * good idea
         *
         * UIResponse is not a private entity, hence usage of UIResponder will not violate
         * the private API usage condition hence apps which are using the above hacks are
         * still being approved by apple. But the fact that, your code parses through the
         * UIResponder chain to trigger the openURL is very costly and not suggested/preferred.
         * As Apple seems to be aware of developer using it, they might start rejecting the
         * app in future.
        */
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }
            responder = responder?.next
        }
        throw NSError(domain: "\(NSStringFromClass(object_getClass(self)!))", code: 1, userInfo: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
//        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
}
