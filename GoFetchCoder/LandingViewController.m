//
//  LandingViewController.m
//  GoFetchCoder
//
//  Created by Guest on 1/18/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "DataManager.h"
#import "LandingViewController.h"
#import "SectionsViewController.h"
#import "UITextView+GFCAdditions.h"
#import "GetAnswersOperation.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "MyAccountVC.h"
#import "UIColor+GFCAdditions.h"
#import "UIFont+GFCAdditions.h"
#import "LocationViewController.h"
#import <Mixpanel/Mixpanel.h>


#import "NSUserDefaults+Extension.h"

@interface LandingViewController (){
    Mixpanel *mixpanel;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@end

@implementation LandingViewController


- (IBAction)searchAction:(id)sender{
    

    if (!_txtView.text.length) {
        return;
    }

    [self shouldShowLoadingIndicator:YES];
    [_txtView resignFirstResponder];

    
    AppDelegate *appDelegate = kAppDelegate;

    GetAnswersOperation *operation = [[GetAnswersOperation alloc] init];
    operation.question = _txtView.text;
    operation.onCompetion = ^(NSArray *responseArray, BOOL isSuccess) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadSearchScreen:responseArray];
        });
    };

    [appDelegate.queue addOperation:operation];



//    [self performSelectorInBackground:@selector(runInBackground:) withObject:_txtView.text];


}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:kUser_Email];
    NSString *firstName = [[NSUserDefaults standardUserDefaults] stringForKey:kUser_FirstName];
    NSString *lastName = [[NSUserDefaults standardUserDefaults] stringForKey:kUser_LastName];
    NSString *enrollmentType = [[NSUserDefaults standardUserDefaults] stringForKey:kUser_EnrollmentType];
    NSString *status = [[NSUserDefaults standardUserDefaults] stringForKey:kUser_Status];
    NSString *identifier = [[NSUserDefaults standardUserDefaults] stringForKey:kUser_Identifier];
    
    mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:identifier];
    [mixpanel.people set:@{@"FirstName"      : firstName ,
                           @"LastName"       : lastName,
                           @"Email"          : username,
                           @"Identifier"     : identifier,
                           @"Status"         : status,
                           @"EnrollmentType" : enrollmentType
                           }
     ];
    
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shouldShowLoadingIndicator:(BOOL)shouldShow {
    if (shouldShow) {
        self.loadingView.hidden = NO;
        [self.loadingView startAnimating];
        self.view.userInteractionEnabled = NO;
    }
    else {
        self.loadingView.hidden = YES;
        [self.loadingView stopAnimating];
        self.view.userInteractionEnabled = YES;
    }
}


-(void)runInBackground:(NSString *)string {

    NSDictionary *dict = [[DataManager sharedManager] getAnswersForQuestion:_txtView.text];
    NSArray *array = [[DataManager sharedManager] parseAnswersResponse:dict];
   
    
    [self performSelectorOnMainThread:@selector(loadSearchScreen:) withObject:array waitUntilDone:NO];
}

-(void)loadSearchScreen:(NSArray *)array {

    AppDelegate *appdelegate = kAppDelegate;
    
//    SectionsViewController *vc = [[SectionsViewController alloc] initWithNibName:NSStringFromClass([SectionsViewController class]) bundle:nil];
    SectionsViewController *vc = appdelegate.sectionsVC;
    vc.answersArray = array;
    vc.searchQuestion = _txtView.text;
    
    [self shouldShowLoadingIndicator:NO];
    
    [self.navigationController pushViewController:vc animated:YES];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kCurrentSelectedMenuIndex];

    

}

- (IBAction)btnClearAction:(id)sender {
    _txtView.text = @"";
    
}



- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setViewLocationButton];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.titleView.hidden=YES;
    self.loadingView.hidden = YES;
}

- (void)setViewLocationButton{
    
    [self.btnLocation setTitle:@"South San Francisco" forState:UIControlStateNormal];
    self.btnLocation.titleLabel.font = [UIFont smallTextFieldFont];
    [self.btnLocation.titleLabel setTextAlignment:UITextAlignmentCenter];
    
    
    [self.btnLocation setImage: [UIImage imageNamed:@"i_shevron"] forState:UIControlStateNormal];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self dismissKeyboard];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _btnClear.hidden = YES;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    _btnClear.hidden = NO;
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [textView sizeFontToFit:textView.text minSize:10 maxSize:18];
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self performSelector:@selector(searchAction:) withObject:nil afterDelay:0.5];

        return NO;
    }
    
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnLocationAction:(id)sender {
    LocationViewController *locationVC = [[LocationViewController alloc] init];
    [self.navigationController pushViewController:locationVC animated:YES];
}




@end
