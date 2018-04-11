//
//  ELeaingNewsItemCell.h
//  ELearingLive
//
//  Created by microleo on 2017/5/6.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ELeaingNewsItemCellFrame;

@interface ELeaingNewsItemCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView ;

@property(nonatomic,strong) ELeaingNewsItemCellFrame *eLeaingNewsItemCellFrame;



@end

@interface ELeaingNewsItemCellFrame: NSObject

@property (nonatomic,strong) NSString *temp;
@property (nonatomic, assign) CGRect  iconFrame;
@property (nonatomic, assign) CGRect  titleFrame;
@property (nonatomic, assign) CGRect  despFrame;
@property (nonatomic, assign) CGRect  bottomLabelFrame;
@property (nonatomic, assign) CGFloat cellHeight;
@end
