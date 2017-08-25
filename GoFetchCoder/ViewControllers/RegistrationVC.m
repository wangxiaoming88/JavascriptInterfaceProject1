//
//  RegistrationVC.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/29/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "RegistrationVC.h"
#import "HelpVC.h"
#import "SignupCustomCellTableViewCell.h"
#import  "QuartzCore/QuartzCore.h"
#import "UIColor+GFCAdditions.h"
#import "Constants.h"
#import "GCFAPIClient.h"
#import "LandingViewController.h"

#import "AppDelegate.h"
#import "NSString+GFCAdditions.h"
#import "UIFont+GFCAdditions.h"
#import "UIColor+GFCAdditions.h"

/*typedef enum
{
    None,
    Individual,
    Team,
    Organisation,
} EnrollmentType;*/

@interface RegistrationVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *labelEmailError;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellFirstName;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellLastName;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellEmail;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblPasswordError;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellSignupTitle;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellTermsConditions;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellSIgnupButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellTeamCell;
//showinf and hiding loses its memory
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTeamSegment;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnHelpAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnOrganisation;
@property (weak, nonatomic) IBOutlet UIButton *btnIndividual;
@property (weak, nonatomic) IBOutlet UIButton *btnteam;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldTeamName;
@property (weak, nonatomic) IBOutlet UIButton *btnToLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSingup;
@property (weak, nonatomic) IBOutlet UIView *lineActionBar;
@property (weak, nonatomic) IBOutlet UIView *editline1;
@property (weak, nonatomic) IBOutlet UIView *editline2;
@property (weak, nonatomic) IBOutlet UIView *editline3;
@property (weak, nonatomic) IBOutlet UIView *editline4;
@property (weak, nonatomic) IBOutlet UIView *editline5;
@property (weak, nonatomic) IBOutlet UIView *editline6;
@property (weak, nonatomic) IBOutlet UILabel *lblSignup;

@property (nonatomic,strong)NSMutableArray *arrayCells;
@property (nonatomic,strong)NSMutableArray *arrayText;
@property(nonatomic,assign)EnrollmentType enrollmentType;
@end

@implementation RegistrationVC

- (IBAction)btnDropdownAction:(id)sender {
    if (!self.txtFieldTeamName.userInteractionEnabled) {
        [self.view endEditing:YES];
        [self showHideTeamSelectionSegmentCell];
    }
}

- (IBAction)showHidePassword:(id)sender {
    _txtPassword.secureTextEntry = !_txtPassword.secureTextEntry;
}

- (IBAction)enrollmentAction:(UIButton *)btn {

    self.txtFieldTeamName.text = @"";
    if (btn.tag == 0 || !btn) {
        // individual
        self.enrollmentType = Individual;
        self.txtFieldTeamName.text = @"Individual";
        self.txtFieldTeamName.userInteractionEnabled = NO;
        
        
        _btnIndividual.backgroundColor = [UIColor defaultColor];
        [_btnIndividual setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
        
        _btnteam.backgroundColor = [UIColor whiteColor];
        [_btnteam setTitleColor:[UIColor defaultColor]
                       forState:UIControlStateNormal];
        
        _btnOrganisation.backgroundColor = [UIColor whiteColor];
        [_btnOrganisation setTitleColor:[UIColor defaultColor]
                       forState:UIControlStateNormal];
    }
    else if(btn.tag == 1) {
        // team
        self.enrollmentType = Team;

        self.txtFieldTeamName.placeholder = @"Please enter your Team name";
        self.txtFieldTeamName.userInteractionEnabled = YES;

        _btnteam.backgroundColor = [UIColor defaultColor];
        [_btnteam setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];

        _btnIndividual.backgroundColor = [UIColor whiteColor];
        [_btnIndividual setTitleColor:[UIColor defaultColor]
                       forState:UIControlStateNormal];
        
        _btnOrganisation.backgroundColor = [UIColor whiteColor];
        [_btnOrganisation setTitleColor:[UIColor defaultColor]
                               forState:UIControlStateNormal];
    }
    else {
        //organisation
        self.enrollmentType = Organisation;
        self.txtFieldTeamName.placeholder = @"Please enter your Organization name";
        self.txtFieldTeamName.userInteractionEnabled = YES;

        _btnOrganisation.backgroundColor = [UIColor defaultColor];
        [_btnOrganisation setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
        
        _btnIndividual.backgroundColor = [UIColor whiteColor];
        [_btnIndividual setTitleColor:[UIColor defaultColor]
                       forState:UIControlStateNormal];
        
        _btnteam.backgroundColor = [UIColor whiteColor];
        [_btnteam setTitleColor:[UIColor defaultColor]
                               forState:UIControlStateNormal];
    }
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

-(void)showHideTeamSelectionSegmentCell {
    if ([_arrayCells containsObject:_cellTeamSegment]) {
        //hide
        [_table beginUpdates];
        
        NSInteger index = [_arrayCells indexOfObject:_cellTeamSegment];
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:index inSection:0]];
        
        [_arrayCells removeObject:_cellTeamSegment];
        
        [_table deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

        [_table endUpdates];
    } else {
        //show
        NSInteger index = [_arrayCells indexOfObject:_cellTeamCell];
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:index +1 inSection:0]];
        [_table beginUpdates];

        [_arrayCells insertObject:_cellTeamSegment atIndex:index +1 ];
        
        [_table insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        
        [_table endUpdates];
    }
    [self calculateTableHeight];
    
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if ([cell isEqual:_cellTeamCell] && !self.txtFieldTeamName.userInteractionEnabled) {
//        [self.view endEditing:YES];
//        [self showHideTeamSelectionSegmentCell];
//    }
//}

-(void)dismissViewControllerAnimated {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btnLoginAction:(id)sender {
    [self dismissKeyboard];
    [self performSelector:@selector(dismissViewControllerAnimated) withObject:nil afterDelay:0.3];
}

#pragma mark - View Controller Lifecycle

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self enrollmentAction:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setFontFamily:@"Lato-Regular" forView:self.view andSubViews:YES];
    
    [self hidePopupMenu];
    // Do any additional setup after loading the view.
    _table.layer.borderWidth = 2.0;
    _table.layer.borderColor = [UIColor grayColor].CGColor;
    _arrayCells = [NSMutableArray arrayWithObjects:
                  /*_cellSignupTitle,*/
                  _cellFirstName,
                  _cellLastName,
                  _cellEmail,
                  _cellPassword,
                   _cellTeamCell,
                   _cellTeamSegment,
/*                  _cellTermsConditions,
                  _cellSIgnupButton,*/
                   nil];
    
    [self calculateTableHeight];
    
    [self setUpViews];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
//    [self enrollmentAction:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

//-(void)showLandingScreen {
//    
//    UINavigationController *nav =  (UINavigationController *)[self presentingViewController];
//    
//    LandingViewController *landingVC = [[LandingViewController alloc] initWithNibName:NSStringFromClass([LandingViewController class]) bundle:nil];
//            [nav pushViewController:landingVC animated:YES];
//    
//}

- (IBAction)btnSignupAction:(id)sender {
    NSLog(@"%@",@"Signup button tapped");
    _txtFirstName.text = [_txtFirstName.text trim];
    _txtLastName.text  = [_txtLastName.text trim];
    _txtEmail.text     = [_txtEmail.text trim];
    _txtPassword.text  = [_txtPassword.text trim];
    
    if (!_txtFirstName.text.length ||
        !_txtLastName.text.length ||
        !_txtEmail.text.length ||
        !_txtPassword.text.length ||
        _enrollmentType == None        ) {
        return;
    }
    [self showLoadingIndicator];
    
    [[GCFAPIClient instance] postService:@"http://do.gofetchcode.com/api/register"
                              parameters:[self getParams]
                                    type:@"POST"
                                 handler:^(NSURLResponse *urlResponse, id responseObject, NSError *error) {
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [self hideLoadingIndicator];
                                         
                                         if(error) {
                                             
//                                             [self showErrorAlertWithTitle:responseObject[@"message"] andDesription:responseObject[@"status"]];
                                             [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];
                                         }
                                         else {
                                         
//                                             [self showErrorAlertWithTitle:responseObject[@"message"] andDesription:responseObject[@"status"]];
//                                             [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];

//                                             [self dismissViewControllerAnimated:YES 
//                                              
//                                                                      completion:^{
//                                                                          if (self.delegate) {
//                                                                              [self.delegate showLandingScreen];
//                                                                          };
//                                                                          
//                                                                      }];

                                             
                                             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congrats"
                                                                                                            message:@"You are successfully registered"
                                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                             UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                 
                                             }];
                                             [alert addAction:action];
                                             
                                             LandingViewController *landVC = [[LandingViewController alloc] init];

                                             [self.navigationController pushViewController:landVC animated:YES];
                        
                                             
                                         }
                                         
                                         
                                          });
                                    
                                 }];
}

-(NSDictionary *)getParams {
    NSString *type = _enrollmentType == Individual ? @"INDIVIDUAL" :(_enrollmentType == Team ? @"TEAM" : @"ORGANISATION");
    NSMutableDictionary *dictionary = [@{@"firstName":self.txtFirstName.text,
                                         @"lastName":self.txtLastName.text,
                                         @"email":self.txtEmail.text,
                                         @"password":self.txtPassword.text,
                                         @"repeatPassword":self.txtPassword.text,
                                         @"type":type} mutableCopy];
    
    if([type isEqualToString: @"TEAM"]) {
        [dictionary setValue:@{@"name":self.txtFieldTeamName.text} forKey:@"team"];
    }
    if([type isEqual: @"ORGANISATION"] ) {
        [dictionary setValue:@{@"name":self.txtFieldTeamName.text} forKey:@"organization"];
    }
    return dictionary;
}

-(void)showEmailError {
    _labelEmailError.text = @"Email is incorrect";
}

-(void)hideEmailError {
    _labelEmailError.text = @"";
}

-(void)showPasswordError {
    
    _lblPasswordError.text = @"Password lenght should be longer than 6!";
}

-(void)hidePasswordError {
    _lblPasswordError.text = @"";
}

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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:_txtFirstName]) {
        [_txtLastName becomeFirstResponder];

    } else if ([textField isEqual:_txtLastName]) {
        [_txtEmail becomeFirstResponder];

    } else if ([textField isEqual:_txtEmail]) {
        [_txtPassword becomeFirstResponder];
    
    } else if ([textField isEqual:_txtPassword]) {
        [textField resignFirstResponder];
    }
    else if ([textField isEqual:self.txtFieldTeamName]) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch= [touches anyObject];
    if ([touch view] == self.view)
        [self dismissKeyboard];
}

-(void)setUpViews {
    
    self.lblSignup.font = [UIFont fontWithName:@"Lato-Light" size:40.0];

    
    self.txtFirstName.font = [UIFont inputTextFieldFont];
//    self.txtFirstName.textColor = [UIColor inputTextFieldColor];
    
    self.txtLastName.font = [UIFont inputTextFieldFont];
//    self.txtLastName.textColor = [UIColor inputTextFieldColor];
    
    self.txtPassword.font = [UIFont inputTextFieldFont];
//    self.txtPassword.textColor = [UIColor inputTextFieldColor];
    
    self.txtEmail.font = [UIFont inputTextFieldFont];
//    self.txtEmail.textColor = [UIColor inputTextFieldColor];
    
    self.txtFieldTeamName.font = [UIFont inputTextFieldFont];
//    self.txtFieldTeamName.textColor = [UIColor inputTextFieldColor];
    
    self.btnIndividual.titleLabel.font = [UIFont inputTextFieldFont];
    self.btnteam.titleLabel.font = [UIFont inputTextFieldFont];
    self.btnOrganisation.titleLabel.font = [UIFont inputTextFieldFont];
    
    
    [self.btnSingup setBackgroundColor:[UIColor defaultColor]];
    [self.btnToLogin setBackgroundColor:[UIColor defaultColor]];
    
    [self.lineActionBar setBackgroundColor:[UIColor actionbarLineColor]];
     self.table.layer.borderColor = [UIColor editLineColor].CGColor;
    
    [self.editline1 setBackgroundColor: [UIColor editLineColor]];
    [self.editline2 setBackgroundColor: [UIColor editLineColor]];
    [self.editline3 setBackgroundColor: [UIColor editLineColor]];
    [self.editline4 setBackgroundColor: [UIColor editLineColor]];
    [self.editline5 setBackgroundColor: [UIColor editLineColor]];
    [self.editline6 setBackgroundColor: [UIColor editLineColor]];

}

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
        [btn.titleLabel setFont:[UIFont fontWithName:fontFamily size:[[btn.titleLabel font] pointSize]]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}


//- (void) dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (void) keyboardWillShow:(NSNotification *) notification
//{
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    UIEdgeInsets contentInsets;
//    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
//        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
//    }
//    else {
//        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
//    }
//    
////    self.table.contentInset = contentInsets;
////    self.table.scrollIndicatorInsets = contentInsets;
//    
//    NSIndexPath *selectedindexPath = [self.table indexPathForSelectedRow];
//    [self.table scrollToRowAtIndexPath:selectedindexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//}
//
//- (void) keyboardWillHide:(NSNotification *)notification
//{
//    self.table.contentInset = UIEdgeInsetsZero;
//    self.table.scrollIndicatorInsets = UIEdgeInsetsZero;
//}

- (IBAction)btnHelpAction:(id)sender {
    
//    AppDelegate *appDelegate =kAppDelegate;
//    [self.navigationController pushViewController:appDelegate.helpVC animated:YES];
    
    HelpVC *vc = [[HelpVC alloc] initWithNibName:NSStringFromClass([HelpVC class]) bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];

  
}
@end
