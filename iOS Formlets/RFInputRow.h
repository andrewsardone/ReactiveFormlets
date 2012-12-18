//
//  JSInputRow.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFFormlet.h"
#import "RFFormletModels.h"

// JSInputRow is a table row with a text field.
@interface RFInputRow : RFPrimitiveFormlet
@property (strong, readonly) UITableViewCell *cell;

- (instancetype)modifyTextField:(void (^)(UITextField *field))block;
- (instancetype)placeholder:(NSString *)placeholder;

- (void)rowWasSelected;
@end


@interface RFTextInputRow : RFInputRow <Text>
@end

@interface RFNumberInputRow : RFInputRow <Number>
@end