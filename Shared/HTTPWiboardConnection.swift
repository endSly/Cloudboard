//
//  HTTPWiboardConnection.swift
//  Wiboard
//
//  Created by Endika Gutiérrez Salas on 07/10/14.
//  Copyright (c) 2014 Endika Gutiérrez Salas. All rights reserved.
//

import Foundation

class HTTPWiboardConnection: HTTPConnection {

    override func supportsMethod(method: String!, atPath path: String!) -> Bool {
        NSLog("[\(method)] \(path)")
        return true
    }
}
