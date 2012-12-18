//
//  JSInputRow.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFInputRow.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface JSTextInputRow : RFInputRow
@end

@interface JSNumberInputRow : RFInputRow
@end


@interface RFInputRow () <UITextFieldDelegate>
@property (strong, readonly) UITextField *textField;
@end

@implementation RFInputRow
@synthesize textField = _textField;
@synthesize cell = _cell;
@dynamic currentValue;

+ (instancetype)text
{
    return [JSTextInputRow new];
}

+ (instancetype)secureText
{
    return [[JSTextInputRow new] modifyTextField:^(UITextField *field) {
        field.secureTextEntry = YES;
    }];
}

+ (instancetype)number
{
    return [JSNumberInputRow new];
}

- (id)copyWithZone:(NSZone *)zone
{
    RFInputRow *row = [self.class new];
    row.textField.text = self.textField.text;
    row.textField.placeholder = self.textField.placeholder;
    row.textField.secureTextEntry = self.textField.secureTextEntry;
    row.textField.autocorrectionType = self.textField.autocorrectionType;
    row.textField.autocapitalizationType = self.textField.autocapitalizationType;
    return row;
}

- (instancetype)placeholder:(NSString *)placeholder
{
    return [self modifyTextField:^(UITextField *field) {
        field.placeholder = placeholder;
    }];
}

- (instancetype)modifyTextField:(void (^)(UITextField *field))block
{
    RFInputRow *copy = [self copy];
    block(copy.textField);
    return copy;
}

- (UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0.f, 5.f, 285.f, 35.f)];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }

    return _textField;
}

- (UITableViewCell *)cell
{
    if (!_cell)
    {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextCell"];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;

        _cell.accessoryView = self.textField;
    }
    return _cell;
}

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber
{
    [subscriber sendNext:self.textField.text];
    return [self.textField.rac_textSignal subscribe:subscriber];
}

- (NSString *)stringValue
{
    return self.textField.text;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark -

- (void)rowWasSelected
{
    [self.textField becomeFirstResponder];
}

@end


@implementation JSTextInputRow

- (id)currentValue
{
    return self.textField.text;
}

- (void)setCurrentValue:(id)currentValue
{
    self.textField.text = currentValue;
}

@end

@implementation JSNumberInputRow

- (UITextField *)textField
{
    UITextField *textField = [super textField];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    return textField;
}

- (id)currentValue
{
    return [NSDecimalNumber decimalNumberWithString:self.textField.text];
}

- (void)setCurrentValue:(id)currentValue
{
    self.textField.text = [currentValue stringValue];
}

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber
{
    if (self.textField.text)
    {
        [subscriber sendNext:self.currentValue];
    }

    return [[self.textField.rac_textSignal map:^id(NSString *text) {
        return [NSDecimalNumber decimalNumberWithString:text];
    }] subscribe:subscriber];
}

@end
