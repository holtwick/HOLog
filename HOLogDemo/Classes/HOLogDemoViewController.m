//
//  HOLogDemoViewController.m
//  HOLogDemo
//
//  Created by Dirk Holtwick on 29.10.10.
//  Copyright 2010 holtwick.it. All rights reserved.
//

#import "HOLogDemoViewController.h"
#import "HOLog.h"

@implementation HOLogDemoViewController

- (void)exampleInt:(int)v {
    HOLogPing
}

- (void)exampleMethod:(id)obj 
                   a1:(int)a1 
                   a2:(CGPoint)a2
                   a3:(double)a3 
                   a4:(BOOL)a4

{
    
    // In the following line happens the magic!!!
    HOLogPing
    
    // ...
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self exampleInt:1];
    
    // Test call
    [self exampleMethod:@"a string"
                     a1:42 
                     a2:CGPointMake(12, 21) 
                     a3:1.23
                     a4:YES
     ];
    
    ^(id x) {
        
        // Will fail        
        HOLogPing
        
    }(nil);
}

@end
