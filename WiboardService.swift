//
//  WiboardService.swift
//  Wiboard
//
//  Created by Endika Gutiérrez Salas on 09/10/14.
//  Copyright (c) 2014 Endika Gutiérrez Salas. All rights reserved.
//

import Foundation

protocol WiboardServiceDelegate {


    // Input events
    func serviceTextHasInserted(service: WiboardService, text: String)
    func serviceDeleteBackwardHasInserted(service: WiboardService)

    // Conections
    func serviceDidOpenConnection(service: WiboardService)
    func serviceDidCloseConnection(service: WiboardService)

}

class WiboardService: WebSocketDelegate {

    class var sharedService : WiboardService {
        struct Static {
            static let instance = WiboardService()
        }
        return Static.instance
    }

    var delegate: WiboardServiceDelegate?

    private var httpServer: HTTPServer?
    private var websockets: [WebSocket] = []

    var port :UInt16 {
        get { return httpServer!.listeningPort() }
    }

    func start() -> NSError? {
        let server = HTTPServer()
        server.setType("_http._tcp.")
        server.setConnectionClass(HTTPWiboardConnection)
        //server.setPort(12345)

        let path = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("web.bundle")
        server.setDocumentRoot(path)

        var error: NSError?

        if server.start(&error) {
            NSLog("Listening \( server.listeningPort() )")
            httpServer = server

        } else {
            NSLog("Error \( error )")
        }

        return error
    }

    func handleSocket(socket: WebSocket) {
        websockets.append(socket)
    }


    func webSocketDidOpen(ws: WebSocket!) {
        NSLog("webSocketDidOpen")
    }

    func webSocketDidClose(ws: WebSocket!) {
        NSLog("webSocketDidClose")
        // Remove closed ws
        websockets = websockets.filter { $0 != ws }
    }

    func webSocket(ws: WebSocket!, didReceiveMessage msg: String!) {
        NSLog("webSocketDidReceiveMessage \( msg )")

        var error: NSError?
        let jsonData = msg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) as NSData!
        let json = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.allZeros, error: &error) as NSDictionary

        switch json["type"] as String {
        case "text":
            delegate?.serviceTextHasInserted(self, text: json["content"] as String)

        default:
            break
        }

    }

}
