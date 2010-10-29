//
//  HOLogDemoAppDelegate.h
//  HOLogDemo
//
//  Created by Dirk Holtwick on 29.10.10.
//  Copyright 2010 holtwick.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HOLogDemoViewController;

@interface HOLogDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HOLogDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HOLogDemoViewController *viewController;

@end

