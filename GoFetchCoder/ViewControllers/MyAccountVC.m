//
//  MyAccountVC.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/1/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//
#import "MyAccountVC.h"
#import "EditMyAccountVC.h"

#import "UIColor+GFCAdditions.h"
#import "LogoutOperation.h"
#import "AppDelegate.h"

@interface MyAccountVC ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintTableview;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellFirstName;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstName;


@property (strong, nonatomic) IBOutlet UITableViewCell *cellLastName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastName;


@property (strong, nonatomic) IBOutlet UITableViewCell *cellEmail;

@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@property (nonatomic,strong)NSMutableArray *arrayCells;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellPassword;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellUsingAs;
@property (weak, nonatomic) IBOutlet UILabel *lblUsingAs;

@end


@implementation MyAccountVC


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken]) {
//        _user = [[User alloc] init];
//        _user.firstName      = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_FirstName];
//        _user.lastName       = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_LastName];
//        _user.email          = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_Email];
//        _user.identifier     = [[NSUserDefaults standardUserDefaults] integerForKey:kUser_Identifier];
//        _user.status         = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_Status];
//        _user.enrollmentType = [[NSUserDefaults standardUserDefaults] integerForKey:kUser_EnrollmentType];
//        }

    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _table.layer.borderWidth  = 1.0;
    _table.layer.borderColor  = [UIColor colorFromHex:@"#E3E3E3"].CGColor;
    _table.layer.cornerRadius = 2.0;

    
    _arrayCells = [NSMutableArray arrayWithObjects:
                   _cellFirstName,
                   _cellLastName,
                   _cellEmail,
                   _cellPassword,
                   _cellUsingAs,
                   nil];
    
    [self calculateTableHeight];
    [self setup];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken]) {
        _user = [[User alloc] init];
        _user.firstName      = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_FirstName];
        _user.lastName       = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_LastName];
        _user.email          = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_Email];
        _user.identifier     = [[NSUserDefaults standardUserDefaults] integerForKey:kUser_Identifier];
        _user.status         = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_Status];
        _user.enrollmentType = [[NSUserDefaults standardUserDefaults] integerForKey:kUser_EnrollmentType];
        
        
        
        
        // Logged In member data
        _lblFirstName.text = _user.firstName;
        _lblLastName.text  = _user.lastName;
        _lblEmail.text     = _user.email;
        
        switch (_user.enrollmentType) {
            case Individual     : _lblUsingAs.text = @"Individual";  break;
            case Team           : _lblUsingAs.text = @"Team";  break;
            case Organisation   : _lblUsingAs.text = @"Organisation";  break;
            default:    break;
        }
    }
    
}



-(void)calculateTableHeight {
    CGFloat height = 0;
    for (UITableViewCell *cell in _arrayCells) {
        height += cell.frame.size.height;
    }
    
    _heightConstraintTableview.constant = height;
    [self.view layoutIfNeeded];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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


- (void)setup {
    
    [super hidePopupMenu];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"EDIT" style:UIBarButtonItemStylePlain target:self action:@selector(editTapped:)];
    
    
    
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
    
    [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];
    
}

-(void)showLoginScreen
{
    AppDelegate *appDelegate = kAppDelegate;
    [self.navigationController popToViewController:appDelegate.loginVC animated:YES];
    
}

- (IBAction)btnLogoutAction:(id)sender {
    
    [self.view endEditing:YES];
    
    [self showLoadingIndicator];
    
    AppDelegate *appDelegate = kAppDelegate;
    
    LogoutOperation *operation= [[LogoutOperation alloc] init];
    
    operation.onSuccess = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingIndicator];
            [self showLoginScreen];
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

-(void)editTapped:(id)sender
{
    NSLog(@"Edit Tapped");
    
    EditMyAccountVC *vc = [[EditMyAccountVC alloc] initWithNibName:NSStringFromClass([EditMyAccountVC class]) bundle:nil];
    
    
    /*User *user = [[User alloc] init];
    
    user.firstName      = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_FirstName];
    user.lastName       = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_LastName];
    user.email          = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_Email];
    user.identifier     = [[NSUserDefaults standardUserDefaults] integerForKey:kUser_Identifier];
    user.status         = [[NSUserDefaults standardUserDefaults] objectForKey:kUser_Status];
    user.enrollmentType = [[NSUserDefaults standardUserDefaults] integerForKey:kUser_EnrollmentType];
    
    vc.user         = user;*/
    

    
    
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
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
