//
//  RFTableFormViewController.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/13/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFTableFormViewController.h"
#import "RFTableForm.h"

@implementation RFTableFormViewController {
    RFTableForm *_form;
}

- (id)initWithForm:(RFTableForm *)form
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
