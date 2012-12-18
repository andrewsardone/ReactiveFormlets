//
//  RFFormletModels.h
//  iOS Formlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFSignalSource.h"

@protocol RFModel <RFSignalSource> @end

@protocol Text <RFModel> @end
@protocol Number <RFModel> @end

@interface NSString (Text) <Text>
@end

@interface NSNumber (Number) <Number>
@end
