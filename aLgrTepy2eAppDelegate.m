//
//  aLgrTepy2eAppDelegate.m
//
//  Created 2009.09.01.
//  Copyright 2009 Dominic Yu. All rights reserved.
//

#import "aLgrTepy2eAppDelegate.h"
#import "DYLargeTextView.h"

@implementation aLgrTepy2eAppDelegate

@synthesize window;
@synthesize prefsWindow;

- (void)largeType:(NSPasteboard *)pboard
			 userData:(NSString *)userData error:(NSString **)error {
	launchedAsService = YES;
	
	if (floor(NSAppKitVersionNumber) > 949) { // 10.6 only
		// Test for strings on the pasteboard.
		if (![pboard canReadObjectForClasses:[NSArray arrayWithObject:
											  [NSString class]]
									 options:[NSDictionary dictionary]]) {
			*error = NSLocalizedString(@"Error: couldn't encrypt text.",
									   @"pboard couldn't give string.");
			return;
		}
	}
	
	// Get the string.
	NSString *s = [pboard stringForType:NSStringPboardType]; // 10.6: NSPasteboardTypeString];
	[[window contentView] setDisplayString:s demo:NO];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(largeTextDone:)
												 name:NSWindowDidResignKeyNotification
											   object:window];
	[NSApp setServicesProvider:self];
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self
								   selector:@selector(showPrefsWindow:)
								   userInfo:nil repeats:NO];
}

- (void)showPrefsWindow:(NSTimer *)t {
	if (launchedAsService)
		return;

	[[window contentView] setDisplayString:@"A noble spirit\nembiggens the smallest man."
									  demo:YES];
	[prefsWindow center];
	[prefsWindow makeKeyAndOrderFront:nil];
}

- (void)largeTextDone:(NSNotification *)n {
	if (launchedAsService)
		[NSApp terminate:nil];
}


@end
