//
//  ViewController.m
//  CoreGraphics
//
//  Created by wangyang on 2017/4/22.
//  Copyright © 2017年 com.wy. All rights reserved.
//

#import "ViewController.h"
#import "AxialShadingView.h"
#import "RadialShadingView.h"

@interface ViewController ()
{
    UIView *subview;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)axialShading:(id)sender {
    [self addView:[AxialShadingView class]];
}

- (IBAction)radialShading:(id)sender {
    [self addView:[RadialShadingView class]];
}


- (void)addView:(Class)cls {
    [subview removeFromSuperview];
    subview = [[cls alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:subview];
}

@end
