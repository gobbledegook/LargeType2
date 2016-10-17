//
//  aLgrTepy2eAppDelegate.m
//
//  Created 2009.09.01.
//  Copyright 2009-2016 Dominic Yu. All rights reserved.
//

#import "aLgrTepy2eAppDelegate.h"
#import "DYLargeTextView.h"

@interface aLgrTepy2eAppDelegate () {
	BOOL launchedAsService;
}
@end

@implementation aLgrTepy2eAppDelegate

- (void)largeType:(NSPasteboard *)pboard
			 userData:(NSString *)userData error:(NSString **)error {
	launchedAsService = YES;
	
	// Test for strings on the pasteboard.
	if (![pboard canReadObjectForClasses:@[[NSString class]]
								 options:@{}]) {
		*error = NSLocalizedString(@"Error: couldn't encrypt text.",
								   @"pboard couldn't give string.");
		return;
	}
	
	// Get the string.
	NSString *s = [pboard stringForType:NSPasteboardTypeString];
	[_window.contentView setDisplayString:s demo:NO];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(largeTextDone:)
												 name:NSWindowDidResignKeyNotification
											   object:_window];
	NSApp.servicesProvider = self;
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self
								   selector:@selector(showPrefsWindow:)
								   userInfo:nil repeats:NO];
}

- (void)showPrefsWindow:(NSTimer *)t {
	if (launchedAsService)
		return;

	[_window.contentView setDisplayString:@"A noble spirit\nembiggens the smallest man."
									  demo:YES];
	[_prefsWindow center];
	[_prefsWindow makeKeyAndOrderFront:nil];
	[NSApp activateIgnoringOtherApps:YES];
}

- (void)largeTextDone:(NSNotification *)n {
	if (launchedAsService)
		[NSApp terminate:nil];
}


@end
