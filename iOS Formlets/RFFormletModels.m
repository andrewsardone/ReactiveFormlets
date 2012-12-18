//
//  RFFormletModels.m
//  iOS Formlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFFormletModels.h"
#import <ReactiveCocoa/RACSignal.h>

@interface NSObject (RFModel) <RFModel>
@end

@implementation NSObject (RFModel)

- (id<RACSignal>)rf_signal {
	return [RACSignal return:self];
}

@end