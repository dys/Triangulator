//
//  DYSView.h
//  Triangulator
//
//  Created by Rob Rix on 12-04-21.
//  Copyright (c) 2012 Black Pixel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern CGFloat DYSRadians(CGFloat degrees);
extern CGPoint DYSPointAtInterval(CGPoint a, CGPoint b, CGFloat interval);
extern CGPoint DYSTranslatePoint(CGPoint point, CGFloat x, CGFloat y);
extern CGFloat DYSLineSegmentLength(CGPoint a, CGPoint b);
extern NSBezierPath *DYSRotatePathByDegrees(NSBezierPath *path, CGFloat degrees);

@interface DYSView : NSView

@end
