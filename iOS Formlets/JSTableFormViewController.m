//
//  JSTableFormViewController.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/13/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "JSTableFormViewController.h"
#import "JSTableForm.h"

@implementation JSTableFormViewController {
    JSTableForm *_form;
}

- (id)initWithForm:(JSTableForm *)form
{
    if ((self = [self init]))
    {
        _form = form;
    }

    return self;
}

- (void)loadView
{
    self.view = _form.view;
}

@end
