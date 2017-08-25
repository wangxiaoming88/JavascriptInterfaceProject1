		//
//  ChapterViewController.m
//  GoFetchCoder
//
//  Created by Guest on 1/20/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "ChapterViewController.h"
#import "Constants.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "UIFont+GFCAdditions.h"
#import "UIColor+GFCAdditions.h"
#import "UIWebView+GFCAddition.h"
#import "RatingViewController.h"

#import "AddHighLightOperation.h"
#import "AddBookmarkOperation.h"
#import "RemoveBookmarkOperation.h"
#import "GetHighlightsOperation.h"
#import "Base64.h"
#import "Highlight.h"

#import <Mixpanel/Mixpanel.h>



@interface ChapterViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate> {
    BOOL isAnimationOn;
    Mixpanel *mixpanel;
    
}
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic, strong) UIMenuItem *customMenuItem1;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property(nonatomic, strong) UIMenuItem *customMenuItem2;
@property (weak, nonatomic) IBOutlet UIView *topView;
- (IBAction)btnSearchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UITextView *lblQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnBookmark;
@property (weak, nonatomic) IBOutlet UIButton *btnClarify;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
- (IBAction)btnBookmarkAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnClarifyAction;
- (IBAction)btnShareAction:(id)sender;
- (IBAction)btnRatingAction:(id)sender;
@property (nonatomic, strong)NSArray *datasource;


@end

@implementation ChapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setup];
    _webview.scrollView.delegate = self;
    
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    _tap.numberOfTapsRequired = 1;
    _tap.delegate = self;
    [_webview addGestureRecognizer:_tap];

    //topView
    _topView.hidden = NO;
    
   [self mixpanelTrack];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)tapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"touched");
    //Show top bottom view :
    [self showHideTopView];
    
    // Get the specific point that was touched
//    CGPoint point = [sender locationInView:self.view];
    
}

-(void)showTopView {
    
}
-(void)showHideTopView {
    if (!_topView.hidden) {
        //hide the top view with animation.
        [UIView transitionWithView:_topView
                          duration:1.0
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:NULL
                        completion:^(BOOL finished) {
                            _topView.hidden = YES;
                        }];
    }
    else {

        //hide the top view with animation.
        [UIView transitionWithView:_topView
                          duration:1.0
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:NULL
                        completion:^(BOOL finished) {
                            _topView.hidden = NO;

                            
                        }];
    }
}
-(void)showBottomView {
    
}
-(void)hideBottomView {
    
}

- (void)setup {
    
    [super hidePopupMenu];
    
    
    
    _lblQuestion.textColor = [UIColor editColor];
    _lblQuestion.font = [UIFont inputTextFieldFont];
    
    _lblText.font = [UIFont inputTextFieldFont];
    
//    UIImage *bookmarkedImage = _isBookmarked ? [UIImage imageNamed:@"i_bookmark_menu"]:[UIImage imageNamed:@"i_browse"];
//
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:bookmarkedImage style:UIBarButtonItemStylePlain target:self action:@selector(bookmarkTapped:)];

    //
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:46/255.0 green:204/255.0 blue:121/255.0 alpha:1.0];
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:46/255.0 green:204/255.0 blue:121/255.0 alpha:1.0];
//    self.navigationItem.title = @"Chapter";
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:46/255.0 green:204/255.0 blue:121/255.0 alpha:1.0];
//    self.navigationController.navigationBarHidden = NO;
    
    
    //[self updateBookmarkImage];
    
}

- (void)setFooterButton:(UIButton *) btn NSString: text{
    
    if ([text isEqualToString:@"Bookmark"]) {
        [btn setImage:[UIImage imageNamed:@"i_bookmark"] forState:UIControlStateNormal];
    } else if ([text isEqualToString:@"Clarify"]){
        [btn setImage:[UIImage imageNamed:@"i_clarify"] forState:UIControlStateNormal];
    } else{
        [btn setImage:[UIImage imageNamed:@"i_share"] forState:UIControlStateNormal];
    }
    [btn setTintColor:[UIColor defaultColor]];
    
    CGFloat spacing = 6.0;
    
   
//    [btn.titleLabel setText:text];
     btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];

    [btn.titleLabel setTextAlignment:UITextAlignmentCenter];

//    CGSize imageSize = btn.imageView.frame.size;
    CGSize imageSize = [btn.imageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing),0.0);
//    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize titleSize = [btn.titleLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   // self.navigationItem.title = @"Chapter";
   // self.navigationController.navigationBarHidden = NO;
    
//    [self updateBookmarkImage];
    
    UIMenuItem *highLight = [[UIMenuItem alloc] initWithTitle:@"HIGHLIGHT" action:@selector(highlight)];
    UIMenuItem *bookmark = [[UIMenuItem alloc] initWithTitle:@"BOOKMARK" action:@selector(bookmark)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:highLight,bookmark, nil]];
    
    //setting the buttons on footerView.
    
    [self setFooterButton:_btnBookmark NSString:@"Bookmark"];
    [self setFooterButton:_btnClarify NSString:@"Clarify"];
    [self setFooterButton:_btnShare NSString:@"Share"];
    
    self.lblQuestion.text = _searchQuestion;
    

    NSString *link = [kBaseUrl stringByAppendingPathComponent:_hyperlink];
    NSLog(@"%@",link);
    
    //TODO: workarounf for First Drop
    link = [link stringByReplacingOccurrencesOfString:@"/chapter/" withString:@"/cbc/"];

    
    
    AppDelegate *appDelegate = kAppDelegate;
  
    GetHighlightsOperation *highlightsOperation = [[GetHighlightsOperation alloc] init];
    highlightsOperation.chapterNo = _chapterNo;
    
    highlightsOperation.onSuccess = ^(NSArray *highlights) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (highlights.count) {
                
                _datasource = [[NSArray alloc] initWithArray:highlights];
                [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
               
            }
            else {
               
            }
        });
    };
    
    highlightsOperation.onFailure = ^(NSDictionary *failureDict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];
        });
        
    };
    
    [appDelegate.queue addOperation:highlightsOperation];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[UIMenuController sharedMenuController] setMenuItems:nil];
}


-(void)updateBookmarkImage {
    
//    [self.navigationItem.rightBarButtonItem setImage:nil];
    
    NSString *bookmarkImage = _isBookmarked ? @"i_bookmarked" : @"i_bookmark";
    NSString *bookmark = _isBookmarked ? @"Bookmarked" : @"Bookmark";

    
    UIImage *bookmarkedImage = [[UIImage imageNamed:bookmarkImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.btnBookmark setImage:bookmarkedImage forState:UIControlStateNormal];
    [self.btnBookmark setTitle:bookmark forState:UIControlStateNormal];
    
//    [self.navigationItem.rightBarButtonItem setImage:bookmarkedImage];
}


-(void)bookmarkTapped:(id) sender {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}
#pragma UIWebview Delegates -


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    webView.alpha = 0.0;
    
    [self showLoadingIndicator];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingIndicator];
        webView.alpha = 1.0;
    
    [_webview setHighlight:_datasource];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [self hideLoadingIndicator];
}

- (void)highlight{
    [_webview highlight:_chapterNo];
}

- (void)bookmark{
    [_webview bookmark:_sectionSequenceId];
}

- (IBAction)btnSearchAction:(id)sender {
}

- (IBAction)btnShareAction:(id)sender {
}

- (IBAction)btnRatingAction:(id)sender {
    RatingViewController *RatingVC = [[RatingViewController alloc] initWithNibName:NSStringFromClass([RatingViewController class]) bundle:nil];
    RatingVC.sectionSequenceTitle = _sectionSequenceTitle;
    RatingVC.searchQuestion = _lblQuestion.text;
    RatingVC.sectionAnswer = _sectionAnswer;
    [self.navigationController pushViewController:RatingVC animated:YES];
}

- (void) mixpanelTrack{
    
    
    mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Search Question" properties:@{
                                                    @"chapter": _chapterNo,
                                                    @"sectionId": _sectionSequenceId,
                                                    @"hyperlink": _hyperlink
                                                    }];
}

@end
