//
//  RAFValidation.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 1/23/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXTConcreteProtocol.h"

@protocol RAFValidator <NSObject>
@concrete
// If no implementation is provided, values are assumed valid.
- (BOOL)raf_isValid:(id)value;
@end
