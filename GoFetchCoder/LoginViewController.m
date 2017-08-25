//
//  LoginViewController.m
//  GoFetchCoder
//
//  Created by Guest on 1/18/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "LoginViewController.h"
#import "LandingViewController.h"
#import "DataManager.h"
#import "RegistrationViewController.h"
#import "LoginAuthenticationOperation.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "RegistrationVC.h"
#import "UIFont+GFCAdditions.h"
#import "NSString+GFCAdditions.h"
#import "NGNavigationBarMenu.h"
#import "EncryptionManager.h"
#import "UIColor+GFCAdditions.h"



@interface LoginViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSString *username,*password;
    NSData *sharedLoginInfo;
    Boolean flagSwitch;
} 

@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblToggle;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnToSign;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UIView *editLine;

- (IBAction)btnEye:(id)sender;
- (IBAction)switchAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableViewCell *cellEmail;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellPassword;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UISwitch *switchKeepMeLoggedIn;

@property (nonatomic,strong)NSMutableArray *arrayCells;

@end

@implementation LoginViewController


#pragma mark - UItextfield

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_txtEmail]) {
        if ([textField.text isValidEmail]) {
            [self hideEmailError];
        }else{
            [self showEmailError];
        }
    }
    
    if ([textField isEqual:_txtPassword]) {
        if (textField.text.length < 6) {
            [self showPasswordError];
        }else{
            [self hidePasswordError];
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _txtEmail) {
        [_txtEmail becomeFirstResponder];
    }
    else if (textField == _txtPassword){
        [_txtPassword resignFirstResponder];
    }
    
    return YES;
}


-(void)showEmailError {
    
    _lblEmail.text = @"Email is incorrect";
}

-(void)hideEmailError {
    _lblEmail.text = @"";
}

-(void)showPasswordError {
    
    _lblPassword.text = @"Password lenght should be longer than 6!";
}

-(void)hidePasswordError {
    _lblEmail.text = @"";
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch= [touches anyObject];
    if ([touch view] == self.view)
        [self dismissKeyboard];
}


-(void)showError:(NSString *)error
{
    
    if ([error caseInsensitiveCompare:@"PASSWORD_MISMATCH"] == NSOrderedSame) {
        error = @"Please check your email and password";
    }
    
    else if ([error caseInsensitiveCompare:@"LOGIN_FAILED"] == NSOrderedSame) {
        error = @"Please check your email and password";
    }
    
    else if ([error caseInsensitiveCompare:@"INVALID_FIELD"] == NSOrderedSame) {
        error = @"Please enter your email and password.";
    }
    else {
        //error = kERROR_TECHNICAL;
    }
    
    [self.view layoutIfNeeded];


}

-(void)hideError
{
    [self.view layoutIfNeeded];
    
}


//- (void)resetLoginCredentials
//{
//    AppDelegate *appDeledate = kAppDelegate;
//    [appDeledate.keychain resetKeychainItem];
//}


//- (void)saveLoginCredentials
//{
//    AppDelegate *appDeledate = kAppDelegate;
//
//    NSData *encryptedEmail    = [[EncryptionManager sharedInstance] getEncryptedData:username];
//    NSData *encryptedPassword = [[EncryptionManager sharedInstance] getEncryptedData:password];
//
//    [appDeledate.keychain setObject:encryptedEmail      forKey:(__bridge id)kSecAttrAccount];
//    [appDeledate.keychain setObject:encryptedPassword   forKey:(__bridge id)kSecValueData];
//    
//}

- (void) saveLoginData{
    
    username = [[NSString alloc] initWithString:_txtEmail.text];
    password = [[NSString alloc] initWithString:_txtPassword.text];
    
    if (_switchKeepMeLoggedIn.isOn) {
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"preEmail"];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"prePassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else{
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"preEmail"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"prePassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}

- (void) getLogData{
    
    username = [[NSUserDefaults standardUserDefaults] stringForKey:@"preEmail"];
    password = [[NSUserDefaults standardUserDefaults] stringForKey:@"prePassword"];
    
    _txtEmail.text = username;
    _txtPassword.text = password;
    
 }

- (IBAction)btnLoginAction:(id)sender {
    
    if (!_txtEmail.text.length || !_txtPassword.text.length) {
        [self showError:@"Please enter your email and password"];
        return;
    }
    
    if (![_txtEmail.text isValidEmail]) {
        [self showError:@"Please check your email"];
        return;
    }
    
    [self hideError];
    
    
    [self.view endEditing:YES];
    
    [self showLoadingIndicator];
    
    
    username = [[NSString alloc] initWithString:_txtEmail.text];
    password = [[NSString alloc] initWithString:_txtPassword.text];
    
    
    AppDelegate *appDelegate = kAppDelegate;
    
    LoginAuthenticationOperation *operation= [[LoginAuthenticationOperation alloc] init];
    operation.username = username;
    operation.password = password;
    
    operation.onSuccess = ^(NSString *authToken) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:kAuthToken];
            if(_switchKeepMeLoggedIn.isOn){
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:kKeepMeLoggedIn];
                [self saveLoginData];
            }else {
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:kKeepMeLoggedIn];
            }
            [self showLandingScreen];
        });
    };
    
    operation.onFailure = ^(NSDictionary *failureDict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingIndicator];
//            [self resetLoginCredentials];
            
//            [self showError:failureDict[@"status"]];
            [self showError:kERROR_TECHNICAL];
        });
    };
    [appDelegate.queue addOperation:operation];
}

-(void)showLandingScreen{
    
    [self showLoadingIndicator];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    AppDelegate *appDelegate = kAppDelegate;
    
    
    [appDelegate.loginVC.navigationController setViewControllers:[NSArray arrayWithObject: appDelegate.landingVC] animated:YES];
    
}

- (IBAction)btnForgotPasswordAction:(id)sender {
    
}

- (IBAction)btnSignupAction:(id)sender {
    //Registtation page
    
//    RegistrationVC *vc = [[RegistrationVC alloc] initWithNibName:NSStringFromClass([RegistrationVC class]) bundle:nil];
//    vc.delegate = self;
//    
//    [self presentViewController:vc animated:YES completion:NULL];
    AppDelegate *appDelegate = kAppDelegate;
    
    RegistrationVC *registrationVC = appDelegate.registrationVC;
    [self.navigationController pushViewController:registrationVC animated:YES];

    
}
- (IBAction)btnHelpAction:(id)sender {

    AppDelegate *appDelegate =kAppDelegate;
    [self.navigationController pushViewController:appDelegate.helpVC animated:YES];

}

-(void)calculateTableHeight {
    CGFloat height = 0;
    for (UITableViewCell *cell in _arrayCells) {
        height += cell.frame.size.height;
    }
    
    _table.frame = CGRectMake(_table.frame.origin.x,
                              _table.frame.origin.y,
                              _table.frame.size.width,
                              height);
}

#pragma mark - UIviewController delegate & datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = _arrayCells[indexPath.row];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_arrayCells objectAtIndex:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFontFamily:@"Lato-Regular" forView:self.view andSubViews:YES];

    // show the registered loginData.
    [self getLogData];
    
    flagSwitch = false;
    
    // set fontfamily
   
    
    //add tableviewcells into tableview
    _table.layer.borderWidth = 2.0;
    _table.layer.borderColor = [UIColor grayColor].CGColor;
    _arrayCells = [NSMutableArray arrayWithObjects:
                   _cellEmail,
                   _cellPassword,
                   nil];
    
    [self calculateTableHeight];
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // set properties of all subviews.
    [self setUpView];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    
//    // Autologin
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:kKeepMeLoggedIn]) {
//        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken] == nil) {
//            return;
//        }
//        
//        [self autoLoginWithCallbackBlock:^(BOOL isAutoLoginSuccessful, id response) {
//            if (isAutoLoginSuccessful) {
//                [self showLandingScreen];
//            }
//            else {
//                response = (NSDictionary *)response;
//                if (response && response[@"status"]) {
//                    [self showError:response[@"status"]];
//                }
//                else {
//                    [self showError:kERROR_TECHNICAL];
//                }
//            }
//        }];
//    }

}

-(void)setUpView {
    
//    [super hidePopupMenu];

    //  UI ...
    self.txtEmail.font         = [UIFont fontWithName:@"Lato-Regular" size:17.0];
    self.txtPassword.font      = [UIFont fontWithName:@"Lato-Regular" size:17.0];
    self.lblLogin.font         = [UIFont fontWithName:@"Lato-Light" size:40.0];
    
    self.lblEmail.font         = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    self.lblPassword.font         = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    
    [self.btnLogin setBackgroundColor: [UIColor defaultColor]];
    [self.btnToSign setBackgroundColor: [UIColor defaultColor]];
    [self.viewLine setBackgroundColor: [UIColor actionbarLineColor]];
    [self.editLine setBackgroundColor: [UIColor editLineColor]];
    [self.switchKeepMeLoggedIn setTintColor: [UIColor defaultColor]];
    
    self.table.layer.borderColor = [UIColor editLineColor].CGColor;
    
    // Constraints ...
    
}


// hide text as password
- (IBAction)btnEye:(id)sender {
    _txtPassword.secureTextEntry = !_txtPassword.secureTextEntry;
}

- (IBAction)switchAction:(id)sender {
    
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        flagSwitch = true;
    } else {
        flagSwitch = false;
    }
}


// set fontfamily for all of subviews on view
-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    
    if ([view isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)view;
        [btn setFont:[UIFont fontWithName:fontFamily size:[[btn font] pointSize]]];
    }

    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}

@end
