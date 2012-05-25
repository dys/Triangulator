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

CGFloat DYSLineSegmentLength(CGPoint a, CGPoint b) {
	CGPoint translated = (CGPoint){
		b.x - a.x,
		b.y - a.y
	};
	return sqrt(pow(translated.x, 2) + pow(translated.y, 2));
}

CGPoint DYSTranslatePoint(CGPoint point, CGFloat x, CGFloat y) {
	return (CGPoint){
		point.x + x,
		point.y + y
	};
}

NSBezierPath *DYSMovePathToPoint(NSBezierPath *path, CGPoint destination) {
    NSAffineTransform *move_to_point = [NSAffineTransform transform];
    [move_to_point translateXBy:destination.x yBy:destination.y];
    return [move_to_point transformBezierPath:path];
}

NSBezierPath *DYSRotatePathByDegrees(NSBezierPath *path, CGFloat degrees) {
    NSAffineTransform *rotation = [NSAffineTransform transform];
	[rotation rotateByDegrees:degrees];
    return [rotation transformBezierPath:path];
}

static NSBezierPath *DYSDrawLeaf(CGFloat height) {
    // slice diamond leaf vertically giving a 30-90-60 ABC triangle (where b is height)
    // slice that horizontally and you get another 30-90-60 DEF triangle (where d lies on b)
    // the properties of these right-angle triangles are such that:
        // the length b will be 1/2 of length c,
        // the length d will be 1/2 of length b,
        // therefore d is 1/4 height and we can calculate f = d sin F / sin D
    CGFloat corner_offset_y = height / 4; // d
    CGFloat corner_offset_x = (corner_offset_y * sin(DYSRadians(60))) / sin(DYSRadians(30)); // f
    CGPoint zero = {0, 0}; 
    NSBezierPath *path = [NSBezierPath new];
    [path moveToPoint:zero];
	[path lineToPoint:DYSTranslatePoint(zero, corner_offset_x, corner_offset_y)]; // right vertex
	[path lineToPoint:DYSTranslatePoint(zero, 0, height)]; // top vertex
    [path lineToPoint:DYSTranslatePoint(zero, -corner_offset_x, corner_offset_y)]; // left vertex
	[path closePath];
    return path;
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
    [path appendBezierPath:DYSMovePathToPoint(DYSRotatePathByDegrees(DYSDrawLeaf(max), 0), topVertex)];
    [path appendBezierPath:DYSMovePathToPoint(DYSRotatePathByDegrees(DYSDrawLeaf(max), 240), leftVertex)];
    [path appendBezierPath:DYSMovePathToPoint(DYSRotatePathByDegrees(DYSDrawLeaf(max), 120), rightVertex)];
    
    [[NSColor blackColor] setFill];
    [path fill];
}

@end
