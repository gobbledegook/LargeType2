//
//  DYLargeTextWindow.m
//
//  Created 2009.09.03.
//  Copyright 2009-2016 Dominic Yu. All rights reserved.
//

#import "DYLargeTextWindow.h"

@interface DYLargeTextWindow () {
	NSPoint initialLocation; // save initial click location when dragging
}
@end

@implementation DYLargeTextWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    // NSBorderlessWindowMask: no title bar.
	self = [super initWithContentRect:contentRect styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
    if (self != nil) {
        self.alphaValue = 1.0; // no transparency here, only the black background in the View
        [self setOpaque:NO];
    }
    return self;
}

/*
 Custom windows that use the NSBorderlessWindowMask can't become key by default. Override this method so that controls in this window will be enabled.
 */
- (BOOL)canBecomeKeyWindow {
    return YES;
}

/*
 Start tracking a potential drag operation here when the user first clicks the mouse, to establish the initial location.
 */
- (void)mouseDown:(NSEvent *)theEvent {
    // Get the mouse location in window coordinates.
    initialLocation = theEvent.locationInWindow;
}

/*
 Once the user starts dragging the mouse, move the window with it.
 */
- (void)mouseDragged:(NSEvent *)theEvent {
    NSRect windowFrame = self.frame;
    NSPoint newOrigin = windowFrame.origin;
	
    // Get the mouse location in window coordinates.
    NSPoint currentLocation = theEvent.locationInWindow;
    // Update the origin with the difference between the new mouse location and the old mouse location.
    newOrigin.x += (currentLocation.x - initialLocation.x);
    newOrigin.y += (currentLocation.y - initialLocation.y);
	
    // Move the window to the new location
    [self setFrameOrigin:newOrigin];
}

// hide self on any key press
- (void)keyDown:(NSEvent *)e {
	[self orderOut:nil];
}

@end
