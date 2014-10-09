//
//  HTTPWiboardConnection.swift
//  Wiboard
//
//  Created by Endika Gutiérrez Salas on 07/10/14.
//  Copyright (c) 2014 Endika Gutiérrez Salas. All rights reserved.
//

import Foundation

class HTTPWiboardConnection: HTTPConnection, WebSocketDelegate {

    var webSocket: WebSocket?
    
    override func httpResponseForMethod(method: String!, URI path: String!) -> NSObject! {
        NSLog("[\( method )] \( path )")

        switch (method, path) {
        case ("GET", "/app.js"):
            let host = self.request.headerField("Host")
            let proto = self.isSecureServer() ? "wss" : "ws"
            let wsURL = "\( proto )://\( host )/service"

            let response = HTTPDynamicFileResponse(filePath: self.filePathForURI(path),
                forConnection: self,
                separator: "%%",
                replacementDictionary: ["WEBSOCKET_URL": wsURL])

            return response

        default:
            return super.httpResponseForMethod(method, URI: path)
        }
    }

    override func webSocketForURI(path: String!) -> WebSocket! {
        NSLog("[WebSocket] \( path )")

        let socket = WebSocket(request: self.request, socket: self.asyncSocket)
        socket.delegate = WiboardService.sharedService
        webSocket = socket
        return socket
    }

}
