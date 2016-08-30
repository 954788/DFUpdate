//
//  DFCheckUpdate.h
//  YangChengPai
//
//  Created by 粱展焯 on 16/8/29.
//  Copyright © 2016年 gzkitmb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DFUpdate : NSObject

+ (instancetype)shareManager;

-(void)checkUpdateWithShowNewContent:(BOOL)isShow noMore:(BOOL)isNoMore;

@end
