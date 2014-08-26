//
//  DYLargeTextView.h
//
//  Created 2009.09.02.
//  Copyright 2009 Dominic Yu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DYLargeTextView : NSView {
	NSString *displayString;
	CGFloat fontSize;
}

- (void)setDisplayString:(NSString *)s demo:(BOOL)demoMode;

@end
