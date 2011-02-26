//
//  NSObject+Introspection.h
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (IntrospectionExtension)

// check if class is inherited from basClass
+ (BOOL)isInheritedFromClass:(Class) baseClass;

@end