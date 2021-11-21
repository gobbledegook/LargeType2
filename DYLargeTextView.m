//
//  DYLargeTextView.m
//
//  Created 2009.09.02.
//  Copyright 2009-2016 Dominic Yu. All rights reserved.
//

#import "DYLargeTextView.h"

#define MIN_FONT_SIZE 48
#define MAX_FONT_SIZE 200

@interface DYLargeTextView () {
	NSString *displayString;
	CGFloat fontSize;
}
@end

@implementation DYLargeTextView

- (void)drawRect:(NSRect)dirtyRect {
	NSRect r = self.bounds;
	
	// draw the window background
    [[NSColor clearColor] set];
    NSRectFill(self.bounds);
	NSBezierPath* thePath = [NSBezierPath bezierPath];
	[thePath appendBezierPathWithRoundedRect:r xRadius:20 yRadius:20];
    [[[NSColor blackColor] colorWithAlphaComponent:0.65] set];
	[thePath fill];
	
	// make par style: centered
	NSMutableParagraphStyle *ps;
	ps = [[[NSMutableParagraphStyle alloc] init] autorelease];
	ps.alignment = NSTextAlignmentCenter;
	
	// shadowed text
	NSShadow *sh = [[[NSShadow alloc] init] autorelease];
	sh.shadowBlurRadius = 5;
	sh.shadowOffset = NSMakeSize(5, -5);
	
	// make attributes dict: bold system font, white on black
	NSDictionary *atts = @{NSFontAttributeName: [NSFont boldSystemFontOfSize:fontSize],
						  NSForegroundColorAttributeName: [NSColor whiteColor],
						  NSShadowAttributeName: sh,
						  NSParagraphStyleAttributeName: ps};
	
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
	NSUInteger maxLength = 1; // avoid divide-by-zero, just in case
	for (NSString *line in [s componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
		if (line.length > maxLength)
			maxLength = line.length;
	}
	NSRect visFrame = [NSScreen mainScreen].visibleFrame; // exclude the menubar, Dock, etc.
	CGFloat w = visFrame.size.width - 50;
	CGFloat h = visFrame.size.height;
	CGFloat size = w / maxLength;

	// calculate appropriate font size
	if (size > MAX_FONT_SIZE) {
		fontSize = MAX_FONT_SIZE;
	} else {
		if (size < MIN_FONT_SIZE) {
			size = MIN_FONT_SIZE;
		} else {
			size = floor(size);
		}
		NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
		atts[NSFontAttributeName] = [NSFont boldSystemFontOfSize:size];
		
		fontSize = size;
		CGFloat textWidth = [s sizeWithAttributes:atts].width;
		
		while (textWidth < w) {
			fontSize = size;
			atts[NSFontAttributeName] = [NSFont boldSystemFontOfSize:++size];
			textWidth = [s sizeWithAttributes:atts].width;
		}
		[atts release];
	}
	
	// figure out how big the actual text will be
	NSRect strRect = [s boundingRectWithSize:NSMakeSize(w, h)
									 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
								  attributes:@{NSFontAttributeName:[NSFont boldSystemFontOfSize:fontSize]}];
	NSSize windSize = strRect.size;

	// make sure there's some empty space around the window
	if (windSize.width >= w) windSize.width = w;
	if (windSize.height >= h) windSize.height = h - 50;
	// put some padding around the text, too
	windSize.width += 40;
	windSize.height += 40;
	
	// size our window as calculated
	NSWindow *myWindow = self.window;
	NSRect r = myWindow.frame;
	r.size = windSize;
	// and center it
	r.origin.x = visFrame.origin.x + (w+50-windSize.width)/2;
	r.origin.y = visFrame.origin.y + (demoMode ? 10 : (h-windSize.height)/2);
	[myWindow setFrame:NSIntegralRect(r) display:YES];
	[myWindow makeKeyAndOrderFront:nil];
}

@end
