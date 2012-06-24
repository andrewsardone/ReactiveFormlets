//
//  JSMenuRow.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/13/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFMenuRow.h"
#import "RFTableFormViewController.h"
#import "RFTableForm.h"

@interface RFMenuRow ()
@property (strong, readonly) JSSingleSectionTableForm *menuForm;
@end

@implementation RFMenuRow {
    NSString *_title;
}

@synthesize cell = _cell;
@synthesize menuForm = _menuForm;

- (id)copyWithZone:(NSZone *)zone
{
    RFMenuRow *copy = [super copyWithZone:zone];
    copy->_title = _title;
    copy->_delegate = _delegate;
    copy->_menuForm = [_menuForm copy];
    return copy;
}

- (UITableViewCell *)cell
{
    if (_cell == nil)
    {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
        _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    _cell.textLabel.text = _title;
    return _cell;
}

- (JSSingleSectionTableForm *)menuForm
{
    if (_menuForm == nil)
    {
        Class MenuForm = [JSSingleSectionTableForm model:self.class.model];
        _menuForm = [[MenuForm new] modify:^(id<RFMutableOrderedDictionary> form) {
            for (id key in self)
            {
                form[key] = self[key];
            }
        }];
    }

    return _menuForm;
}

- (void)rowWasSelected
{
    RFTableFormViewController *formController = [[RFTableFormViewController alloc] initWithForm:self.menuForm];
    formController.title = _title;
    [self.delegate menuRow:self displayViewController:formController];
}

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber
{
    return [self.menuForm subscribe:subscriber];
}

#pragma mark -

- (instancetype)withTitle:(NSString *)title
{
    RFMenuRow *copy = [self copy];
    copy->_title = title;
    return copy;
}


@end
