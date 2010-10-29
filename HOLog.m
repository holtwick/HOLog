//
//  Copyright 2010 holtwick.it. All rights reserved.
//

#import "HOLog.h"

#import <objc/runtime.h>
#import <objc/message.h>
#include <execinfo.h>
#include <stdio.h>

#define _testStruct(type, conv) else if(strcmp(argtype, @encode(type)) == 0) { \
type *v = (type *)(Handle)stack; \
output = [output stringByAppendingFormat:@" %@:(%s)%@", [parts objectAtIndex:i - 2], #type, conv(*v)]; \
stack += sizeof(type); }

#define _testType(type, fmt) else if(strcmp(argtype, @encode(type)) == 0) { \
type *v = stack; \
output = [output stringByAppendingFormat:@" %@:(%s)" fmt, [parts objectAtIndex:i - 2], #type, *v]; \
stack += sizeof(type); }

NSString *__hoGetMethodCallWithArguments(id *__selfPtr, SEL __cmd) {

    // Get argument stack
    id __self = *__selfPtr;
    void *stack = __selfPtr;
    stack += sizeof(__self) + sizeof(__cmd);

    // Prepare Method info
    Method method = class_getInstanceMethod([__self class], __cmd);
    NSArray *parts = [NSStringFromSelector(method_getName(method)) componentsSeparatedByString:@":"];
    NSString *output = [NSString stringWithFormat:@"-[%@", NSStringFromClass([__self class])];

    // add function name if no arguments are there
    unsigned int argCount = method_getNumberOfArguments(method);
    if (argCount <= 2) {
      output = [output stringByAppendingFormat:@" %s", sel_getName(method_getName(method))];
    }

    // Loop arguments
    for(unsigned i = 2; i < argCount; ++i) {
        char *argtype = method_copyArgumentType(method, i);

        // Object
        if(strcmp(argtype, @encode(id)) == 0) {
            id o = (id)*(Handle)stack;
            if([o isKindOfClass:[NSString class]]) {
                output = [output stringByAppendingFormat:@" %@:@%@", [parts objectAtIndex:i - 2], [o description]];
            } else {
                output = [output stringByAppendingFormat:@" %@:%@", [parts objectAtIndex:i - 2], o];
            }
            stack += sizeof(o);

        }

        _testType(int, @"%d")
        _testType(unsigned int, @"%u")
        _testType(short, @"%hi")
        _testType(unsigned short, @"%hu")
        _testType(long long, @"%qi")
        _testType(unsigned long long, @"%qu")
        _testType(float, @"%f")
        _testType(double, @"%f")
        _testType(char, @"%d")
        _testType(char *, @"\"%s\"")

        _testStruct(CGPoint, NSStringFromCGPoint)
        _testStruct(CGRect, NSStringFromCGRect)
        _testStruct(CGSize, NSStringFromCGSize)
        _testStruct(NSRange, NSStringFromRange)

        else {
            output = [output stringByAppendingFormat:@" %@:***not supported '%s' | BREAKING HERE! ***", [parts objectAtIndex:i - 2], argtype];
            free(argtype);
            break;
        }

        free(argtype);
    }

    output = [NSString stringWithFormat:@"%@]", output];
    return output;
}

#undef _testStruct
#undef _testType
