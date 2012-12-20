//
//  RFIdentityValueTransformer.h
//  iOS Formlets
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const RFIdentityValueTransformerName;

// Provides a trivial identity bijection:
//
//   forall A, A <=> A.
//
@interface RFIdentityValueTransformer : NSValueTransformer
@end
