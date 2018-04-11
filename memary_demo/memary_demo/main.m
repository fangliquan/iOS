//
//  main.m
//  memary_demo
//
//  Created by microleo on 2017/11/9.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Persion.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSLog(@"Hello, World!");
        
        Persion *p = [[Persion alloc]init];
        
        [p speak];
        
        NSLog(@"------------- %ld",[p retainCount])
    }
    return 0;
}
