//
//  Copyright 2010 holtwick.it. All rights reserved.
//

#import <objc/runtime.h> 
#import <objc/message.h>
#include <execinfo.h>
#include <stdio.h>

NSString *__hoGetMethodCallWithArguments(id *__selfPtr, SEL __cmd);

#define HOLogPing NSLog(@"\n\n  %@\n\n", __hoGetMethodCallWithArguments(&self, _cmd));
