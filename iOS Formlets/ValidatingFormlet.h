//
//  ValidatingFormlet.h
//  Formlets
//
//  Created by Jon Sterling on 6/2/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Formlet.h"
#import "JSReifiedProtocol.h"

typedef BOOL (^Validation)(id);

// ValidatingFormlet is the basic compound formlet, and implements
// recursive reactivity: that is, it's subscribables all the way down;
// changes to any contained subscribables (at any level of nesting)
// percolate up to the top formlet. When you subscribe to a formlet, you
// are subscribing to the entire data graph it represents.
@interface ValidatingFormlet : JSReifiedProtocol <Formlet>
- (instancetype)satisfies:(Validation)validation;
- (void)displayValidation:(BOOL)isValid;
@end
