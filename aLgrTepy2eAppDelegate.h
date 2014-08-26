//
//  aLgrTepy2eAppDelegate.h
//
//  Created 2009.09.01.
//  Copyright 2009 Dominic Yu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface aLgrTepy2eAppDelegate : NSObject {
	NSWindow *window, *prefsWindow;
	BOOL launchedAsService;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSWindow *prefsWindow;

@end
