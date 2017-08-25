//
//  Constants.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/22/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//#define MIXPANEL_TOKEN       @"1d9baf8653442d7d75124aa6849a0c3a" // my mixpanel token

#define MIXPANEL_TOKEN       @"5be6522b0d6cc961bb1f599504cc7d97"   //jean mixpanel token
//#define kUser           @"LoggedInUser"
#define kUser_FirstName      @"firstName"
#define kUser_LastName       @"lastName"
#define kUser_Email          @"email"
#define kUser_EnrollmentType @"enrollmentType"
#define kUser_Status         @"status"
#define kUser_Identifier     @"identifier"


#define kGoFetchCode @"GoFetchCode"
#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate];

/******************
  ERROR CONSTANTS
 *******************/
#define kERROR_TECHNICAL @"Sorry, we have a technical problem at the moment. Please try again later."

#define kERROR_TECHNICAL_TITLE @"Sorry"
#define kERROR_TECHNICAL_DESCRIPTION @"We have a technical problem at the moment. Please try again later."


/******************
 ENCRYPTION
 *******************/
#define kSalt @"G0F3tchc0d3"
#define kHash @"H@$h123"
#define kGFCEncryptionKey @"GFC3ncryption"
#define kGFCKeychainIdentifier @"do.gofetchcode.com/ios"


/******************
 OTHER CONSTANTS
 *******************/
#define kScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])
#define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])

#define kKeepMeLoggedIn @"KeepMeLoggedIn"
#define kCurrentSelectedMenuIndex @"CurrentSelectedMenuIndex"

#define kMinimumFontSize 11
#define kMaximumFontSize 18
#define kMaxConfidence   10
#define kMaxScore        10
#define kInvalid        -1

#define kAuthToken                          @"Auth-Token"

//Screen Titles and Nav menu items text
#define kSearch                             @"SEARCH"
#define kRecentQuestions                    @"RECENT SEARCHES"
#define kRecentAnswers                      @"RECENT ANSWERS"
#define kBookmarks                          @"BOOKMARKS"
#define kCBC                                @"BROWSE CBC"
#define kMessages                           @"MESSAGES"
#define kHelp                               @"HELP"
#define KRecentSection                      @"SEARCH RESULTS"
#define kMyAccount                          @"MY ACCOUNT"
#define kEditMyAccount                      @"EDIT MY ACCOUNT"
#define kLocation                           @"LOCATION"




#define kBaseUrl     @"http://do.gofetchcode.com/"

#define kLoginAuthenticateAPI @"api/people/authenticate"
#define kLogoutAPI            @"api/people/secure/logout"

#define kAddHighlightAPI    @"api/secure/highlight/add"
#define kGetHighlightsAPI   @"api/secure/highlight/list?chapter="

#define kAddBookmarkAPI    @"api/secure/bookmark/add"
#define kRemoveBookmarkAPI @"api/secure/bookmark/remove/"
#define kGetBookmarksAPI   @"api/secure/bookmark"


#define kRecentSearchQuestionsAPI @"api/secure/history/question"
#define kRecentSearchAnswersAPI   @"api/secure/history/answer?id="

#define kAskAQuestionAPI  @"api/secure/ask?question="


#define kColorGreen @"#26BF48"




typedef enum
{
    None,
    Individual,
    Team,
    Organisation,
} EnrollmentType;


#endif /* Constants_h */
