//
//  RecentSectionViewController.m
//  GoFetchCoder
//
//  Created by Sandro Albert on 3/24/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "RecentSectionViewController.h"
#import "UIFont+GFCAdditions.h"
#import "UIColor+GFCAdditions.h"
#import "Constants.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "AddBookmarkOperation.h"
#import "RemoveBookmarkOperation.h"
#import "UIWebView+GFCAddition.h"
#import "GetHighlightsOperation.h"
#import <Mixpanel/Mixpanel.h>

@interface RecentSectionViewController () <UIWebViewDelegate>{
    
    Mixpanel *mixpanel;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnBookmark;
@property (weak, nonatomic) IBOutlet UIButton *btnClarify;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actView;
- (IBAction)btnBookmarkAction:(id)sender;
- (IBAction)btnClarifyAction:(id)sender;
- (IBAction)btnShareAction:(id)sender;

@end

@implementation RecentSectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//     _webView.scrollView.delegate = self;
    
    [self mixpanelTrack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    
    _lblQuestion.textColor = [UIColor editColor];
    _lblQuestion.font = [UIFont inputTextFieldFont];
     [self hideLoadingIndicator];
    
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
    
    
    [btn.titleLabel setText:text];
    btn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    btn.titleLabel.textColor = [UIColor editColor];
    [btn.titleLabel setTextAlignment:UITextAlignmentCenter];
    
    CGSize imageSize = btn.imageView.frame.size;
    //    CGSize imageSize = [btn.imageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing),0.0);
    CGSize titleSize = btn.titleLabel.frame.size;
    //    CGSize titleSize = [btn.titleLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setup];
    
    UIMenuItem *highLight = [[UIMenuItem alloc] initWithTitle:@"HIGHLIGHT" action:@selector(highlight)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:highLight, nil]];
    
    [self setFooterButton:_btnBookmark NSString:@"Bookmark"];
    [self setFooterButton:_btnClarify NSString:@"Clarify"];
    [self setFooterButton:_btnShare NSString:@"Share"];
    
    self.lblQuestion.text = _searchQuestion;
    
    
    NSString *link = [kBaseUrl stringByAppendingPathComponent:_hyperlink];
    NSLog(@"%@",link);
    
    //TODO: workarounf for First Drop
    link = [link stringByReplacingOccurrencesOfString:@"/chapter/" withString:@"/cbc/"];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
    
    AppDelegate *appDelegate = kAppDelegate;
    
    GetHighlightsOperation *highlightsOperation = [[GetHighlightsOperation alloc] init];
    highlightsOperation.chapterNo = _chapterNo;
    
    highlightsOperation.onSuccess = ^(NSArray *highlights) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (highlights.count) {
                
                _datasource = highlights;
                
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


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    webView.alpha = 0.0;
    [self showLoadingIndicator];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingIndicator];
    
    [_webView setHighlight:_datasource];
    webView.alpha = 1.0;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [self hideLoadingIndicator];
}

- (void)highlight{
    [_webView highlight:_chapterNo];
}


-(void)updateBookmarkImage {
    
    NSString *bookmarkImage = _isBookmarked ? @"i_bookmarked" : @"i_bookmark";
    NSString *bookmark = _isBookmarked ? @"Bookmarked" : @"Bookmark";
    
    
    UIImage *bookmarkedImage = [[UIImage imageNamed:bookmarkImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.btnBookmark setImage:bookmarkedImage forState:UIControlStateNormal];
    [self.btnBookmark setTitle:bookmark forState:UIControlStateNormal];
}

- (IBAction)btnBookmarkAction:(id)sender {
    
        [self showLoadingIndicator];
    
        //bookmark ...
    
        AppDelegate *appDelegate = kAppDelegate;
        BOOL shouldAddBookmark = !_isBookmarked;
    
        if (shouldAddBookmark) {
            AddBookmarkOperation *addBookmark = [[AddBookmarkOperation alloc] init];
            addBookmark.sequenceId            = _sectionSequenceId;
            addBookmark.sectionTitle          = _sectionSequenceTitle;
    
            addBookmark.onCompletion = ^(NSDictionary *jsonResponse,BOOL isSuccess) {
    
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isSuccess) {
                        _isBookmarked = YES;
                        _bookmarkId = [jsonResponse[@"id"] integerValue];
                        [self hideLoadingIndicator];
    
                        //[self showErrorAlertWithTitle:@"" andDesription:@"Bookmark Added successfully"];
                    }
                    else {
                        _isBookmarked = NO;
                        _bookmarkId = kInvalid;
                        // [self showErrorAlertWithTitle:jsonResponse[@"error"] andDesription:jsonResponse[@"message"]];
                        [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];
    
                    }
    
                    [self updateBookmarkImage];
    
                });
            };
            [appDelegate.queue addOperation:addBookmark];
        }
        else {
            RemoveBookmarkOperation *removeBookmarkOperation = [[RemoveBookmarkOperation alloc] init];
            removeBookmarkOperation.bookmarkId         = _bookmarkId;
            removeBookmarkOperation.onCompletion = ^(NSString *responseString, BOOL isSuccess) {
    
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isSuccess) {
                        _isBookmarked = NO;
                        [self hideLoadingIndicator];
    
                        // [self showErrorAlertWithTitle:@"" andDesription:@"Bookmark Removed successfully"];
                    }
                    else {
                        _isBookmarked = YES;
                        //                    [self showErrorAlertWithTitle:@"error" andDesription:@"Error"];
                        [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];
    
                    }
                    [self updateBookmarkImage];
                    
                });
                
            };
            [appDelegate.queue addOperation:removeBookmarkOperation];
        }
}

- (IBAction)btnClarifyAction:(id)sender {
}

- (IBAction)btnShareAction:(id)sender {
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
