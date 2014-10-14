//
//  ViewController.swift
//  Wiboard
//
//  Created by Endika Gutiérrez Salas on 07/10/14.
//  Copyright (c) 2014 Endika Gutiérrez Salas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var testingInputView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        testingInputView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

