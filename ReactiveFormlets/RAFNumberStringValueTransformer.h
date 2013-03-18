//
//  RAFNumberStringValueTransformer.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const RAFNumberStringValueTransformerName;

// Injection from numbers to strings; partial function from strings to numbers.
@interface RAFNumberStringValueTransformer : NSValueTransformer
@end
