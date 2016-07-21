//
//  Person.m
//  IOS新特性
//
//  Created by leo on 16/7/21.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "Person.h"

@implementation Person

-(void)eat{
    
    NSLog(@"对象方法吃东西askdjalkjfalksjfklajfklasfa;lksf");
}
+(void) eat{
    
    NSLog(@"类方法吃东西askdjalkjfalksjfklajfklasfa;lksf");
}

-(void)run:(int)age{
    NSLog(@"%d类方法吃东西askdjalkjfalksjfklajfklasfa;lksf",age);
}
@end
