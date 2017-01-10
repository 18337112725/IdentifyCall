//
//  ViewController.m
//  calltest
//
//  Created by 王梦辉 on 2016/12/27.
//  Copyright © 2016年 王梦辉. All rights reserved.
//

#import "ViewController.h"
#import <CallKit/CallKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake((self.view.frame.size.width-100)/2, 100, 100, 20);
    [checkBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [checkBtn setTitle:@"检查权限" forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkPermissions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];

    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.frame = CGRectMake((self.view.frame.size.width-100)/2, checkBtn.frame.size.height+checkBtn.frame.origin.y+50, 100, 20);
    [updateBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [updateBtn setTitle:@"更新数据" forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updateBtn];
    
}
-(void)checkPermissions:(UIButton *)sender
{
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    // 获取权限状态
    [manager getEnabledStatusForExtensionWithIdentifier:@"com.mh.calltest.mhtest" completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        if (!error) {
            NSString *title = nil;
            if (enabledStatus == CXCallDirectoryEnabledStatusDisabled) {
                /*
                 CXCallDirectoryEnabledStatusUnknown = 0,
                 CXCallDirectoryEnabledStatusDisabled = 1,
                 CXCallDirectoryEnabledStatusEnabled = 2,
                 */
                title = @"未授权，请在设置->电话授权相关权限";
            }else if (enabledStatus == CXCallDirectoryEnabledStatusEnabled) {
                title = @"授权";
            }else if (enabledStatus == CXCallDirectoryEnabledStatusUnknown) {
                title = @"不知道";
            }
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:title
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"有错误"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
//拦截号码或者号码标识的情况下,号码必须要加国标区号!!!!!!!!
-(void)updateData:(UIButton *)sender
{
//    数组存放的号码和标识数组存放的标识要一一对应，号码要按升序排列(此过程在传之后统一进行了排序)，
    NSMutableDictionary *peopledic = [[NSMutableDictionary alloc] init];
    NSArray *name = @[@"IOS",@"诈骗",@"骚扰",@"IOS开发"];
    NSArray *phone = @[@"15524910212",@"8618300675120",@"8618312345654",@"8617718513625"];
    
    for (int i = 0 ;i < name.count ; i++) {
        [peopledic setValue:[NSString stringWithFormat:@"%@",name[i]] forKey:[NSString stringWithFormat:@"%@",phone[i]]];
    }
    
    
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.mh.calltest.w"] setValue:peopledic forKey:@"phone"];
    
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    [manager reloadExtensionWithIdentifier:@"com.mh.calltest.mhtest" completionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"更新成功"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"更新失败"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


@end
