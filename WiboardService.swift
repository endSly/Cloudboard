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

    // Data source
    func serviceContentAfterInput(service: WiboardService) -> String
    func serviceContentBeforeInput(service: WiboardService) -> String

    func service(service: WiboardService, didAdjustTextPositionByOffset offset: Int)

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
        server.setPort(12345)

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
        sendContentAroundText(ws)

        delegate?.serviceDidOpenConnection(self)
    }

    func webSocketDidClose(ws: WebSocket!) {
        // Remove closed ws
        websockets = websockets.filter { $0 != ws }

        delegate?.serviceDidCloseConnection(self)
    }

    func webSocket(ws: WebSocket!, didReceiveMessage msg: String!) {
        //NSLog("webSocketDidReceiveMessage \( msg )\n")

        var error: NSError?
        let jsonData = msg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) as NSData!
        let json = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.allZeros, error: &error) as NSDictionary

        switch json["type"] as String {
        case "text":
            delegate?.serviceTextHasInserted(self, text: json["content"] as String)
        case "movement":
            delegate?.service(self, didAdjustTextPositionByOffset: json["offset"] as Int)
        case "backward":
            delegate?.serviceDeleteBackwardHasInserted(self)
        default:
            break
        }

        sendContentAroundText(ws)
    }

    private func sendMessage(ws:WebSocket, message: AnyObject) {
        var error: NSError?
        let data = NSJSONSerialization.dataWithJSONObject(message, options: NSJSONWritingOptions.allZeros, error: &error)

        let json = NSString(data: data!, encoding: NSUTF8StringEncoding)
        ws.sendMessage(json)

    }

    private func sendContentAroundText(ws: WebSocket) {
        let contentBefore = delegate!.serviceContentBeforeInput(self)
        let contentAfter = delegate!.serviceContentAfterInput(self)

        let message = [
            "type": "content-around",
            "before": contentBefore,
            "after": contentAfter
        ]

        sendMessage(ws, message: message as [String: String])
    }
}
