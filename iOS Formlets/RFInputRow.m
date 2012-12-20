//
//  RFInputRow.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFInputRow.h"
#import "RFNumberStringValueTransformer.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RFInputRow () <UITextFieldDelegate>
@property (strong, readonly) UITextField *textField;
@end

@implementation RFInputRow
@synthesize textField = _textField;
@synthesize cell = _cell;

- (NSString *)keyPathForLens {
	return @keypath(self.textField.text);
}

- (id<RACSignal>)rf_signal {
	return [self.textField.rac_textSignal map:^(NSString *text) {
		return [self.valueTransformer transformedValue:text];
	}];
}

- (id)copyWithZone:(NSZone *)zone {
	RFInputRow *row = [super copyWithZone:zone];
	row.textField.placeholder = self.textField.placeholder;
	row.textField.secureTextEntry = self.textField.secureTextEntry;
	row.textField.autocorrectionType = self.textField.autocorrectionType;
	row.textField.autocapitalizationType = self.textField.autocapitalizationType;
	[row updateInPlace:self.read];
	return row;
}

- (instancetype)placeholder:(NSString *)placeholder {
	return [self modifyTextField:^(UITextField *field) {
		field.placeholder = placeholder;
	}];
}

- (instancetype)modifyTextField:(void (^)(UITextField *field))block {
	RFInputRow *copy = [self copy];
	block(copy.textField);
	return copy;
}

- (UITextField *)textField {
	if (!_textField) {
		_textField = [[UITextField alloc] initWithFrame:CGRectMake(0.f, 5.f, 285.f, 35.f)];
		_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_textField.returnKeyType = UIReturnKeyDone;
		_textField.delegate = self;
	}

	return _textField;
}

- (UITableViewCell *)cell {
	if (!_cell) {
		_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextCell"];
		_cell.selectionStyle = UITableViewCellSelectionStyleNone;

		_cell.accessoryView = self.textField;
	}

	return _cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

#pragma mark -

- (void)rowWasSelected {
	[self.textField becomeFirstResponder];
}

@end


@implementation RFTextInputRow
@end

@implementation RFNumberInputRow

- (NSValueTransformer *)valueTransformer {
	return [NSValueTransformer valueTransformerForName:RFNumberStringValueTransformerName];
}

- (UITextField *)textField {
	UITextField *textField = [super textField];
	textField.keyboardType = UIKeyboardTypeNumberPad;
	return textField;
}

@end
