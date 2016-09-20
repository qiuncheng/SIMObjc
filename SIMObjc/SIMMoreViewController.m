//
//  SIMMoreViewController.m
//  SIMObjc
//
//  Created by Ferris on 16/4/15.
//  Copyright (c) 2016年 Ferris. All rights reserved.
//

#import "SIMMoreViewController.h"
#import "MBProgressHUD.h"
//#import <JBWebViewController.h>
#import <SafariServices/SafariServices.h>
#import "SIMDBHandler.h"

@interface SIMMoreViewController ()

@property (weak, nonatomic) UISwitch *sw;

@end

@implementation SIMMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
            
        default:
            return 1;
            break;
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIdentify = @"SIMMoreReuseIdentify";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentify];
    if (indexPath.section == 0) {
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"英文原版";
            break;
        case 1:
            cell.textLabel.text = @"查阅作者博客";
            break;
        default:
            break;
    }
    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.text = @"重新获取数据";

    } else {
        cell.textLabel.text = @"内置浏览器阅读模式";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UISwitch *sw = [[UISwitch alloc]init];

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL safariReadingMode = [userDefaults boolForKey:kSafariReadingMode];
        
        sw.on = safariReadingMode;
        [sw addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        sw.center = CGPointMake([UIScreen mainScreen].bounds.size.width - sw.frame.size.width + 10, cell.center.y);
        [cell addSubview:sw];
        self.sw = sw;
    }
    return cell;
}
- (void) switchValueChange:(UISwitch*)sender {
    if (sender.on) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:kSafariReadingMode];
        [userDefaults synchronize];
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:NO forKey:kSafariReadingMode];
        [userDefaults synchronize];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"查阅作者博客"]) {

//        JBWebViewController* webViewController = [[JBWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://xferris.me"] mode:JBWebViewTitleModeNative];
//        [webViewController setWebTitle:@"风雅颂"];
//        [webViewController setLoadingString:@"加载中..."];
//        [webViewController showFromNavigationController:self.navigationController];

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL safariReadingMode = [userDefaults boolForKey:kSafariReadingMode];
        NSURL *url = [NSURL URLWithString:@"http://xferris.me"];
        SFSafariViewController *safariViewController = [[SFSafariViewController alloc]initWithURL:url entersReaderIfAvailable:safariReadingMode];
        [self presentViewController:safariViewController animated:YES completion:nil];

    }
    else if([cell.textLabel.text isEqualToString:@"英文原版"])
    {
//        JBWebViewController* webViewController = [[JBWebViewController alloc] initWithUrl:[NSURL URLWithString:@"https://www.objc.io"] mode:JBWebViewTitleModeNative];
//        [webViewController setWebTitle:@"objc.io"];
//        [webViewController setLoadingString:@"loading"];
//        [webViewController showFromNavigationController:self.navigationController];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL safariReadingMode = [userDefaults boolForKey:kSafariReadingMode];
        NSURL *url = [NSURL URLWithString:@"https://www.objc.io"];
        SFSafariViewController *safariViewController = [[SFSafariViewController alloc]initWithURL:url entersReaderIfAvailable:safariReadingMode];
        [self presentViewController:safariViewController animated:YES completion:nil];
    }
    else if ([cell.textLabel.text isEqualToString:@"重新获取数据"])
    {
        MBProgressHUD* progross = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        progross.detailsLabelText = @"载入中...";
        progross.detailsLabelFont = [mainFont fontWithSize:15.0f];
        [[SIMDBHandler shareDBHandler] deleteDBData];
        [[SIMDBHandler shareDBHandler] loadDataSouceFromService];
    }
}


@end
