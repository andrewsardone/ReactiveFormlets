//
//  RAFIdentityValueTransformer.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const RAFIdentityValueTransformerName;

// Provides a trivial identity bijection:
//
//   forall A, A <=> A.
//
@interface RAFIdentityValueTransformer : NSValueTransformer
@end
