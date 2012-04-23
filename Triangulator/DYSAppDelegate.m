//
//  DYSAppDelegate.m
//  Triangulator
//
//  Created by Rob Rix on 12-04-21.
//  Copyright (c) 2012 Black Pixel. All rights reserved.
//

#import "DYSAppDelegate.h"

@interface DYSAppDelegate ()
@property (strong) NSWindow *window;
@end

@implementation DYSAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSError *error = nil;
	if(![[self.window.contentView dataWithPDFInsideRect:[self.window.contentView frame]] writeToFile:@"/Users/rob/Desktop/dys4ik.pdf" options:NSDataWritingAtomic error:&error]) {
		NSLog(@"couldn’t write: %@", error);
	}
}

@end
