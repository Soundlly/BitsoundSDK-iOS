//
//  SoundllyReceiverContentsModel.h
//  SoundllyReceiverLib
//
//  Created by wonje-soundlly on 2017. 1. 4..
//  Copyright © 2017년 wonje-soundlly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BitsoundContentsModel : NSObject

@property (nonatomic) double timestamp;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *soundllyID;
@property (nonatomic, strong) NSMutableArray *attributes;

- (NSString *)getStrValue:(NSString *)key;
- (NSString *)toString;
@end
