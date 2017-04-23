//
//  RadialShadingView.m
//  CoreGraphics
//
//  Created by wangyang on 2017/4/23.
//  Copyright © 2017年 com.wy. All rights reserved.
//

#import "RadialShadingView.h"

@implementation RadialShadingView

static void  myCalculateShadingValues (void *info,
                                       const CGFloat *in,
                                       CGFloat *out)
{
    size_t k, components;
    double frequency[4] = { 55, 220, 110, 0 };
    components = (size_t)info;
    for (k = 0; k < components - 1; k++)
        *out++ = (1 + sin(*in * frequency[k]))/2;
    *out++ = 1; // alpha
}

static CGFunctionRef myGetFunction (CGColorSpaceRef colorspace)// 1
{
    size_t numComponents;
    static const CGFloat input_value_range [2] = { 0, 1 };
    static const CGFloat output_value_ranges [8] = { 0, 1, 0, 1, 0, 1, 0, 1 };
    static const CGFunctionCallbacks callbacks = { 0,// 2
        &myCalculateShadingValues,
        NULL };
    
    numComponents = 1 + CGColorSpaceGetNumberOfComponents (colorspace);// 3
    return CGFunctionCreate ((void *) numComponents, // 4
                             1, // 5
                             input_value_range, // 6
                             numComponents, // 7
                             output_value_ranges, // 8
                             &callbacks);// 9
}

void myPaintRadialShading (CGContextRef myContext,// 1
                           CGRect bounds) {
    CGPoint startPoint,
    endPoint;
    CGFloat startRadius,
    endRadius;
    CGAffineTransform myTransform;
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    startPoint = CGPointMake(0.25,0.3); // 2
    startRadius = .1;  // 3
    endPoint = CGPointMake(.5,0.5); // 4
    endRadius = .25; // 5
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB(); // 6
    CGFunctionRef myShadingFunction = myGetFunction (colorspace); // 7
    
    CGShadingRef shading = CGShadingCreateRadial (colorspace, // 8
                                     startPoint, startRadius,
                                     endPoint, endRadius,
                                     myShadingFunction,
                                     false, false);
    
    myTransform = CGAffineTransformMakeScale (width, height); // 9
    CGContextConcatCTM (myContext, myTransform); // 10
    CGContextSaveGState (myContext); // 11
    
    CGContextClipToRect (myContext, CGRectMake(0, 0, 1, 1)); // 12
    CGContextSetRGBFillColor (myContext, 1, 1, 1, 1);
    CGContextFillRect (myContext, CGRectMake(0, 0, 1, 1));
    
    CGContextDrawShading (myContext, shading); // 13
    CGColorSpaceRelease (colorspace); // 14
    CGShadingRelease (shading);
    CGFunctionRelease (myShadingFunction);
    
    CGContextRestoreGState (myContext); // 15
}


- (void)drawRect:(CGRect)rect {
    myPaintRadialShading(UIGraphicsGetCurrentContext(), rect);
}

void MyDrawTransparencyLayer (CGContextRef myContext, float wd,float ht)
{
    CGSize myShadowOffset = CGSizeMake (10, -20);
    CGContextSetShadow (myContext, myShadowOffset, 10);
    CGContextBeginTransparencyLayer (myContext, NULL);
    
    // Your drawing code here
    CGContextSetRGBFillColor (myContext, 0, 1, 0, 1);
    CGContextFillRect (myContext, CGRectMake (wd/3+ 50,ht/2 ,wd/4,ht/4));
    CGContextSetRGBFillColor (myContext, 0, 0, 1, 1);
    CGContextFillRect (myContext, CGRectMake (wd/3-50,ht/2-100,wd/4,ht/4));
    CGContextSetRGBFillColor (myContext, 1, 0, 0, 1);
    CGContextFillRect (myContext, CGRectMake (wd/3,ht/2-50,wd/4,ht/4));
    CGContextEndTransparencyLayer (myContext);
}

@end
