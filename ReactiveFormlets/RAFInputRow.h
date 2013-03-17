//
//  RAFInputRow.h
//  ReactiveCocoa
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFFormlet.h>

@class UIView, UITableViewCell;

typedef BOOL (^RAFInputRowValidator)(id value);

// JSInputRow is a table row with a text field.
@interface RAFInputRow : RAFPrimitiveFormlet
@property (strong, readonly) UITableViewCell *cell;
@property (strong, readonly) RACCommand *rowWasSelected;

+ (Class)cellClass;

- (instancetype)placeholder:(NSString *)placeholder;

- (void)willDisplayCell:(UITableViewCell *)cell;
- (CGFloat)height;

- (UIView *)accessoryView;
@end

@interface RAFTextFieldInputRow : RAFInputRow
- (instancetype)modifyTextField:(void (^)(UITextField *field))block;
- (UITextField *)accessoryView;
@end

@interface RAFTextInputRow : RAFTextFieldInputRow <RAFText>
@end

@interface RAFNumberInputRow : RAFTextFieldInputRow <RAFNumber>
@end
