//
//  KeyboardViewController.swift
//  Wiboard-Keyboard
//
//  Created by Endika Gutiérrez Salas on 07/10/14.
//  Copyright (c) 2014 Endika Gutiérrez Salas. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, WiboardServiceDelegate {

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
        //keyboardView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.view.addSubview(keyboardView)

        keyboardView.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)

        let service = WiboardService.sharedService
        service.delegate = self
        service.start()

        self.keyboardView.hostAddrLabel.text = "\( localIPAddress() ):\( service.port )"
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

    // MARK: Wiboard service

    func serviceTextHasInserted(service: WiboardService, text: String) {
        let docProxy = self.textDocumentProxy as UITextDocumentProxy
        docProxy.insertText(text)
    }

    func serviceDeleteBackwardHasInserted(service: WiboardService) {
        let docProxy = self.textDocumentProxy as UITextDocumentProxy
        docProxy.deleteBackward()
    }

    func serviceDidOpenConnection(service: WiboardService) {
    }

    func serviceDidCloseConnection(service: WiboardService) {
    }

    func service(service: WiboardService, didAdjustTextPositionByOffset offset: Int) {
        let docProxy = self.textDocumentProxy as UITextDocumentProxy
        docProxy.adjustTextPositionByCharacterOffset(offset)
    }

    func serviceContentAfterInput(service: WiboardService) -> String {
        let docProxy = self.textDocumentProxy as UITextDocumentProxy
        if let content = docProxy.documentContextAfterInput {
            return content
        }
        return ""
    }

    func serviceContentBeforeInput(service: WiboardService) -> String {
        let docProxy = self.textDocumentProxy as UITextDocumentProxy
        if let content = docProxy.documentContextBeforeInput {
            return content
        }
        return ""
    }


}
