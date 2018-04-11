//
//  ELiveNewsViewController.m
//  ELearingLive
//
//  Created by microleo on 2017/5/3.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ELiveNewsMainViewController.h"
#import "MJRefresh.h"
#import "ELeaingNewsItemCell.h"
#import "LoopView.h"

#import "ELiveNewsDetialViewController.h"
@interface ELiveNewsMainViewController ()

@property(nonatomic,strong) NSMutableArray *newsArrays;

@end

@implementation ELiveNewsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.newsArrays = [NSMutableArray array];
    for (int i = 0; i <10; i++) {
        ELeaingNewsItemCellFrame *itemF = [[ELeaingNewsItemCellFrame alloc]init];
        itemF.temp = @"aijda;kdf;af";
        [self.newsArrays addObject:itemF];
    }
    [self configtableView];
    [self createHeaderView];
    // Do any additional setup after loading the view.
}

-(void)createHeaderView{
    
    NSMutableArray *imageArrays  = [NSMutableArray array];
    
    for (int i = 0; i < 3; i ++) {
        [imageArrays addObject:@"http://www2.autoimg.cn/newsdfs/g13/M06/94/4E/640x320_0_autohomecar__wKjBylkNnG2AcWP1AAr60-uT8BI378.jpg"];
    }
    LoopView *headerLoopView =[[LoopView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 180) imageUrls:imageArrays loopPictures:imageArrays handler:^(UIViewController *vc) {
        
    }];
    self.tableView.tableHeaderView = headerLoopView;
}

-(void)loadData{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.newsArrays.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ELeaingNewsItemCellFrame *itemFrame = self.newsArrays.count >indexPath.row ?self.newsArrays[indexPath.row]:nil;
    return itemFrame.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELeaingNewsItemCell *cell = [ELeaingNewsItemCell cellWithTableView:tableView];
    cell.eLeaingNewsItemCellFrame = self.newsArrays.count >indexPath.row ?self.newsArrays[indexPath.row]:nil;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ELiveNewsDetialViewController *detailVc = [[ELiveNewsDetialViewController alloc]init];
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}



#pragma mark- TableView Line Width
- (void )configtableView {
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
