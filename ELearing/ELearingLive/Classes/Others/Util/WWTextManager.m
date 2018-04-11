//
//  WWTextManager.m
//  wwface
//
//  Created by pc on 16/12/15.
//  Copyright © 2016年 fo. All rights reserved.
//

#import "WWTextManager.h"
#import <CoreText/CTFramesetter.h>
#import "NSString+Common.h"

@implementation WWTextManager


+(NSMutableArray * )getMessageMentionTags:(NSString*)text{
    NSMutableString * messageText= [[NSMutableString alloc]initWithString:text];
   
    /// Define a character set for hot characters (@ handle, # hashtag)
    NSString *hotCharacters = @"@";
    NSCharacterSet *hotCharactersSet = [NSCharacterSet characterSetWithCharactersInString:hotCharacters];
    
    // Define a character set for the complete world (determine the end of the hot word)
    NSMutableCharacterSet *validCharactersSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [validCharactersSet removeCharactersInString:@"!@#$%^&*()-={[]}|;:',<>.?/"];
    [validCharactersSet addCharactersInString:@"_"];
    
   NSMutableArray * rangesOfHotWords = [[NSMutableArray alloc] init];
    
    while ([messageText rangeOfCharacterFromSet:hotCharactersSet].location < messageText.length) {
        NSRange range = [messageText rangeOfCharacterFromSet:hotCharactersSet];
        
        [messageText replaceCharactersInRange:range withString:@""];
        // If the hot character is not preceded by a alphanumeric characater, ie email (sebastien@world.com)
        if (range.location > 0 && [validCharactersSet characterIsMember:[messageText characterAtIndex:range.location - 1]])
            continue;
        
        // Determine the length of the hot word
        int length = (int)range.length;
        
        while (range.location + length < messageText.length) {
            BOOL charIsMember = [validCharactersSet characterIsMember:[messageText characterAtIndex:range.location + length]];
            
            if (charIsMember)
                length++;
            else
                break;
        }
        
        // Register the hot word and its range
        if (length > 1){
            NSString *subString = [messageText substringAtRange:NSMakeRange(range.location, length)];
            [rangesOfHotWords addObject:subString?subString:@""];
        }

    }
    return rangesOfHotWords;

}
+ (CGFloat)textOfAlineHeightWithFontSize:(NSInteger)fontSize {
    return [WWTextManager textSizeWithString:@"测试" width:Main_Screen_Width fontSize:fontSize lineSpace:0].height;
}

+ (CGSize)textSizeWithStringZeroSpace:(NSString *)text width:(float)width fontSize:(NSInteger)fontSize{
    return [WWTextManager textSizeWithString:text width:width fontSize:fontSize lineSpace:0];
}

+ (CGSize)textSizeWithString:(NSString *)text width:(float)width fontSize:(NSInteger)fontSize lineSpace:(CGFloat)space {
    CGSize textSize = CGSizeZero;
    
    if (text.length <= 0) {
        return textSize;
    }
    BOOL containtEmoji = [text isContainsEmoji];
    if (containtEmoji) {
        NSRange allRange = [text rangeOfString:text];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} range:NSMakeRange(0, text.length)];
        if (space) {
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:space];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:allRange];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:allRange];
        }
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
        CGSize targetSize = CGSizeMake(width, CGFLOAT_MAX);
        textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, (CFIndex)[attributedString length]), NULL, targetSize, NULL);
        CFRelease(framesetter);
        textSize.height += 2;
        textSize.width += 2;
        return textSize;
    } else {
        NSMutableAttributedString *  attributedText = [[NSMutableAttributedString alloc] initWithString:text];
        [attributedText setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} range:NSMakeRange(0, text.length)];
        
        if (space) {
            NSRange allRange = [text rangeOfString:text];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:space];
            [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:allRange];
            [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:allRange];
        }
        
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width,0}
                                                   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                   context:nil];
        rect.size.height += 2;
        rect.size.width += 2;
        return rect.size;
    }
    
    /*  没有表情的文本计算方法
    NSLineBreakMode breakMode = NSLineBreakByWordWrapping;
    UIFont * font = WAWA_TEXTFONT_(fontSize);
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = breakMode;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = space;
    
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    
    NSDictionary * attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@1.5f};
    textSize = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size;
    textSize = CGSizeMake((int)textSize.width + 1, (int)textSize.height + 1);
    
    // iOS 10
    CGFloat scale = 17.5/17.0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        textSize.width = textSize.width * scale;
        textSize.height = textSize.height * scale;
    }
     */
}

+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((14[0-9])|(13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


+(int)getTextMaxFontWithMaxSize:(CGSize)size andDespStr:(NSString *)desp andCurrentFontSize:(int) fontSize andMaxFontSize:(int) maxFontSize{
    //绘制计算最佳文本大小
    CGSize maxSize=CGSizeMake(size.width*0.85, size.height*2.5/3.0);
    int currentFontSize = fontSize;
    NSString *str=[NSString stringWithFormat:@"%@",desp];
    CGSize requiredSize = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
    if(requiredSize.height<=maxSize.height)
    {
        while (requiredSize.height<=maxSize.height&&requiredSize.width<maxSize.width) {
            currentFontSize++;
            requiredSize=[str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
        }
    }else
    {
        while (requiredSize.height>maxSize.height||requiredSize.width>maxSize.width) {
            currentFontSize--;
            requiredSize=[str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
        }
        requiredSize=[str boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
    }
    if (currentFontSize >maxFontSize) {
        currentFontSize = maxFontSize;
    }
    return currentFontSize;
}



@end
