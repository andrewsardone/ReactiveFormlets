//
//  JSInputRow.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "JSInputRow.h"

@interface JSTextInputRow : JSInputRow
@end

@interface JSNumberInputRow : JSInputRow
@end


@interface JSInputRow () <UITextFieldDelegate>
@property (strong, readonly) UITextField *textField;
@property (copy) NSString *placeholder;
@end

@implementation JSInputRow
@synthesize textField = _textField;
@synthesize cell = _cell;

+ (instancetype)text
{
    return [JSTextInputRow new];
}

+ (instancetype)number
{
    return [JSNumberInputRow new];
}

- (id)copyWithZone:(NSZone *)zone
{
    JSInputRow *row = [super copyWithZone:zone];
    row->_placeholder = _placeholder;
    row.textField.text = self.textField.text;
    return row;
}

- (instancetype)placeholder:(NSString *)placeholder
{
    JSInputRow *copy = [self copy];
    copy->_placeholder = placeholder;
    copy.textField.text = self.textField.text;
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

    _textField.placeholder = _placeholder;
    return _cell;
}

- (void)displayValidation:(BOOL)isValid
{
    self.cell.backgroundColor = isValid ? [UIColor whiteColor] : [UIColor redColor];
}

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber
{
    [subscriber sendNext:self.textField.text];
    return [self.textField.rac_textSubscribable subscribe:subscriber];
}

- (instancetype)initialData:(id)data
{
    JSTextInputRow *copy = [self copy];
    copy.textField.text = data;
    return copy;
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
@end

@implementation JSNumberInputRow

- (UITextField *)textField
{
    UITextField *textField = [super textField];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    return textField;
}

- (instancetype)initialData:(id)data
{
    JSNumberInputRow *copy = [self copy];
    copy.textField.text = [data stringValue];
    return copy;
}

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber
{
    if (self.textField.text)
    {
        [subscriber sendNext:[NSDecimalNumber decimalNumberWithString:self.textField.text]];
    }

    return [[self.textField.rac_textSubscribable select:^id(NSString *text) {
        return [NSDecimalNumber decimalNumberWithString:text];
    }] subscribe:subscriber];
}

@end
