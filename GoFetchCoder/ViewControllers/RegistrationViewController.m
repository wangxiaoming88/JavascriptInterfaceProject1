//
//  RegistrationViewController.m
//  GoFetchCoder
//
//  Created by Kuldeep Mishra on 16/01/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "RegistrationViewController.h"
#import "AFNetworking.h"
#import "GCFAPIClient.h"
#import "DropDownButton.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface RegistrationViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *teamOrOrganization;
@property (weak, nonatomic) IBOutlet DropDownButton *teamOrOrganizationPicker;

@end

@implementation RegistrationViewController

NSString *selectionType = @"INDIVIDUAL";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.teamOrOrganizationPicker.pickerItems = @[@"Individual",@"Team",@"Organization"];
}

-(void)viewWillAppear:(BOOL)animated {
}

- (IBAction)SignUpTapped:(id)sender {
    NSLog(@"%@",@"Signup button tapped");
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    [indicator startAnimating];
    
    [[GCFAPIClient instance] postService:@"http://do.gofetchcode.com/api/register"
                              parameters:[self getParams]
                                    type:@"POST"
                                 handler:^(NSURLResponse *urlResponse, id responseObject, NSError *error) {
        [indicator stopAnimating];
        if(error) {
            NSLog(@"%@", error.description);
        }else {
            NSLog(@"%@", responseObject);
        }
    }];
}

#pragma Table view delegate

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7) {
        return 10.0f;
    }
    return 55.0f;
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([[cell reuseIdentifier] isEqualToString:@"teamOrOrganization"]) {
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 0, 0);
    }
//    cell.contentView.userInteractionEnabled = NO;
//    cell.userInteractionEnabled = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", @"inside table view");
}

- (IBAction)loginTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];

}
- (IBAction)helpButtonTapped:(id)sender {
    NSLog(@"%@", @"help button tapped");
}
- (IBAction)dropDownTapped:(id)sender {
        NSLog(@"%@", @"drop down button tapped");
    
}
# pragma convinence methods

-(NSDictionary *)getParams {
    NSMutableDictionary *dictionary = [@{@"firstName":self.firstName.text,@"lastName":self.lastName.text,@"email":self.email.text,@"password":self.password.text,@"repeatPassword":self.password.text,@"type":selectionType} mutableCopy];
    
    if([selectionType isEqual: @"TEAM"]) {
        [dictionary setValue:@{@"name":self.teamOrOrganization.text} forKey:@"team"];
    }
    if([selectionType isEqual: @"ORGANISATION"] ) {
        [dictionary setValue:@{@"name":self.teamOrOrganization.text} forKey:@"organisation"];
    }
    return dictionary;
}

# pragma text delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:self.firstName]) {
        [self.firstName resignFirstResponder];
       return [self.lastName becomeFirstResponder];
    } else if ([textField isEqual:self.lastName]) {
        return[self.email becomeFirstResponder];
    } else if ([textField isEqual:self.email]) {
        return[self.password becomeFirstResponder];
    } else if ([textField isEqual:self.password]) {
        [textField resignFirstResponder];
        [self dropDownTapped:nil];
//       return [self.teamOrOrganization becomeFirstResponder];
    }
    return YES;
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    return YES;
//}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    return YES;
//}

@end
