//
//  ViewController.m
//  LNImageBrowser
//
//  Created by 张立宁 on 2017/10/31.
//  Copyright © 2017年 ZLN. All rights reserved.
//

#import "ViewController.h"
#import "ImagesViewController.h"
#import "LNProgressViewController.h"

#import "LNGCDTimer.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
    
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
    
- (void)initUI {
    UITableView *tableView = [UITableView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self nearByNavigationBarView:tableView isShowBottom:NO];
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            ImagesViewController *vc = [ImagesViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            LNProgressViewController *vc = [LNProgressViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        
        default:
        break;
    }
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
    
#pragma mark - getter
- (NSArray *)dataSource {
    if(!_dataSource) {
        _dataSource = @[@"ImageBrowser",@"ProgressView"];
    }
    return _dataSource;
}

@end
