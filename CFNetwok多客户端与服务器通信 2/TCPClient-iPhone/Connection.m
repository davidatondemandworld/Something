//
//  Connection.h
//  TCPListner
//
//  Created by apple on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import "Connection.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <arpa/inet.h>


// Declare C callback functions
void readStreamEventHandler(CFReadStreamRef stream, CFStreamEventType eventType, void *info);
void writeStreamEventHandler(CFWriteStreamRef stream, CFStreamEventType eventType, void *info);


#pragma mark - Connection - Private properties and methods

@interface Connection ()

// Properties
@property(nonatomic, assign) CFSocketNativeHandle connectedSocketHandle;

// Initialize
- (void) clean;

// Further setup streams created by one of the 'init' methods
- (BOOL) setupSocketStreams;

// Stream event handlers
- (void) readStreamHandleEvent:(CFStreamEventType)event;
- (void) writeStreamHandleEvent:(CFStreamEventType)event;

// Read all available bytes from the read stream into buffer and try to extract packets
- (void) readFromStreamIntoIncomingBuffer;

// Write whatever data we have in the buffer, as much as stream can handle
- (void) writeOutgoingBufferToStream;

@end


@implementation Connection

@synthesize delegate;
@synthesize host, port, peerhost,peerport;
@synthesize connectedSocketHandle;

#pragma mark - Lifecycle

// Initialize, empty
- (void) clean
{  
    readStream = nil;
    readStreamOpen = NO;
    
    writeStream = nil;
    writeStreamOpen = NO;
    
    incomingDataBuffer = nil;
    outgoingDataBuffer = nil;
    
    self.host = nil;
    connectedSocketHandle = -1;
    packetBodySize = -1;
}

- (id)initWithHostAddress:(NSString *)thePeerHost andPort:(NSInteger)thePort{
    if ((self=[super init])) {
        [self clean];
        self.peerhost = thePeerHost;
        self.peerport = thePort;
        self.host = @"127.0.0.1";
        self.port = 1025;
    } 
    return self;
}

// Initialize using a native socket handle, assuming connection is open
- (id) initWithNativeSocketHandle:(CFSocketNativeHandle)nativeSocketHandle
{    
    if((self = [super init])){
        [self clean];
        
        self.connectedSocketHandle = nativeSocketHandle;
        
        struct sockaddr_in peeraddr;
        struct sockaddr_in addr;
        socklen_t addrLen = sizeof(peeraddr);    
        // get loacl address
        getsockname(nativeSocketHandle, (struct sockaddr *)&addr, &addrLen);
        self.host = [NSString stringWithCString:inet_ntoa(addr.sin_addr) encoding:NSUTF8StringEncoding];
        self.port = ntohs(addr.sin_port);    
        
        // get peer address
        getpeername(nativeSocketHandle, (struct sockaddr *)&peeraddr, &addrLen);
        self.peerhost = [NSString stringWithCString:inet_ntoa(peeraddr.sin_addr) encoding:NSUTF8StringEncoding];
        self.peerport = ntohs(peeraddr.sin_port);  
    }
    
    return self;
}

// cleanup
- (void) dealloc
{
    
    self.host = nil;
    self.delegate = nil;
    
    [super dealloc];
}

#pragma mark - Network

// Connect using whatever connection info that was passed during initialization
- (BOOL) connect
{        
    if ( self.connectedSocketHandle != -1 ) {
        // Bind read/write streams to a socket represented by a native socket handle
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, self.connectedSocketHandle,
                                     &readStream, &writeStream);
        
        // Do the rest
        return [self setupSocketStreams];
    }
    else if(self.peerhost != nil){
        BOOL        success;
        int         err;
        int         fd; 
        struct sockaddr_in addr;
        
        fd = socket(AF_INET, SOCK_STREAM, 0);
        success = (fd != -1);   
        
        if (success) {
            NSLog(@"socket success");
            //配置 socket 的绑定地址
            memset(&addr, 0, sizeof(addr));
            addr.sin_len    = sizeof(addr);
            addr.sin_family = AF_INET;
            addr.sin_port   = htons(self.port);
            addr.sin_addr.s_addr = INADDR_ANY;
            //addr.sin_addr.s_addr = inet_addr([self.host cStringUsingEncoding:NSUTF8StringEncoding]);
            //addr.sin_addr.s_addr = inet_addr("192.168.2.127");
            //绑定 Socket
            err = bind(fd, (const struct sockaddr *) &addr, sizeof(addr));
            success = (err == 0);
        }
        
        if(success){
            struct sockaddr_in peeraddr;
            memset(&peeraddr, 0, sizeof(peeraddr));
            peeraddr.sin_len    = sizeof(peeraddr);
            peeraddr.sin_family = AF_INET;
            peeraddr.sin_port   = htons(self.peerport);
            //peeraddr.sin_addr.s_addr = INADDR_ANY;
            peeraddr.sin_addr.s_addr = inet_addr([self.peerhost cStringUsingEncoding:NSUTF8StringEncoding]);
            
            socklen_t addrLen;
            addrLen = sizeof(peeraddr);
            NSLog(@"connecting");
            err = connect(fd, (struct sockaddr *)&peeraddr, addrLen);
            success=(err==0);
        }
            
        if(success){
            self.connectedSocketHandle = fd;
            // Bind read/write streams to a socket represented by a native socket handle
            CFStreamCreatePairWithSocket(kCFAllocatorDefault, self.connectedSocketHandle,
                                         &readStream, &writeStream);
            // Do the rest
            return [self setupSocketStreams];
        }
    
        
        
//        // Bind read/write streams to a new socket
//        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)self.peerhost,
//                                           (UInt32)self.peerport, &readStream, &writeStream);        
//        
//        // Do the rest
//        return [self setupSocketStreams];
    }
    
    // Nothing was passed, connection is not possible
    return NO;
}


// Further setup socket streams that were created by one of our 'init' methods
- (BOOL) setupSocketStreams
{
    // Make sure streams were created correctly
    if ( readStream == nil || writeStream == nil ) {
        [self close];
        return NO;
    }
    
    // Create buffers
    incomingDataBuffer = [[NSMutableData alloc] init];
    outgoingDataBuffer = [[NSMutableData alloc] init];
    
    // Indicate that we want socket to be closed whenever streams are closed
    CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    
    // We will be handling the following stream events
    CFOptionFlags registeredEvents = kCFStreamEventOpenCompleted | kCFStreamEventHasBytesAvailable
                                    | kCFStreamEventCanAcceptBytes | kCFStreamEventEndEncountered
                                    | kCFStreamEventErrorOccurred;
    
    // Setup stream context - reference to 'self' will be passed to stream event handling callbacks
    CFStreamClientContext ctx = {0, self, NULL, NULL, NULL};
    
    // Specify callbacks that will be handling stream events
    CFReadStreamSetClient(readStream, registeredEvents, readStreamEventHandler, &ctx);
    CFWriteStreamSetClient(writeStream, registeredEvents, writeStreamEventHandler, &ctx);
    
    // Schedule streams with current run loop
    CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    CFWriteStreamScheduleWithRunLoop(writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    
    // Open both streams
    if ( !CFReadStreamOpen(readStream) || !CFWriteStreamOpen(writeStream)) {
        [self close];
        return NO;
    }
    
    return YES;
}


// Close connection
- (void) close
{
    // Cleanup read stream
    if ( readStream != nil ) {
        CFReadStreamUnscheduleFromRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        CFReadStreamClose(readStream);
        CFRelease(readStream);
        readStream = NULL;
    }
    
    // Cleanup write stream
    if ( writeStream != nil ) {
        CFWriteStreamUnscheduleFromRunLoop(writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        CFWriteStreamClose(writeStream);
        CFRelease(writeStream);
        writeStream = NULL;
    }
    
    // Cleanup buffers
    [incomingDataBuffer release];
    incomingDataBuffer = NULL;
    
    [outgoingDataBuffer release];
    outgoingDataBuffer = NULL;
    
       // Reset all other variables
    [self clean];
}


#pragma mark - Send or Recv data 

// Send network message
- (void) sendNetworkPacket:(NSDictionary *)packet
{
    // Encode packet
    NSData * rawPacket = [NSKeyedArchiver archivedDataWithRootObject:packet];
    
    // Write header: lengh of raw packet
    NSInteger packetLength = [rawPacket length];
    [outgoingDataBuffer appendBytes:&packetLength length:sizeof(int)];
    
    // Write body: encoded NSDictionary
    [outgoingDataBuffer appendData:rawPacket];
    
    // Try to write to stream
    [self writeOutgoingBufferToStream];
}


#pragma mark Read stream methods

// Dispatch readStream events
void readStreamEventHandler(CFReadStreamRef stream, CFStreamEventType eventType, void *info)
{
    Connection* connection = (Connection*)info;
    [connection readStreamHandleEvent:eventType];
}


// Handle events from the read stream
- (void) readStreamHandleEvent:(CFStreamEventType)event
{
    // Stream successfully opened
    if ( event == kCFStreamEventOpenCompleted ) {
        readStreamOpen = YES;
    }

    // New data has arrived
    else if ( event == kCFStreamEventHasBytesAvailable ) {
        // Read as many bytes from the stream as possible and try to extract meaningful packets
        [self readFromStreamIntoIncomingBuffer];
    }

    // Connection has been terminated or error encountered (we treat them the same way)
    else if ( event == kCFStreamEventEndEncountered || event == kCFStreamEventErrorOccurred ) {
        // Clean everything up
        [self close];
        
        // If we haven't connected yet then our connection attempt has failed
        if ( !readStreamOpen || !writeStreamOpen ) {
            [delegate connectionAttemptFailed:self];
        }
        else {
            [delegate connectionTerminated:self];
        }
    }
}


// Read as many bytes from the stream as possible and try to extract meaningful packets
- (void) readFromStreamIntoIncomingBuffer
{
    // Temporary buffer to read data into
    UInt8 buf[1024];
    
    // Try reading while there is data
    while( CFReadStreamHasBytesAvailable(readStream) ) {  
        CFIndex len = CFReadStreamRead(readStream, buf, sizeof(buf));
        if ( len <= 0 ) {
            // Either stream was closed or error occurred. Close everything up and treat this as "connection terminated"
            [self close];
            [delegate connectionTerminated:self];
            return;
        }
        
        [incomingDataBuffer appendBytes:buf length:len];
    }
    
    // Try to extract packets from the buffer.
    //
    // Protocol: header + body
    //  header: an integer that indicates length of the body
    //  body: bytes that represent encoded NSDictionary
    
    // We might have more than one message in the buffer - that's why we'll be reading it inside the while loop
    while( YES ) {
        // Did we read the header yet?
        if ( packetBodySize == -1 ) {
            // Do we have enough bytes in the buffer to read the header?
            if ( [incomingDataBuffer length] >= sizeof(int) ) {
                // extract length
                memcpy(&packetBodySize, [incomingDataBuffer bytes], sizeof(int));
                
                // remove that chunk from buffer
                NSRange rangeToDelete = {0, sizeof(int)};
                [incomingDataBuffer replaceBytesInRange:rangeToDelete withBytes:NULL length:0];
            }
            else {
                // We don't have enough yet. Will wait for more data.
                break;
            }
        }
        
        // We should now have the header. Time to extract the body.
        if ( [incomingDataBuffer length] >= packetBodySize ) {
            // We now have enough data to extract a meaningful packet.
            NSData* raw = [NSData dataWithBytes:[incomingDataBuffer bytes] length:packetBodySize];
            NSDictionary* packet = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
            
            // Tell our delegate about it
            [delegate receivedNetworkPacket:packet viaConnection:self];
            
            // Remove that chunk from buffer
            NSRange rangeToDelete = {0, packetBodySize};
            [incomingDataBuffer replaceBytesInRange:rangeToDelete withBytes:NULL length:0];
            
            // We have processed the packet. Resetting the state.
            packetBodySize = -1;
        }
        else {
            // Not enough data yet. Will wait.
            break;
        }
    }
}


#pragma mark Write stream methods

// Dispatch writeStream event handling
void writeStreamEventHandler(CFWriteStreamRef stream, CFStreamEventType eventType, void *info)
{
    Connection* connection = (Connection*)info;
    [connection writeStreamHandleEvent:eventType];
}


// Handle events from the write stream
- (void) writeStreamHandleEvent:(CFStreamEventType)event
{
    // Stream successfully opened
    if ( event == kCFStreamEventOpenCompleted ) {
        writeStreamOpen = YES;
    }
    
    // Stream has space for more data to be written
    else if ( event == kCFStreamEventCanAcceptBytes ) {
        // Write whatever data we have, as much as stream can handle
        [self writeOutgoingBufferToStream];
    }

    // Connection has been terminated or error encountered (we treat them the same way)
    else if ( event == kCFStreamEventEndEncountered || event == kCFStreamEventErrorOccurred ) {
        // Clean everything up
        [self close];
        
        // If we haven't connected yet then our connection attempt has failed
        if ( !readStreamOpen || !writeStreamOpen ) {
            [delegate connectionAttemptFailed:self];
        }
        else {
            [delegate connectionTerminated:self];
        }
    }
}


// Write whatever data we have, as much of it as stream can handle
- (void) writeOutgoingBufferToStream
{
    // Is connection open?
    if ( !readStreamOpen || !writeStreamOpen ) {
        // No, wait until everything is operational before pushing data through
        return;
    }
    
    // Do we have anything to write?
    if ( [outgoingDataBuffer length] == 0 ) {
        return;
    }
    
    // Can stream take any data in?
    if ( !CFWriteStreamCanAcceptBytes(writeStream) ) { 
        return;
    }
    
    // Write as much as we can
    CFIndex writtenBytes = CFWriteStreamWrite(writeStream, [outgoingDataBuffer bytes], [outgoingDataBuffer length]);
    
    if ( writtenBytes == -1 ) {
        // Error occurred. Close everything up.
        [self close];
        [delegate connectionTerminated:self];

        return;
    }
    
    // Remove that chunk from buffer
    NSRange range = {0, writtenBytes};
    [outgoingDataBuffer replaceBytesInRange:range withBytes:NULL length:0];
}

@end
