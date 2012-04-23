//
//  DYSView.m
//  Triangulator
//
//  Created by Rob Rix on 12-04-21.
//  Copyright (c) 2012 Black Pixel. All rights reserved.
//

#import "DYSView.h"

@implementation DYSView

-(BOOL)isOpaque {
	return NO;
}


static CGPoint DYSPointAtInterval(CGPoint a, CGPoint b, CGFloat interval) {
	return (CGPoint){
		(b.x - a.x) * interval + a.x,
		(b.y - a.y) * interval + a.y
	};
}

static CGFloat DYSLineSegmentLength(CGPoint a, CGPoint b) {
	CGPoint translated = (CGPoint){
		b.x - a.x,
		b.y - a.y
	};
	return sqrt(pow(translated.x, 2) + pow(translated.y, 2));
}

static const CGFloat kDYSRadius = 450.;

-(void)drawRect:(NSRect)dirtyRect {
	[[NSColor clearColor] setFill];
	CGRect frame = self.frame;
	[[NSBezierPath bezierPathWithRect:frame] fill];
	
	NSAffineTransform *rotation = [NSAffineTransform transform];
	[rotation rotateByDegrees:120];
	NSAffineTransform *translate = [NSAffineTransform transform];
	[translate translateXBy:CGRectGetMidX(frame) yBy:350];
	
	NSBezierPath *path = [NSBezierPath new];
	CGPoint topVertex = {0, kDYSRadius};
	CGPoint lowerRightVertex = [rotation transformPoint:topVertex];
	CGPoint lowerRightKiteVertex = DYSPointAtInterval(topVertex, lowerRightVertex, 0.5 - 30. / DYSLineSegmentLength(topVertex, lowerRightVertex));
	CGPoint lowerLeftKiteVertex = {-lowerRightKiteVertex.x, lowerRightKiteVertex.y};
	CGPoint lowerKiteVertex = {0, 34};
	
	[path moveToPoint:topVertex];
	[path lineToPoint:lowerRightKiteVertex];
	[path lineToPoint:lowerKiteVertex];
	[path lineToPoint:lowerLeftKiteVertex];
	[path closePath];
	
	NSBezierPath *a = [translate transformBezierPath:path];
	NSBezierPath *b = [translate transformBezierPath:[rotation transformBezierPath:path]];
	NSBezierPath *c = [translate transformBezierPath:[rotation transformBezierPath:[rotation transformBezierPath:path]]];
	
	[[NSColor blackColor] setFill];
	[a fill];
	[b fill];
	[c fill];
}

@end
