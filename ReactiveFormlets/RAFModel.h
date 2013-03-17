//
//  RAFFormletModels.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFLens.h>
#import <ReactiveFormlets/RAFSignalSource.h>

// A suitable model protocol emits a signal.
@protocol RAFModel <RAFSignalSource, RAFExtract>
@end

// Some primitive models are provided.
@protocol RAFText <RAFModel>
@concrete
- (NSString *)extract;
@end

@protocol RAFNumber <RAFModel>
@concrete
- (NSNumber *)extract;
@end

@interface NSString (RAFText) <RAFText>
@end

@interface NSNumber (RAFNumber) <RAFNumber>
@end
