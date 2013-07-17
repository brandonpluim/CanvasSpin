//
//  ViewController.m
//  CanvasSpin
//
//  Created by derrick on 1/29/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 1.2f

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *spinnerContainer;
@property (strong, nonatomic) CAReplicatorLayer *spinnerLayer;
@property (strong, nonatomic) CAShapeLayer *peepLayer;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *highlightColor;

@end

@implementation ViewController

- (CGPathRef)peepShape
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(88.77, 65.23)];
    [bezierPath addCurveToPoint:CGPointMake(103.95, 99.82) controlPoint1:CGPointMake(98.37, 74.83) controlPoint2:CGPointMake(103.43, 87.25)];
    [bezierPath addCurveToPoint:CGPointMake(0.05, 99.82) controlPoint1:CGPointMake(70.47, 112.06) controlPoint2:CGPointMake(33.53, 112.06)];
    [bezierPath addCurveToPoint:CGPointMake(15.23, 65.23) controlPoint1:CGPointMake(0.57, 87.25) controlPoint2:CGPointMake(5.63, 74.83)];
    [bezierPath addCurveToPoint:CGPointMake(88.77, 65.23) controlPoint1:CGPointMake(35.54, 44.92) controlPoint2:CGPointMake(68.46, 44.92)];
    [bezierPath closePath];
    [bezierPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(28.5, 0, 46, 46)]];
    
    // center the shape
    CGAffineTransform tx = CGAffineTransformIdentity;
    tx = CGAffineTransformScale(tx, 0.25, 0.25);
    tx = CGAffineTransformTranslate(tx, -52.f, -104.f);
    [bezierPath applyTransform:tx];
    
    return bezierPath.CGPath;
}

- (CALayer *)peepLayer
{
    if (_peepLayer != nil) {
        return _peepLayer;
    }
    _peepLayer = [CAShapeLayer layer];
    _peepLayer.path = [self peepShape];
    _peepLayer.fillColor = self.color.CGColor;
    _peepLayer.transform = CATransform3DMakeTranslation(0.f, 45.f, 0.f);
    
    return _peepLayer;
}

- (CAAnimation *)scaleAnimation
{
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = kDuration;
    scale.values = @[@1.0, @1.2, @1.0, @1.0];
    scale.keyTimes = @[@0, @(1./4.f), @(1./2.), @1.];
    scale.repeatCount = 1e15;
    
    return scale;
}

- (CAAnimation *)colorAnimation
{
    CAKeyframeAnimation *color = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
    color.duration = kDuration;
    color.values = @[(__bridge id)self.color.CGColor, (__bridge id)self.highlightColor.CGColor, (__bridge id)self.color.CGColor, (__bridge id)self.color.CGColor];
    color.keyTimes = @[@0, @(1./3.f), @(2./3.), @1.];
    color.repeatCount = 1e15;
    
    return color;
}

- (void)addSpinner
{
    if (self.spinnerLayer) {
        return;
    }
    self.spinnerLayer = [CAReplicatorLayer layer];
    CGSize spinnerSize = self.spinnerContainer.bounds.size;
    self.spinnerLayer.position = CGPointMake(spinnerSize.width/2.f, spinnerSize.height/2.f);
    self.spinnerLayer.instanceCount = 8;
    self.spinnerLayer.instanceTransform = CATransform3DMakeRotation(M_PI_4, 0.f, 0.f, 1.f);
    self.spinnerLayer.instanceDelay = kDuration/8.f;
 
    [self.spinnerLayer addSublayer:[self peepLayer]];
    
    [self.spinnerContainer.layer addSublayer:self.spinnerLayer];
    
    [self.peepLayer addAnimation:[self colorAnimation] forKey:@"spin!"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.color = [UIColor colorWithRed:1. green:0.149 blue:0. alpha:0.1];
    self.highlightColor = [UIColor colorWithRed:1. green:0.149 blue:0. alpha:1.];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self addSpinner];
}

@end
