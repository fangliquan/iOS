//
//  ELeaingNewsItemCell.m
//  ELearingLive
//
//  Created by microleo on 2017/5/6.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ELeaingNewsItemCell.h"

@interface ELeaingNewsItemCell (){
    UIImageView *iconView;
    UILabel     *titleLabel;
    UILabel     *despLabel;
    UILabel     *bottomLabel;
}

@end
@implementation ELeaingNewsItemCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ELeaingNewsItemCell";
    ELeaingNewsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ELeaingNewsItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    iconView=[[UIImageView alloc]init];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconView];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont systemFontOfSize:EL_TEXTFONT_FLOAT_TITLE];
    titleLabel.textColor = EL_TEXTCOLOR_DARKGRAY;
    [self.contentView addSubview:titleLabel];
    
    despLabel =[[UILabel alloc]init];
    despLabel.font = [UIFont systemFontOfSize:13];
    despLabel.textColor = EL_TEXTCOLOR_GRAY;
    despLabel.numberOfLines = 2;
    [self.contentView addSubview:despLabel];
    
    bottomLabel = [[UILabel alloc]init];
    bottomLabel.font = [UIFont systemFontOfSize:12];
    bottomLabel.textColor = EL_TEXTCOLOR_GRAY;
    bottomLabel.numberOfLines = 1;
    [self.contentView addSubview:bottomLabel];

}

-(void)setELeaingNewsItemCellFrame:(ELeaingNewsItemCellFrame *)eLeaingNewsItemCellFrame{
    _eLeaingNewsItemCellFrame = eLeaingNewsItemCellFrame;
    titleLabel.frame = eLeaingNewsItemCellFrame.titleFrame;
    despLabel.frame = eLeaingNewsItemCellFrame.despFrame;
    iconView.frame = eLeaingNewsItemCellFrame.iconFrame;
    bottomLabel.frame = eLeaingNewsItemCellFrame.bottomLabelFrame;
    
    titleLabel.text = @"或搭载1.4T发动机 疑似宝沃BX3谍照曝";
    despLabel.text = @"或搭载1.4T发动机 疑似宝沃BX3谍照曝dl;asfa";
    bottomLabel.text = @"2017年05月02日 19:30";
    [iconView setImageWithURL:[NSURL URLWithString:@"http://www2.autoimg.cn/newsdfs/g18/M02/87/F0/120x90_0_autohomecar__wKgH2VkIYjeAG1o_AAFFkM6-UVg493.jpg"] placeholderImage:EL_Default_Image];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation ELeaingNewsItemCellFrame

-(void)setTemp:(NSString *)temp{
    
    CGFloat imagePercentage = 96/68.0;
    CGFloat imageHeight  = 90;
    CGFloat imageWidth  = imageHeight * imagePercentage;
 
    CGFloat marginX = 8;
    CGFloat offsetY = 8;
    
    _iconFrame = CGRectMake(marginX, offsetY, imageWidth, imageHeight);
    CGFloat textW = Main_Screen_Width - CGRectGetMaxX(_iconFrame) - 2*marginX;
    _titleFrame = CGRectMake(CGRectGetMaxX(_iconFrame) + marginX, offsetY, textW, 20);
    
    CGFloat despMaxH = [WWTextManager textOfAlineHeightWithFontSize:13] * 2 + 2;
    
    CGFloat despH = [WWTextManager textSizeWithStringZeroSpace:@"1231jaldkjlakjfdlkajflkaf" width:textW fontSize:13].height + 2;
    if (despH> despMaxH) {
        despH = despMaxH;
    }
    _despFrame = CGRectMake(CGRectGetMaxX(_iconFrame) +marginX, CGRectGetMaxY(_titleFrame) + offsetY, textW, despH);
    
    _bottomLabelFrame = CGRectMake(CGRectGetMaxX(_iconFrame) +marginX, CGRectGetMaxY(_iconFrame) - 18, textW, 15);
    
    _cellHeight = CGRectGetMaxY(_iconFrame) + offsetY;
    
    
    
}

@end

