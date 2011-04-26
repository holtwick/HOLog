//
// Copyright 2011, Dirk Holtwick
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "HOLog.h"

#if TARGET_IPHONE_SIMULATOR

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

NSString *HOGetMethodCallWithArguments(id *__selfPtr, SEL __cmd, char *fallback) {
    
    NSString *fallbackString = [NSString stringWithFormat:@"%s", fallback];
    
    // If called inside a block we will not be able to get the arguments correctly, therefore fall back
    if([fallbackString hasPrefix:@"__-"]) {
        return fallbackString;
    }
    
    @try {
        
        // Get argument stack
        id __self = *__selfPtr;
        void *stack = __selfPtr; 
        stack += sizeof(__self) + sizeof(__cmd); 
        
        // Prepare Method info    
        Method method = class_getInstanceMethod([__self class], __cmd); 
        NSString *methodName = NSStringFromSelector(method_getName(method));
        NSString *output = [NSString stringWithFormat:@"-[%@", NSStringFromClass([__self class])]; 
        
        int nargs = method_getNumberOfArguments(method);    
        if(nargs <= 2) {
            // No arguments
            output = [output stringByAppendingFormat:@" %@", methodName]; 
            
        } else {    
            // Loop arguments
            NSArray *parts = [methodName componentsSeparatedByString:@":"]; 
            
            for(unsigned i = 2; i < nargs; ++i) {         
                char *argtype = method_copyArgumentType(method, i); 
                
                // NSLog(@"%s", argtype);
                
                // Object
                if(strcmp(argtype, @encode(id)) == 0) { 
                    id o = (id)*(Handle)stack;
                    if([o isKindOfClass:[NSString class]]) {
                        output = [output stringByAppendingFormat:@" %@:@\"%@\"", [parts objectAtIndex:i - 2], [o description]]; 
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
        }
        
        output = [NSString stringWithFormat:@"%@]", output]; 
        return output;
        
    } @catch(NSException * e) {
        ;
    }    
    
    // If something wen't wrong we still get an informative feedback
    return fallbackString;
    
}

#undef _testStruct
#undef _testType

#endif
