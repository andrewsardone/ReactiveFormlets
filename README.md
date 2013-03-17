### Installing

Just add the following to your `Podfile`:

    pod 'ReactiveFormlets', :git => 'git://github.com/jonsterling/ReactiveFormlets.git'


### An Example

~~~~{.objc}
@protocol LoginModel <RAFModel>
- (id<RAFText>)emailAddress;
- (id<RAFText>)password;
+ (instancetype)emailAddress:(id<RAFText>)email password:(id<RAFText>)password;
@end

@implementation LoginTableViewController {
    RAFTableForm<LoginModel> *_form;
}

- (void)loadView {
    [super loadView];

    Class LoginForm = [RAFSingleSectionTableForm model:@protocol(LoginModel)];
    RAFTextFieldInputRow *field = [RAFTextFieldInputRow new];

    RAFInputRowValidator emailAddressValidator = ^BOOL (NSString *input) {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:input];
    };

    RAFInputRowValidator requiredTextValidator = ^BOOL (NSString *input) {
        return input.length > 0;
    };

    id<RAFText> emailField = [[field modifyTextField:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }] validators:@[ emailAddressValidator ]]

    id<RAFText> passwordField = [[field modifyTextField:^(UITextField *textField) {
        textField.secureTextEntry = YES;
    }] validators:@[ requiredTextValidator ]];

    _form = [LoginForm emailAddress:[emailField placeholder:@"snoop@dogg.com"]
                           password:[passwordField placeholder:@"password"]];

    self.view = [_form buildView];
}
~~~~

### Authors and Contributors

@jonsterling wrote this.

