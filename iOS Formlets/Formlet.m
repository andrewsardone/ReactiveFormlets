//
//  Formlet.m
//  Formlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "Formlet.h"
#import <ReactiveCocoa/RACBehaviorSubject.h>

@implementation NSString (Text)

+ (instancetype)text
{
    return @"";
}

- (instancetype)initialData:(id)initialData
{
    return initialData;
}

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber
{
    return [[RACBehaviorSubject behaviorSubjectWithDefaultValue:self] subscribe:subscriber];
}

@end

@implementation NSNumber (Number)

+ (instancetype)number
{
    return [NSDecimalNumber zero];
}

- (instancetype)initialData:(id)data
{
    return data;
}

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber
{
    return [[RACBehaviorSubject behaviorSubjectWithDefaultValue:self] subscribe:subscriber];
}

@end
