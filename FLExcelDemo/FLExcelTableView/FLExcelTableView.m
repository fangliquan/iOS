//
//  FLExcelTableView.m
//  FLExcelDemo
//
//  Created by microleo on 2017/12/1.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "FLExcelTableView.h"

@implementation FLExcelTableView

@end

@implementation ExcelTopLeftHeaderView
-(instancetype)initWithSectionTitle:(NSString *)sectionTitle andColumnTitle:(NSString *)columnTitle{
    self = [super init];
    _sectionTitle = sectionTitle;
    _columnTitle = columnTitle;
    return self;
}

@end

@implementation ExcelIndexPath
+(instancetype)indexPathForSection:(NSInteger)section inColumn:(NSInteger)column{
    ExcelIndexPath *indexPath = [[ExcelIndexPath alloc]init];
    indexPath.section = section;
    indexPath.column = column;
    return indexPath;
}

@end
