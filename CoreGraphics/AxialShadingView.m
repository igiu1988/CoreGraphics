//
//  AxialShadingView.m
//  CoreGraphics
//
//  Created by wangyang on 2017/4/23.
//  Copyright © 2017年 com.wy. All rights reserved.
//

#import "AxialShadingView.h"

@implementation AxialShadingView


static void myCalculateShadingValues (void *info,
                                      const CGFloat *in,
                                      CGFloat *out)
{
    CGFloat v;
    size_t k, components;
    static const CGFloat colorComponents[] = {1, 0, .5, 0 };
    
    components = (size_t)info;
    
    v = *in;
    for (k = 0; k < components -1; k++)
        *out++ = colorComponents[k] * v;
    *out++ = 1;
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

void myPaintAxialShading (CGContextRef myContext,// 1
                          CGRect bounds)
{
    CGPoint     startPoint,
    endPoint;
    CGAffineTransform myTransform;
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    
    startPoint = CGPointMake(0,0.5); // 2
    endPoint = CGPointMake(1,0.5);// 3
    
    CGFunctionRef myShadingFunction;
    CGShadingRef shading;
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();// 4
    myShadingFunction = myGetFunction(colorspace);// 5
    
    shading = CGShadingCreateAxial (colorspace, // 6
                                    startPoint, endPoint,
                                    myShadingFunction,
                                    false, false);
    
    myTransform = CGAffineTransformMakeScale (width, height);// 7
    CGContextConcatCTM (myContext, myTransform);// 8
    CGContextSaveGState (myContext);// 9
    
    CGContextClipToRect (myContext, CGRectMake(0, 0, 1, 1));// 10
    CGContextSetRGBFillColor (myContext, 1, 1, 1, 1);
    CGContextFillRect (myContext, CGRectMake(0, 0, 1, 1));
    
    CGContextBeginPath (myContext);// 11
    CGContextAddArc (myContext, .5, .5, .3, 0,
                     M_PI, 0);
    CGContextClosePath (myContext);
    CGContextClip (myContext);
    
    CGContextDrawShading (myContext, shading);// 12
    CGColorSpaceRelease (colorspace);// 13
    CGShadingRelease (shading);
    CGFunctionRelease (myShadingFunction);
    
    CGContextRestoreGState (myContext); // 14
}

- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    myPaintAxialShading(myContext, rect);
}

@end
