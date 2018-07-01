//
//  ViewController.m
//  iOSProgrammerDaily
//
//  Created by skingtree on 2018/6/3.
//  Copyright © 2018 G0 Studio. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

#import "IPDTestRuntime.h"
#import "Father.h"
#import "Uncle.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)testBlockCaptureVariables {
    NSString *text = @"start hello";
    void (^ block) (NSString *) = ^(NSString *message) {
        NSLog(@"[START] message: %@", message);
        message = @"end";
        NSLog(@"[END] message: %@", message);
    };
    
    block(text);
    for (int i = 0; i < 10; i ++) {
        //text = [NSString stringWithFormat:@" at %@", @(i)];
        block(text);
    }
}

- (void)testUIViewWithImage {
    CALayer *layer = [CALayer new];
    UIImage *image = [UIImage imageNamed:@"yellow_tracksuit"];
    layer.contents = (__bridge id _Nullable)(image.CGImage) ;
    
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
}

- (void)testIMP_exchange_ISA {
    Father *father = [Father new];
    Uncle  *uncle  = [Uncle new];
    NSLog(@"-- start --");
    [father sayHello];
    [uncle sayHello];
    
    //
    SEL originalSelector = @selector(sayHello);
    SEL swizzledSelector = @selector(sayHello);
    Method originalMethod = class_getInstanceMethod([father class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([uncle class], swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
    NSLog(@"-- exchange --");
    
    [father sayHello];
    [uncle sayHello];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self testBlockCaptureVariables];
    //[self testUIViewWithImage];
    //[IPDTestRuntime logAllClasses];
    
    [self testIMP_exchange_ISA];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
