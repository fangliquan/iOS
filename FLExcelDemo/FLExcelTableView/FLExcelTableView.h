//
//  FLExcelTableView.h
//  FLExcelDemo
//
//  Created by microleo on 2017/12/1.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FLExcelTableView : NSObject

@end

@interface ExcelTopLeftHeaderView:UIView

@property(nonatomic,copy,readonly) NSString *sectionTitle;

@property(nonatomic,copy,readonly) NSString *columnTitle;

-(instancetype) initWithSectionTitle:(NSString *)sectionTitle andColumnTitle:(NSString *)columnTitle;
@end

//indexPath
@interface ExcelIndexPath:NSObject

+(instancetype)indexPathForSection:(NSInteger)section inColumn:(NSInteger)column;
@property(nonatomic,assign) NSInteger section;
@property(nonatomic,assign) NSInteger column;

@end

