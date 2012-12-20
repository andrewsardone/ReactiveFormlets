//
//  RFFormletModels.h
//  iOS Formlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFSignalSource.h"

// A suitable model protocol emits a signal.
@protocol RFModel <RFSignalSource>
@end

// Two primitive models are provided.
@protocol Text <RFModel>
@end

@protocol Number <RFModel>
@end

@interface NSString (Text) <Text>
@end

@interface NSNumber (Number) <Number>
@end

