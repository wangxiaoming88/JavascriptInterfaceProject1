//
//  RatingViewController.m
//  GoFetchCoder
//
//  Created by Sandro Albert on 3/22/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "RatingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+GFCAdditions.h"
#import "RatingBar.h"
#import "UIFont+GFCAdditions.h"
#import "UIColor+GFCAdditions.h"

@interface RatingViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;

@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBestMatch;
@property (weak, nonatomic) IBOutlet UITextView *txtAnswer;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *lblText;


@end

@implementation RatingViewController

#define kOFFSET_FOR_KEYBOARD 200.0

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _lblQuestion.textColor = [UIColor editColor];
    _lblQuestion.font = [UIFont inputTextFieldFont];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardDidChangeFrameNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self setUpView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)keyboardFrameDidChange:(NSNotification*)notification{
    NSDictionary* info = [notification userInfo];
    
    CGRect kKeyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.footerView setFrame:CGRectMake(0, kKeyBoardFrame.origin.y-self.footerView.frame.size.height, 320, _footerView.frame.size.height)];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.length==0) {
        if ([text isEqualToString:@"\n\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
 
    }
    return YES;
}


-(void) setUpView{
    
    _lblText.font = [UIFont inputTextFieldFont];
    [_lblText setTextColor:[UIColor defaultColor]];
     _lblQuestion.text = _searchQuestion;
    
    _lblBestMatch.textColor = [UIColor defaultColor];
    _lblBestMatch.font =[UIFont smallTextFieldFont];
    
    _lblTitle.text = _sectionSequenceTitle;
    _lblTitle.textColor = [UIColor editColor];
    _lblTitle.font = [UIFont inputTextFieldFont];
    
    _topView.layer.borderColor = [UIColor defaultColor].CGColor;
    _topView.layer.borderWidth = 2.0;
    
    _txtComment.layer.borderColor = [UIColor editLineColor].CGColor;
    _txtComment.layer.borderWidth = 1.0;
    
    _txtAnswer.text = _sectionAnswer;
    _txtAnswer.textColor = [UIColor editColor];
    _txtAnswer.font = [UIFont inputTextFieldFont];
    
     [self.btnSend setBackgroundColor:[UIColor defaultColor]];
    
    RatingBar *bar = [[RatingBar alloc] initWithFrame:CGRectMake((self.ratingView.frame.size.width-311 + 311/7)/2, 15, 311, 30)];
    [self.ratingView addSubview:bar];
    
   	

}



//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    [self animateTextView: YES];
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    [self animateTextView:NO];
//}
//
//- (void) animateTextView:(BOOL) up
//{
//    const int movementDistance = kOFFSET_FOR_KEYBOARD; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    int movement= movement = (up ? -movementDistance : movementDistance);
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    
////    CGRect frame = self.footerView.frame;
////    frame.origin.y += movement;
//////    frame.size.height -= movement ;
////    
////    [self.footerView setFrame:frame];
////    
////    CGRect newFrame = self.footerView.frame;
//    
//    [self.footerView setFrame:CGRectOffset(self.footerView.frame, 0, movement)];
//    [UIView commitAnimations];
//
//}


@end
