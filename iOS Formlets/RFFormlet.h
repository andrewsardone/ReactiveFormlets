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

// Formlets are reactive and copyable.
@interface RFFormlet : RFReifiedProtocol <NSCopying>
@property (copy) id currentValue;
- (instancetype)withValue:(id)value;
- (RACSignal *)signal;
@end

// These primitive models have no keys. They are simply there so that we
// can unify the building blocks of formlets and their data under a
// single type. That is, an NSString is <Text>, as is a formlet that
// deals with text.
@protocol Text
+ (instancetype)text;
+ (instancetype)secureText;
@end

@protocol Number
+ (instancetype)number;
@end

@interface NSString (Text) <Text>
@end

@interface NSNumber (Number) <Number>
@end
