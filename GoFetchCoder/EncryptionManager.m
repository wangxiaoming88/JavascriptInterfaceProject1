//
//  EncryptionManager.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/4/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "EncryptionManager.h"

#import "Constants.h"

#import "RNCryptor.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"


@implementation EncryptionManager

static EncryptionManager *sharedInst = nil;


// Get the shared instance and create it if necessary.
+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}


- (id)init
{
    if ((self = [super init])) {
    }
    
    return self;
}





-(NSData *)getEncryptedData:(NSString *)value
{
    static const RNCryptorKeyDerivationSettings mySettings = {
        .keySize = 32,
        .saltSize = 8,
        .PBKDFAlgorithm = kCCPBKDF2,
        .PRF = kCCPRFHmacAlgSHA1,
        .rounds = 1000
    };
    
    NSError *error = nil;
    NSData *encryptionSalt = [kSalt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptionKey = [RNEncryptor keyForPassword:kGFCEncryptionKey salt:encryptionSalt settings:mySettings];
    NSData *hMACSalt = [kHash dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hmacKey = [RNEncryptor keyForPassword:kGFCEncryptionKey salt:hMACSalt settings:mySettings];
    
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedValue = [RNEncryptor encryptData:data
                                         withSettings:kRNCryptorAES256Settings encryptionKey:encryptionKey HMACKey:hmacKey error:&error];
    if (error != nil) {
        NSLog(@"Encryption failed");
    }
    
    return encryptedValue;
}



-(NSString *)getDecryptedString:(NSData *)data
{
    
    static const RNCryptorKeyDerivationSettings decryptSettings = {
        .keySize = 32,
        .saltSize = 8,
        .PBKDFAlgorithm = kCCPBKDF2,
        .PRF = kCCPRFHmacAlgSHA1,
        .rounds = 1000
    };
    
    NSError *error = nil;
    
    NSData *encryptionSalt = [kSalt dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSData *encryptionKey = [RNEncryptor keyForPassword:kGFCEncryptionKey salt:encryptionSalt settings:decryptSettings];
    
    NSData *hMACSalt = [kHash dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hmacKey = [RNEncryptor keyForPassword:kGFCEncryptionKey salt:hMACSalt settings:decryptSettings];
    
    NSData *result = [RNDecryptor decryptData:data withSettings:kRNCryptorAES256Settings encryptionKey:encryptionKey HMACKey:hmacKey error:&error];
    if (error != nil) {
        NSLog(@"Decryption Failed");
    }
    
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    
}



@end
