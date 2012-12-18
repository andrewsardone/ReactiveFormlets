//
//  Formlet.h
//  Formlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/RACSignal.h>
#import "RFReifiedProtocol.h"

#define selfpath(property) keypath(self,property)

// Formlets are reactive and copyable.
@protocol RFFormlet <RACSignal, NSCopying>
@property (copy) id currentValue;
- (instancetype)withValue:(id)value;
@end

@interface RFFormlet : RACSignal <RFFormlet>
+ (Class)model:(Protocol *)model;
+ (Protocol *)model;
@end

@interface RFFormlet (Dictionary) <RFMutableOrderedDictionary, NSFastEnumeration>
@end


// These primitive models have no keys. They are simply there so that we
// can unify the building blocks of formlets and their data under a
// single type. That is, an NSString is <Text>, as is a formlet that
// deals with text.
@protocol Text
+ (instancetype)text;
+ (instancetype)secureText;
- (NSString *)stringValue;
@end

@protocol Number
+ (instancetype)number;
@end

@interface NSString (Text) <Text>
@end

@interface NSNumber (Number) <Number>
@end
