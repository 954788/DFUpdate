//
//  DFCheckUpdate.m
//  YangChengPai
//
//  Created by 粱展焯 on 16/8/29.
//  Copyright © 2016年 gzkitmb. All rights reserved.
//

#import "DFUpdate.h"
//#import "AFHTTPSessionManager.h"

@interface DFUpdate ()<UIAlertViewDelegate>


@end

@implementation DFUpdate
{
    NSString *_appId;
    BOOL _isShowContent;
    BOOL _isNoMore;
    NSString *_newVersion;
}

+ (instancetype)shareManager
{
    static DFUpdate *manager = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        manager = [[DFUpdate alloc] init];
        
    });
    return manager;
    
}

-(void)checkUpdateWithShowNewContent:(BOOL)isShowContent noMore:(BOOL)isNoMore{
    
    // 是否显示更新内容
    _isShowContent = isShowContent;
    
#warning 根据不同的app去修改Id的值
    _appId = @"1137081115";
    
    // 是否在下个更新版本发布前不再显示
    _isNoMore = isNoMore;
    
    // 检测更新只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken , ^{
    
    // 根据喜好二选一
        BOOL isAFN = NO;
        
        if (isAFN) {
            // AFN
            [self getDictionaryByAFN];
        }else{
            // NSURLSession
            [self getDictionaryBySession];
        }

    });
}

#pragma mark - 通过AFN获取app相关信息
- (void)getDictionaryByAFN{
    
//    __weak typeof(DFUpdate) *weakSelf = self;
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",_appId];
//    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        
//        // 从appStore获取到所有信息
//        NSDictionary *imgDic = responseObject[@"results"][0];
//        
//        [weakSelf manageDictionary:imgDic];
//        
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        
//        NSLog(@"网络异常");
//        
//    }];
    
}

#pragma mark - 通过NSURLSession获取app相关信息
- (void)getDictionaryBySession{
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",_appId]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
    
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
        __weak typeof(DFUpdate) *weakSelf = self;
    
        NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
            if (!error) {
                // 调用成功
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                // 从appStore获取到所有信息
                NSDictionary *imgDic = dic[@"results"][0];
                
                [weakSelf manageDictionary:imgDic];
            }else{
                // 调用失败
            }

    
            }];
            
                [sessionTask resume];
    
}

#pragma mark - 处理返回的数据
- (void)manageDictionary:(NSDictionary *)imgDic{
    
    // 提示框title
    NSString *title = @"版本有更新";
    
    // 更新按钮的文案
    NSString *updateButtonTitle = @"更新";
    
    // 取消按钮的文案
    NSString *cancleButtonTitle;
    if (_isNoMore) {
        cancleButtonTitle = @"不再显示";
    }else{
        cancleButtonTitle = @"取消";
    }
    
    // 当前app版本
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    // appStore 版本号
    NSString *newVersion = imgDic[@"version"];
    
    // 是否不再显示
    if (_isNoMore) {
        _newVersion = newVersion;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *cacheVersion = [userDefaults objectForKey:@"cacheVersion"];
        
        if ([cacheVersion isKindOfClass:[NSNull class]]||cacheVersion.length<=0) {
            // 第一次执行

        }else if([cacheVersion isEqualToString:newVersion]){
            // 已获取过信息 并且没有新版本发布
            
            return;
        }else{
            // 已获取过信息 有新版本发布

        }
    }

    // appStore 更新内容
    NSString *releaseNotes = imgDic[@"releaseNotes"];
    
    // 当前手机系统版本
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    
    // appStore 最低支持系统版本
    NSString *miniVersion = imgDic[@"minimumOsVersion"];
    
    if (![systemVersion compare:miniVersion options:NSCaseInsensitiveSearch]) {
        // 如果当前手机系统版本低于最低支持版本 不显示更新
        
        return ;
    }
    
    // 如果当前app版本等于appStore最新版本 不显示更新
    if (![nowVersion isEqualToString:newVersion]) {
        
        if (_isShowContent) {
            // 显示内容
            
            [self showAlertWithTitle:title messgae:releaseNotes updateButtonTitle:updateButtonTitle cancleButtonTitle:cancleButtonTitle];
            
        }else{
            // 不显示内容
            
            [self showAlertWithTitle:title messgae:nil updateButtonTitle:updateButtonTitle cancleButtonTitle:cancleButtonTitle];
        }
    }
    
}


- (void)showAlertWithTitle:(NSString *)title messgae:(NSString *)message updateButtonTitle:(NSString *)updateButtonTitle cancleButtonTitle:(NSString *)cancleButtonTitle{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancleButtonTitle otherButtonTitles:updateButtonTitle,nil];
            [alert show];
    });

}


- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8",_appId]];
        [[UIApplication sharedApplication] openURL:url];
    }if (buttonIndex == 0 && _isNoMore) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_newVersion forKey:@"cacheVersion"];
    }
}

@end
