//
//  HTTPConnection+SwiftExtensions.h
//  Wiboard
//
//  Created by Endika Gutiérrez Salas on 08/10/14.
//  Copyright (c) 2014 Endika Gutiérrez Salas. All rights reserved.
//

#import <CocoaHTTPServer/HTTPConnection.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@interface HTTPConnection (SwiftExtensions)

@property (nonatomic, readonly) HTTPMessage * request;
@property (nonatomic, readonly) GCDAsyncSocket * asyncSocket;
@property (nonatomic, readonly) UInt16 localPort;

@end
