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

    var openedConnections = 0

    override func updateViewConstraints() {
        super.updateViewConstraints()

        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiateWithOwner(self, options: nil)
        keyboardView = objects[0] as! KeyboardView
        keyboardView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth];
        keyboardView.frame = self.view.frame
        self.view.addSubview(keyboardView)

        keyboardView.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)

        dispatch_async(dispatch_get_main_queue()) {
            let service = WiboardService.sharedService
            service.delegate = self


            if let error = service.start() {
                let errorMsg = NSLocalizedString("Cloudboard service unable to start. " +
                    "You should allow full access to keyboard in " +
                    "Setting > General > Keyboard > Keyboards > Remote Keyboard.", comment: "Error Message")

                self.keyboardView.statusLabel.text = NSLocalizedString("Error", comment: "Error status")

                self.keyboardView.errorLabel.text = errorMsg
                self.keyboardView.titleLabel.text = ""
                self.keyboardView.hostAddrLabel.text = ""
                return

            } else if let ipAddress = localIPAddress() {
                self.keyboardView.hostAddrLabel.text = "http://\( ipAddress ):\( service.port )/"

            } else {
                self.keyboardView.hostAddrLabel.text = NSLocalizedString("Connect to Wi-Fi", comment: "Connect to Wi-Fi")
            }

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
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
        openedConnections++
        let text = NSMutableAttributedString()
        text.appendAttributedString(NSAttributedString(string: "\u{f25c} ",
            attributes: [NSFontAttributeName: UIFont(name: "ionicons", size: 16)!]))
        text.appendAttributedString(NSAttributedString(string: NSLocalizedString("Connected", comment: "Connected")))

        dispatch_async(dispatch_get_main_queue()) {
            self.keyboardView.statusLabel.attributedText = text
        }
    }

    func serviceDidCloseConnection(service: WiboardService) {
        if --openedConnections == 0 {
            dispatch_async(dispatch_get_main_queue()) {
                self.keyboardView.statusLabel.text = NSLocalizedString("Disconnected", comment: "Disconnected")
            }
        }

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
