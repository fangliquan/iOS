//
//  ViewController.m
//  泛型
//
//  Created by leo on 16/7/21.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "ViewController.h"
#import "NewsInfo.h"

#import "Person.h"
#import "IOS.h"
#import "Java.h"
@interface ViewController ()

@property(nonatomic, strong) NSMutableArray<NewsInfo *> *mutableArray;

@end

@implementation ViewController

/**
 *  泛型：限制类型
    使用场景
     1.在集合（数组，字典，NSSet)中使用泛型比较常见
     2.当声明一个类，类里面的某些书写的类型不确定，这时候我们才使用泛型。
    书写规范
    在类型后面定义泛型，NSMutableArray<UIImage *> *mutableArray
    修饰：
     只能修饰方法的调用
    好处：
     1.提高规范，减少交流
     2.通过集合取出来对象，直接当做泛型对象使用，可以直接使用点语法
        self.mutableArray[0].temp;
 
 */

/**
*  Person 开发语音Language ,iOS,Java

*/


/**
*  __covariant(协变）:用于数据强转类型，可以向上强转，子类，可以转成 父类，Person<__covariant ObjectType>

*
   __contravariant（逆变）：用于泛型数据强转类型，可以向下强转，父类可以转成子类Person<__contravariant ObjectType>

*/

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    Person <Language *> *p = [[Person alloc]init];
    
    //self.mutableArray[0].temp;
    Person <IOS*> *iosP= [[Person alloc]init];
    
    //如果子类想给父类赋值，协变(__covariant)
    //Person<__covariant ObjectType>
    p = iosP;
    //父类强转成子类 逆变(__contravariant）
    //Person<__contravariant ObjectType>
    // iosP = p;
    //
    iosP.language =[IOS alloc];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
