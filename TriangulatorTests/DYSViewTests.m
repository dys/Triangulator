//  DYSViewTests.m
//  Created by Rob Rix on 12-05-23.
//  Copyright (c) 2012 Black Pixel. All rights reserved.

#import "RXAssertions.h"
#import "DYSView.h"

@interface DYSViewTests : SenTestCase
@end

@implementation DYSViewTests

-(void)testMaps0DegreesOnto0Radians {
	RXAssertEquals(DYSRadians(0), 0.0);
}

-(void)testMaps180DegreesOntoPiRadians {
	RXAssertEquals(DYSRadians(180), M_PI);
}

-(void)testMaps360DegreesOnto2PiRadians {
	RXAssertEquals(DYSRadians(360), M_PI * 2);
}


-(void)testCalculatesPointsAtLinearIntervals {
	CGPoint a = (CGPoint){ -8, -8 };
	CGPoint b = (CGPoint){ 8, 8 };
	CGPoint c = (CGPoint){-4, -4};
	CGPoint d = (CGPoint){4, 4};
	
	RXAssertEquals(DYSPointAtInterval(a, b, 0), a);
	RXAssertEquals(DYSPointAtInterval(a, b, 0.25), c);
	RXAssertEquals(DYSPointAtInterval(a, b, 0.5), CGPointZero);
	RXAssertEquals(DYSPointAtInterval(a, b, 0.75), d);
	RXAssertEquals(DYSPointAtInterval(a, b, 1), b);
}


-(void)testTranslatesPoints {
	RXAssertEquals(DYSTranslatePoint((CGPoint){ -10, -10 }, 10, 10), CGPointZero);
	RXAssertEquals(DYSTranslatePoint((CGPoint){ 10, 10 }, -10, -10), CGPointZero);
}


-(void)testCalculatesTheLengthOfLineSegments {
	RXAssertEquals(DYSLineSegmentLength((CGPoint){ 1, 0 }, CGPointZero), 1.);
	RXAssertEquals(DYSLineSegmentLength(CGPointZero, (CGPoint){ 0, 1 }), 1.);
	RXAssertEquals(DYSLineSegmentLength(CGPointZero, (CGPoint){ 1, 1 }), M_SQRT2);
}

@end
