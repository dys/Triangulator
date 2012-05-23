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

CGFloat DYSRadians(CGFloat degrees)
{ 
    return degrees * M_PI / 180.0; 
}

CGPoint DYSPointAtInterval(CGPoint a, CGPoint b, CGFloat interval) {
	return (CGPoint){
		(b.x - a.x) * interval + a.x,
		(b.y - a.y) * interval + a.y
	};
}

CGPoint DYSTranslatePoint(CGPoint point, CGFloat x, CGFloat y) {
    NSAffineTransform *translate = [NSAffineTransform transform];
    [translate translateXBy:x yBy:y];
    return [translate transformPoint:point];
}

CGFloat DYSLineSegmentLength(CGPoint a, CGPoint b) {
	CGPoint translated = (CGPoint){
		b.x - a.x,
		b.y - a.y
	};
	return sqrt(pow(translated.x, 2) + pow(translated.y, 2));
}

static NSBezierPath *DYSDrawLeaf(CGPoint origin, CGFloat offset_from_90, CGFloat height) {
    // slice diamond leaf vertically giving a 30-90-60 triangle, slice that horizontally and you get another 30-90-60 triangle.
    CGFloat corner_offset_y = height / 4;
    CGFloat corner_offset_x = (corner_offset_y * sin(DYSRadians(60))) / sin(DYSRadians(30));
    CGPoint zero = {0, 0}; 

    NSBezierPath *path = [NSBezierPath new];
    [path moveToPoint:zero];
	[path lineToPoint:DYSTranslatePoint(zero, corner_offset_x, corner_offset_y)]; // right vertex
	[path lineToPoint:DYSTranslatePoint(zero, 0, height)]; // top vertex
    [path lineToPoint:DYSTranslatePoint(zero, -corner_offset_x, corner_offset_y)]; // left vertex
	[path closePath];
    
    NSAffineTransform *rotation_from_90 = [NSAffineTransform transform];
	[rotation_from_90 rotateByDegrees:offset_from_90];
    
    NSAffineTransform *move_to_origin = [NSAffineTransform transform];
    [move_to_origin translateXBy:origin.x yBy:origin.y];
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform appendTransform:rotation_from_90];
    [transform appendTransform:move_to_origin];
    
    return [transform transformBezierPath:path];
}

-(void)drawRect:(NSRect)dirtyRect {
	CGRect frame = self.frame;
    CGFloat max = frame.size.width < frame.size.height ? frame.size.width : frame.size.height;
    max = max / 3;
    CGFloat gap_width = (max / 2) * .4;
    CGFloat inner_radius = sqrt(pow(gap_width, 2) - pow(gap_width / 2, 2)) / 2;
    CGFloat center_x = frame.size.width / 2;
    CGFloat center_y = frame.size.height / 2;
    
    [[NSColor clearColor] setFill];
    [[NSBezierPath bezierPathWithRect:frame] fill];
    
    // the three points of the invisible inner triangle
    NSAffineTransform *rotate = [NSAffineTransform transform];
	[rotate rotateByDegrees:120];
    CGPoint topVertex = {0, inner_radius};
    CGPoint rightVertex = [rotate transformPoint:topVertex];    
    CGPoint leftVertex = [rotate transformPoint:rightVertex];
    topVertex = DYSTranslatePoint(topVertex, center_x, center_y);
    rightVertex = DYSTranslatePoint(rightVertex, center_x, center_y);
    leftVertex = DYSTranslatePoint(leftVertex, center_x, center_y);
    
    NSBezierPath *path = [NSBezierPath new];
    [path appendBezierPath:DYSDrawLeaf(topVertex, 0, max)];
    [path appendBezierPath:DYSDrawLeaf(leftVertex, 240, max)];
    [path appendBezierPath:DYSDrawLeaf(rightVertex, 120, max)];
    
    [[NSColor blackColor] setFill];
    [path fill];
}

@end
