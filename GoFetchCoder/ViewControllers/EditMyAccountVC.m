//
//  EditMyAccountVC.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/2/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "EditMyAccountVC.h"
#import "UIColor+GFCAdditions.h"
#import "Constants.h"
#import "NSString+GFCAdditions.h"
#import "EncryptionManager.h"
#import "AppDelegate.h"



@interface EditMyAccountVC ()<UITextFieldDelegate>{
    UITapGestureRecognizer *tap;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintTableview;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellFirstName;
@property (weak, nonatomic  ) IBOutlet UITextField         *txtFirstName;


@property (strong, nonatomic) IBOutlet UITableViewCell *cellLastName;
@property (weak, nonatomic  ) IBOutlet UITextField         *txtLastName;


@property (strong, nonatomic) IBOutlet UITableViewCell *cellEmail;
@property (weak, nonatomic  ) IBOutlet UITextField         *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelEmailError;


@property (strong, nonatomic) IBOutlet UITableViewCell *cellPassword;
@property (weak, nonatomic  ) IBOutlet UITextField         *txtPassword;



@property (strong, nonatomic) IBOutlet UITableViewCell *cellUsingAs;
@property (strong, nonatomic) IBOutlet UIButton *btnDropdown;


@property (nonatomic,strong)NSMutableArray *arrayCells;


//Team Name & Selection
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTeam;
@property (weak, nonatomic) IBOutlet UITextField *txtTeamName;

@property (weak, nonatomic) IBOutlet UIButton *btnOrganisation;
@property (weak, nonatomic) IBOutlet UIButton *btnIndividual;
@property (weak, nonatomic) IBOutlet UIButton *btnteam;

@property(nonatomic,assign)EnrollmentType enrollmentType;


@property (strong, nonatomic) IBOutlet UITableViewCell *cellTeamSelection;
@end

@implementation EditMyAccountVC

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        _user = [[User alloc] init];
        _user.firstName      = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_FirstName];
        _user.lastName       = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_LastName];
        _user.email          = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_Email];
        _user.identifier     = [[NSUserDefaults standardUserDefaults] integerForKey:kUser_Identifier];
        _user.status         = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_Status];
        _user.enrollmentType = [[NSUserDefaults standardUserDefaults] integerForKey:kUser_EnrollmentType];
        
        
    }
    
    return self;
}


- (IBAction)btnDropdownAction:(id)sender {
    if (!self.txtTeamName.userInteractionEnabled) {
        [self.view endEditing:YES];
        [self showHideTeamSelectionSegmentCell];
    }
}
-(void)showHideTeamSelectionSegmentCell {
    if ([_arrayCells containsObject:_cellTeamSelection]) {
        //hide
        [_table beginUpdates];
        
        NSInteger index = [_arrayCells indexOfObject:_cellTeam];
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:index + 1 inSection:0]];
        
        [_arrayCells removeObject:_cellTeamSelection];
        
        [_table deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        
        [_table endUpdates];
    } else {
        //show
        NSInteger index = [_arrayCells indexOfObject:_cellTeam];
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:index +1 inSection:0]];
        [_table beginUpdates];
        
        [_arrayCells insertObject:_cellTeamSelection atIndex:index +1 ];
        
        [_table insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        
        [_table endUpdates];
    }
    [self calculateTableHeight];
    
}

- (IBAction)showHidePassword:(id)sender {
    _txtPassword.secureTextEntry = !_txtPassword.secureTextEntry;
}



- (IBAction)enrollmentAction:(UIButton *)btn {
    
    self.txtTeamName.text = @"";
    if (btn.tag == 0 || !btn) {
        // individual
        self.enrollmentType = Individual;
        self.txtTeamName.text = @"Individual";
        self.txtTeamName.userInteractionEnabled = NO;
        
        
        _btnIndividual.backgroundColor = [UIColor colorFromHex:kColorGreen];
        [_btnIndividual setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
        
        _btnteam.backgroundColor = [UIColor whiteColor];
        [_btnteam setTitleColor:[UIColor colorFromHex:kColorGreen]
                       forState:UIControlStateNormal];
        
        _btnOrganisation.backgroundColor = [UIColor whiteColor];
        [_btnOrganisation setTitleColor:[UIColor colorFromHex:kColorGreen]
                               forState:UIControlStateNormal];
    }
    else if(btn.tag == 1) {
        // team
        self.enrollmentType = Team;
        
        self.txtTeamName.placeholder = @"Please enter your Team name";
        self.txtTeamName.userInteractionEnabled = YES;
        
        _btnteam.backgroundColor = [UIColor colorFromHex:kColorGreen];
        [_btnteam setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
        
        _btnIndividual.backgroundColor = [UIColor whiteColor];
        [_btnIndividual setTitleColor:[UIColor colorFromHex:kColorGreen]
                             forState:UIControlStateNormal];
        
        _btnOrganisation.backgroundColor = [UIColor whiteColor];
        [_btnOrganisation setTitleColor:[UIColor colorFromHex:kColorGreen]
                               forState:UIControlStateNormal];
    }
    else {
        //organisation
        self.enrollmentType = Organisation;
        self.txtTeamName.placeholder = @"Please enter your Organization name";
        self.txtTeamName.userInteractionEnabled = YES;
        
        _btnOrganisation.backgroundColor = [UIColor colorFromHex:kColorGreen];
        [_btnOrganisation setTitleColor:[UIColor whiteColor]
                               forState:UIControlStateNormal];
        
        _btnIndividual.backgroundColor = [UIColor whiteColor];
        [_btnIndividual setTitleColor:[UIColor colorFromHex:kColorGreen]
                             forState:UIControlStateNormal];
        
        _btnteam.backgroundColor = [UIColor whiteColor];
        [_btnteam setTitleColor:[UIColor colorFromHex:kColorGreen]
                       forState:UIControlStateNormal];
    }
}


-(void)showEmailError {
    _labelEmailError.text = @"Email is incorrect";
    _labelEmailError.textColor = [UIColor colorFromHex:@"#E73C3C"];
    
}

-(void)hideEmailError {
    _labelEmailError.text = @"Email";
    _labelEmailError.textColor = [UIColor colorFromHex:@"#727D85"];
    
}




#pragma mark - UItextfield Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_txtEmail]) {
        if ([textField.text isValidEmail]) {
            [self hideEmailError];
        }else{
            [self showEmailError];
        }
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:_txtFirstName]) {
        [_txtLastName becomeFirstResponder];
        
    } else if ([textField isEqual:_txtLastName]) {
        [_txtEmail becomeFirstResponder];
        
    } else if ([textField isEqual:_txtEmail]) {
        if ([textField.text isValidEmail]) {
            [self hideEmailError];
        }else{
            [self showEmailError];
        }
        [_txtPassword becomeFirstResponder];
        
    } else if ([textField isEqual:_txtPassword]) {
        [textField resignFirstResponder];
    }
    else if ([textField isEqual:self.txtTeamName]) {
        [textField resignFirstResponder];
    }
    return YES;
}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch= [touches anyObject];
//    if ([touch view] == self.view)
//        [self.view endEditing:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _table.layer.borderWidth = 1.0;
    _table.layer.borderColor = [UIColor colorFromHex:@"#E3E3E3"].CGColor;
    _table.layer.cornerRadius=2.0;
    //    _table.layer.borderColor = [UIColor grayColor].CGColor;
    _arrayCells = [NSMutableArray arrayWithObjects:
                   /*_cellSignupTitle,*/
                   _cellFirstName,
                   _cellLastName,
                   _cellEmail,
                   _cellPassword,
                   _cellTeam,
                   _cellTeamSelection,
                   nil];
    
    [self calculateTableHeight];
    [self setup];
    
    
    
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(tapDetected)];
    [_baseView addGestureRecognizer:tap];
    
}

-(void)tapDetected {
    [self.view endEditing:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self enrollmentAction:nil];
    
}


- (void)setup {
    
    [super hidePopupMenu];
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"i_bookmark_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(editTapped:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SAVE" style:UIBarButtonItemStylePlain target:self action:@selector(saveTapped:)];
    _txtFirstName.text = _user.firstName;
    _txtLastName.text  = _user.lastName;
    _txtEmail.text     = _user.email;
    
    AppDelegate *appDelegate = kAppDelegate;
    NSData *pass             = [appDelegate.keychain objectForKey:(__bridge id)(kSecValueData)];
    NSString *passwordString = [[EncryptionManager sharedInstance] getDecryptedString:pass];
    
    _txtPassword.text = passwordString;
    
    switch (_user.enrollmentType) {
        case Individual     : _txtTeamName.text = @"Individual";  break;
        case Team           : _txtTeamName.text = @"Team";  break;
        case Organisation   : _txtTeamName.text = @"Organisation";  break;
        default:    break;
    }

    
}

-(void)saveTapped:(id)sender
{
    NSLog(@"SAVE Tapped");
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)calculateTableHeight {
    CGFloat height = 0;
    for (UITableViewCell *cell in _arrayCells) {
        height += cell.frame.size.height;
    }
    
    _heightConstraintTableview.constant = height;
    [self.view layoutIfNeeded];
    
    //    _table.frame = CGRectMake(_table.frame.origin.x,
    //                              _table.frame.origin.y,
    //                              _table.frame.size.width,
    //                              height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Tableview delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = _arrayCells[indexPath.row];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayCells.count;
}

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
 Answer *a = _datasource[indexPath.row];
 
 if (a.hyperlink && a.sectionName && a.sectionNumber) {
 ChapterViewController *chapterVC = [[ChapterViewController alloc] initWithNibName:NSStringFromClass([ChapterViewController class]) bundle:nil];
 
 chapterVC.hyperlink            = a.hyperlink;
 chapterVC.sectionSequenceId    = a.sectionNumber;
 chapterVC.sectionSequenceTitle = a.sectionName;
 
 
 [self.navigationController pushViewController:chapterVC animated:YES];
 
 }
 else {
 //        [self showErrorAlertWithTitle:@"Section Details incomplete" andDesription:@"Cant show chapter info"];
 [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];
 
 
 }
 }*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_arrayCells objectAtIndex:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
