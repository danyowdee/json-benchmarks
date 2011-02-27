//
//  NSObject+Introspection.m
//  JSONBenchmarks
//
//  Created by Martin Brugger on 26.02.11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "NSObject+Introspection.h"

#import <objc/runtime.h>

@implementation NSObject (IntrospectionExtension)

+(BOOL)isInheritedFromClass:(Class) baseClass
{
	Class currentClass = [self class];
	do
	{
		currentClass = class_getSuperclass(currentClass);
	} while (currentClass != nil && currentClass != baseClass);
	
	if (currentClass == baseClass)
	{
		return YES;
	}
	
	return NO;
}



@end
