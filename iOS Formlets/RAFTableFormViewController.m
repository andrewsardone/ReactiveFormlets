//
//  RAFTableFormViewController.m
//  ReactiveCocoa
//
//  Created by Jon Sterling on 6/13/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFTableFormViewController.h"
#import "RAFTableForm.h"

@implementation RAFTableFormViewController {
	RAFTableForm *_form;
}

- (id)initWithForm:(RAFTableForm *)form {
	if (self = [self init]) {
		_form = form;
	}

	return self;
}

- (void)loadView {
	self.view = _form.view;
}

@end
