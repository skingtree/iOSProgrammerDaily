//
//  IPDTestRuntime.m
//  iOSProgrammerDaily
//
//  Created by skingtree on 2018/6/10.
//  Copyright © 2018 G0 Studio. All rights reserved.
//

#import "IPDTestRuntime.h"
#import <objc/runtime.h>

@implementation IPDTestRuntime

static NSMutableSet<Class> *classList = nil;
static NSMutableDictionary<NSString *, id> *signatureCache = nil;

+ (void)logAllClasses {
    cacheSignatures();
}

static void cacheSignatures () {
    classList = [[NSMutableSet alloc] init];
    signatureCache = [[NSMutableDictionary alloc] init];
    
    //get class list
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = (Class *)malloc(sizeof(Class) * (unsigned long)numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    //add to list for checking
    for (int i = 0; i < numClasses; i++)
    {
        //determine if class has a superclass
        Class someClass = classes[i];
        Class superclass = class_getSuperclass(someClass);
        NSLog(@"- NullSafe get class: %@ superClass: %@", NSStringFromClass(someClass), NSStringFromClass(superclass));
        while (superclass)
        {
            NSLog(@"- NullSafe next super someClass: super_class: %@ : %@", NSStringFromClass(someClass), NSStringFromClass(superclass));
            if (superclass == [NSObject class])
            {
                [classList addObject:someClass];
                [classList removeObject:[someClass superclass]];
                break;
            }
            superclass = class_getSuperclass(superclass);
        }
    }
    
    //free class list
    free(classes);
}

@end
