//
//  RAFFormletModels.h
//  ReactiveCocoa
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAFSignalSource.h"

// A suitable model protocol emits a signal.
@protocol RAFModel <RAFSignalSource>
@end

// Two primitive models are provided.
@protocol Text <RAFModel>
@end

@protocol Number <RAFModel>
@end

@interface NSString (Text) <Text>
@end

@interface NSNumber (Number) <Number>
@end

