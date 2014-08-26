//
//  DYLargeTextWindow.h
//
//  Created 2009.09.03.
//  Copyright 2009 Dominic Yu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DYLargeTextWindow : NSWindow {
    // This point is used in dragging to mark the initial click location
    NSPoint initialLocation;
}

@property (assign) NSPoint initialLocation;

@end
