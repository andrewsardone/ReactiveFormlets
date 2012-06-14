//
//  Formlet.h
//  Formlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/RACSubscribable.h>

#define keypath(object, property) selector(self) ? RAC_KEYPATH(object,property) : nil
#define selfpath(property) keypath(self,property)

// Formlets are reactive and copyable.
@protocol Formlet <RACSubscribable, NSCopying>
- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock;
- (instancetype)initialData:(id)data;

@optional
- (RACSubscribable *)select:(id (^)(id x))selectBlock;
@end


// These primitive models have no keys. They are simply there so that we
// can unify the building blocks of formlets and their data under a
// single type. That is, an NSString is <Text>, as is a formlet that
// deals with text.
@protocol Text <Formlet>
+ (instancetype)text;
@end

@protocol Number <Formlet>
+ (instancetype)number;
@end

@interface NSString (Text) <Text>
@end

@interface NSNumber (Number) <Number>
@end
