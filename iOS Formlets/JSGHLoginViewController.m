//
//  JSGHLoginViewController.m
//  ReactiveCocoa
//
//  Created by Jon Sterling on 6/24/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "JSGHLoginViewController.h"
#import "RAFTableForm.h"
#import "RAFInputRow.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "GHGitHubUser.h"
#import "GHGitHubClient.h"

@protocol GHCredentials <NSObject>
- (id<Text>)username;
- (id<Text>)password;
+ username:name password:pass;
@end

@interface JSGHLoginViewController ()
@property (strong, nonatomic) GHGitHubUser *user;
@property (strong, nonatomic) GHGitHubClient *client;
@property (assign, nonatomic) BOOL loading;

- (void)login:(id)sender;
@end

@implementation JSGHLoginViewController {
	RAFSingleSectionTableForm *_form;
}

- (void)loadView {
	// This is all the code you need to make a login form!
	Class<GHCredentials> LoginForm = [RAFSingleSectionTableForm model:@protocol(GHCredentials)];

	RAFTextInputRow *usernameField = [[RAFTextInputRow new] modifyTextField:^(UITextField *field) {
		field.autocapitalizationType = UITextAutocapitalizationTypeNone;
		field.autocorrectionType = UITextAutocorrectionTypeNo;
	}];

	_form = [LoginForm username:[usernameField placeholder:@"username"]
					   password:[[RAFTextInputRow new] placeholder:@"password"]];


	// And you're done!
	id loginButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login"
														  style:UIBarButtonItemStyleDone
														 target:self
														 action:@selector(login:)];


	UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[indicatorView startAnimating];

	id activityItem = [[UIBarButtonItem alloc] initWithCustomView:indicatorView];

	RAC(self.navigationItem.rightBarButtonItem) = [RACAbleWithStart(loading) map:^(NSNumber *loading) {
		BOOL isLoading = loading.boolValue;
		return !isLoading ? loginButtonItem : activityItem;
	}];

	RAC(self.navigationItem.rightBarButtonItem.enabled) = [[_form.rf_signal map:^(id<GHCredentials> credentials) {
		BOOL ready = [(id)credentials.username length] > 0 && [(id)credentials.password length] > 0;
		return @(ready);
	}] startWith:@NO];

	self.view = _form.view;
}

#pragma mark -

- (void)login:(id)sender {
	id<GHCredentials> credentials = _form.read;
	self.user = [GHGitHubUser userWithUsername:(id)credentials.username
									  password:(id)credentials.password];
	self.client = [GHGitHubClient clientForUser:self.user];
	self.loading = YES;

	RACSignal *loginResult = [self.client login];

	__weak JSGHLoginViewController *weakSelf = self;
	[loginResult subscribeNext:^(id x) {

	} error:^(NSError *error) {
		weakSelf.loading = NO;
		[[[UIAlertView alloc] initWithTitle:@"Failed!" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	} completed:^{
		weakSelf.loading = NO;
		[[[UIAlertView alloc] initWithTitle:@"Logged in!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	}];
}

@end
