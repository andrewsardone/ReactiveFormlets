//
//  RAFInputRow.m
//  ReactiveCocoa
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFInputRow.h>
#import <ReactiveFormlets/RAFNumberStringValueTransformer.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation RAFInputRow
@synthesize cell = _cell;
@synthesize rowWasSelected = _rowWasSelected;

- (UITableViewCell *)cell {
	if (!_cell) {
		_cell = [[self.class.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.class)];
		_cell.selectionStyle = UITableViewCellSelectionStyleNone;
		_cell.accessoryView = self.accessoryView;
	}

	return _cell;
}

- (RACCommand *)rowWasSelected {
	if (!_rowWasSelected) {
		_rowWasSelected = [RACCommand command];
	}

	return _rowWasSelected;
}

+ (Class)cellClass {
	return [UITableViewCell class];
}

- (id)copyWithZone:(NSZone *)zone {
	RAFInputRow *row = [super copyWithZone:zone];
	[row updateInPlace:self.extract];
	return row;
}

- (UIView *)accessoryView {
	return nil;
}

- (instancetype)placeholder:(NSString *)placeholder {
	return nil;
}

- (void)willDisplayCell:(UITableViewCell *)cell {

}

- (CGFloat)height {
	return 44.f;
}

@end


@interface RAFTextFieldInputRow () <UITextFieldDelegate>
@property (strong, readonly) UITextField *textField;
@end

@implementation RAFTextFieldInputRow

- (id)init {
	if (self = [super init]) {
		_textField = [[UITextField alloc] initWithFrame:CGRectMake(0.f, 5.f, 285.f, 35.f)];
		_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_textField.returnKeyType = UIReturnKeyDone;
		_textField.delegate = self;

		[self.rowWasSelected subscribeNext:^(RAFTextFieldInputRow *row) {
			[row.textField becomeFirstResponder];
		}];
	}

	return self;
}

- (NSString *)keyPathForLens {
	return @keypath(self.textField.text);
}

- (RACSignal *)raf_signal {
	return [[self.textField.rac_textSignal map:^(NSString *text) {
		return [self.valueTransformer transformedValue:text];
	}] filter:^BOOL(id x) {
		return x != nil;
	}];
}

- (instancetype)placeholder:(NSString *)placeholder {
	return [self modifyTextField:^(UITextField *field) {
		field.placeholder = placeholder;
	}];
}

- (instancetype)modifyTextField:(void (^)(UITextField *field))block {
	RAFTextFieldInputRow *copy = [self copy];
	block(copy.textField);
	return copy;
}

- (UIView *)accessoryView {
	return self.textField;
}

- (id)copyWithZone:(NSZone *)zone {
	RAFTextFieldInputRow *row = [super copyWithZone:zone];
	UITextField *textField = row.textField;
	textField.font = row.textField.font;
	textField.textColor = row.textField.textColor;
	textField.textAlignment = row.textField.textAlignment;
	textField.frame = self.textField.frame;
	textField.placeholder = self.textField.placeholder;
	textField.secureTextEntry = self.textField.secureTextEntry;
	textField.autocorrectionType = self.textField.autocorrectionType;
	textField.autocapitalizationType = self.textField.autocapitalizationType;
	textField.keyboardType = self.textField.keyboardType;
	textField.keyboardAppearance = self.textField.keyboardAppearance;
	return row;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

@end

@implementation RAFTextInputRow

@end

@implementation RAFNumberInputRow

- (NSValueTransformer *)valueTransformer {
	return [NSValueTransformer valueTransformerForName:RAFNumberStringValueTransformerName];
}

- (UITextField *)textField {
	UITextField *textField = [super textField];
	textField.keyboardType = UIKeyboardTypeNumberPad;
	return textField;
}

@end
