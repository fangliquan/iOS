//
//  PHTextView.m
//  wwface
//
//  Created by James on 14/12/30.
//  Copyright (c) 2014年 fo. All rights reserved.
//

#import "PHTextView.h"

#import <UIKit/UILabel.h>

@implementation PHTextView
{
    UILabel *placeHolderLabel;
}

@synthesize placeholder = _placeholder;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _fontSize = 0;
    if ( placeHolderLabel == nil )
    {
        CGSize size = [WWTextManager textSizeWithStringZeroSpace:@"111" width:Main_Screen_Width fontSize:_fontSize ? _fontSize : 15];
        placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 7, 200, size.height)];
        
        //        placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.font = [UIFont systemFontOfSize:15];
        placeHolderLabel.backgroundColor = [UIColor clearColor];
        placeHolderLabel.textColor = [UIColor colorWithWhite:0.794 alpha:1.000];
        placeHolderLabel.alpha = 0;
        [self addSubview:placeHolderLabel];
        
        /**
         *  使用 autolayout 会影响 textView 的contentSize 属性
         */
        //        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        //
        //        NSArray *placeHolderLabelConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[placeHolderLabel]-8-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(placeHolderLabel)];
        //
        //        [self addConstraints:placeHolderLabelConstraintsH];
        //
        //        NSArray *placeHolderLabelConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[placeHolderLabel]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(placeHolderLabel)];
        //
        //        [self addConstraints:placeHolderLabelConstraintsV];
        
    }
}

-(void)refreshPlaceholder
{
    if([[self text] length])
    {
        [placeHolderLabel setAlpha:0];
    }
    else
    {
        [placeHolderLabel setAlpha:1];
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self refreshPlaceholder];
    self.scrollEnabled = YES;
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    placeHolderLabel.font = font;
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    placeHolderLabel.text = _placeholder;
    
    if(placeHolderLabel){
        CGSize size = [WWTextManager textSizeWithStringZeroSpace:placeholder width:Main_Screen_Width - 30 fontSize:_fontSize ? _fontSize : 15];
        placeHolderLabel.frame = CGRectMake(6, 7, size.width + 2, size.height);
    }
    
    [self refreshPlaceholder];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

//When any text changes on textField, the delegate getter is called. At this time we refresh the textView's placeholder
-(id<UITextViewDelegate>)delegate
{
    [self refreshPlaceholder];
    return [super delegate];
}

@end
