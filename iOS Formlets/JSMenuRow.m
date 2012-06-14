//
//  JSMenuRow.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/13/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "JSMenuRow.h"
#import "JSTableFormViewController.h"
#import "JSTableForm.h"

@interface JSMenuRow ()
@property (strong, readonly) JSSingleSectionTableForm *menuForm;
@end

@implementation JSMenuRow {
    NSString *_title;
}

@synthesize cell = _cell;
@synthesize menuForm = _menuForm;

- (id)copyWithZone:(NSZone *)zone
{
    JSMenuRow *copy = [super copyWithZone:zone];
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
        _menuForm = [MenuForm new];

        for (id key in self)
        {
            _menuForm[key] = self[key];
        }
    }

    return _menuForm;
}

- (instancetype)initialData:(id)data
{
    JSMenuRow *copy = [self copy];
    copy->_menuForm = [_menuForm initialData:data];
    return copy;
}

- (void)rowWasSelected
{
    JSTableFormViewController *formController = [[JSTableFormViewController alloc] initWithForm:self.menuForm];
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
    JSMenuRow *copy = [self copy];
    copy->_title = title;
    return copy;
}


@end
