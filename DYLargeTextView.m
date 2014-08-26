//
//  DYLargeTextView.m
//
//  Created 2009.09.02.
//  Copyright 2009 Dominic Yu. All rights reserved.
//

#import "DYLargeTextView.h"

#define MIN_FONT_SIZE 48
#define MAX_FONT_SIZE 200

@implementation DYLargeTextView

- (void)drawRect:(NSRect)dirtyRect {
	NSRect r = [self bounds];
	
	// draw the window background
    [[NSColor clearColor] set];
    NSRectFill([self bounds]);
	NSBezierPath* thePath = [NSBezierPath bezierPath];
	[thePath appendBezierPathWithRoundedRect:r xRadius:20 yRadius:20];
    [[[NSColor blackColor] colorWithAlphaComponent:0.65] set];
	[thePath fill];
	
	// make par style: centered
	NSMutableParagraphStyle *ps;
	ps = [[[NSMutableParagraphStyle alloc] init] autorelease];
	[ps setAlignment:NSCenterTextAlignment];
	
	// shadowed text
	NSShadow *sh = [[[NSShadow alloc] init] autorelease];
	[sh setShadowBlurRadius:5];
	[sh setShadowOffset:NSMakeSize(5, -5)];
	
	// make attributes dict: bold system font, white on black
	NSDictionary *atts = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSFont boldSystemFontOfSize:fontSize], NSFontAttributeName,
						  [NSColor whiteColor], NSForegroundColorAttributeName,
						  sh, NSShadowAttributeName,
						  ps, NSParagraphStyleAttributeName,
						  nil];
	
	// adjust for the padding
	r.size.height -= 15;
	
	[displayString drawWithRect:r
						options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics
					 attributes:atts];
}

- (void)setDisplayString:(NSString *)s demo:(BOOL)demoMode {
	[displayString release];
	// trim newlines, etc. from the string
	s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	displayString = [s retain];
	
	// approximate font size
	// find longest line and start from there
	NSUInteger n = 1; // avoid divide-by-zero, just in case
	NSArray *a = [s componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSUInteger i;
	NSUInteger numStrings = [a count];
	for (i = 0; i < numStrings; ++i) {
		if ([[a objectAtIndex:i] length] > n) n = [[a objectAtIndex:i] length];
	}
	NSRect visFrame = [[NSScreen mainScreen] visibleFrame]; // exclude the menubar, Dock, etc.
	CGFloat w = visFrame.size.width - 50;
	CGFloat h = visFrame.size.height;
	CGFloat size = w / n;

	// calculate appropriate font size
	if (size > MAX_FONT_SIZE) {
		fontSize = MAX_FONT_SIZE;
	} else {
		if (size < MIN_FONT_SIZE) {
			size = MIN_FONT_SIZE;
		}
		NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
		[atts setObject:[NSFont boldSystemFontOfSize:size] forKey:NSFontAttributeName];
		
		fontSize = size;
		CGFloat textWidth = [s sizeWithAttributes:atts].width;
		
		while (textWidth < w) {
			fontSize = size;
			[atts setObject:[NSFont boldSystemFontOfSize:++size]
					 forKey:NSFontAttributeName];
			textWidth = [s sizeWithAttributes:atts].width;
		}
	}
	
	// figure out how big the actual text will be
	NSRect strRect = [s boundingRectWithSize:NSMakeSize(w, h)
									 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics
								  attributes:[NSDictionary dictionaryWithObject:[NSFont boldSystemFontOfSize:fontSize]
																		 forKey:NSFontAttributeName]];
	NSSize windSize = strRect.size;

	// make sure there's some empty space around the window
	if (windSize.width >= w) windSize.width = w;
	if (windSize.height >= h) windSize.height = h - 50;
	// put some padding around the text, too
	windSize.width += 40;
	windSize.height += 40;
	
	// size our window as calculated
	NSWindow *myWindow = [self window];
	NSRect r = [myWindow frame];
	r.size = windSize;
	// and center it
	r.origin.x = visFrame.origin.x + (w+50-windSize.width)/2;
	r.origin.y = visFrame.origin.y + (demoMode ? 10 : (h-windSize.height)/2);
	[myWindow setFrame:r display:YES];
	[myWindow makeKeyAndOrderFront:nil];
	//[self setNeedsDisplay:YES];
}

@end
