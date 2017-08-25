//
//  EncryptionManager.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/4/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionManager : NSObject

+ (id)sharedInstance;

-(NSData *)getEncryptedData:(NSString *)value;
-(NSString *)getDecryptedString:(NSData *)data;



@end
