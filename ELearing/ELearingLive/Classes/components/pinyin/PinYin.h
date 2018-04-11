/*
 *  pinyin.h
 *  Chinese Pinyin First Letter
 *
 *  Created by George on 4/21/10.
 *  Copyright 2010 RED/SAFI. All rights reserved.
 *
 */
/*
 * // Example
 *
 * #import "pinyin.h"
 *
 * NSString *hanyu = @"拿起笔做刀枪,集中火力打黑帮,革命师生齐造反,文化革命当闯将！";
 * for (int i = 0; i < [hanyu length]; i++)
 * {
 *     printf("%c", pinyinFirstLetter([hanyu characterAtIndex:i]));
 * }
 *
 */
char pinyinFirstLetter(unsigned short hanzi);