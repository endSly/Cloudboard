//
//  HTTPConnection+SwiftExtensions.m
//  Wiboard
//
//  Created by Endika Gutiérrez Salas on 08/10/14.
//  Copyright (c) 2014 Endika Gutiérrez Salas. All rights reserved.
//

#import "HTTPConnection+SwiftExtensions.h"

#import <GCDAsyncSocket.h>

@implementation HTTPConnection (SwiftExtensions)

- (HTTPMessage *)request
{
    return request;
}

- (GCDAsyncSocket *)asyncSocket
{
    return asyncSocket;
}

- (UInt16)localPort
{
    return asyncSocket.localPort;
}

@end
