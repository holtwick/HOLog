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

// TODO: Currently this Logger crashes on iOS devices!

#if TARGET_IPHONE_SIMULATOR

#import <objc/runtime.h> 
#import <objc/message.h>
#include <execinfo.h>
#include <stdio.h>

NSString *HOGetMethodCallWithArguments(id *__selfPtr, SEL __cmd, char *fallback);  

#define HOLogPing \
        NSLog(@"%@", HOGetMethodCallWithArguments(&self, _cmd, (char *)__PRETTY_FUNCTION__));

#else

// Fallback solution for iOS devices

#define HOLogPing \
        NSLog(@"%s", __PRETTY_FUNCTION__);

#endif