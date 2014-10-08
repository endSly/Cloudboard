//
//  KeyboardViewController.swift
//  Wiboard-Keyboard
//
//  Created by Endika Gutiérrez Salas on 07/10/14.
//  Copyright (c) 2014 Endika Gutiérrez Salas. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    var httpServer: HTTPServer?

    var keyboardView: KeyboardView!

    override func updateViewConstraints() {
        super.updateViewConstraints()

        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiateWithOwner(self, options: nil)
        keyboardView = objects[0] as KeyboardView
        keyboardView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.view.addSubview(keyboardView)

        keyboardView.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)

        let server = HTTPServer()
        server.setType("_http._tcp.")
        server.setConnectionClass(HTTPWiboardConnection)

        let path = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("web.bundle")
        server.setDocumentRoot(path)

        var error: NSError?

        if server.start(&error) {
            NSLog("Listening \(server.listeningPort())")
        } else {
            NSLog("Error \(error)")
        }

        httpServer = server
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.

    }

}
