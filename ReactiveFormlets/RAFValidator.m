//
//  RAFValidation.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 1/23/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFValidator.h>

@concreteprotocol(RAFValidator)

- (BOOL)raf_isValid:(id)value {
	return YES;
}

@end
