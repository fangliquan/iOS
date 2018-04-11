
#import <Foundation/Foundation.h>
#import "LKDB+Mapping.h"
#import "NSObject+LKModel.h"
#import "BaseModel.h"


#pragma mark- GoodsShoppingOrder
@interface GoodsShoppingOrder : BaseModel

@property (nonatomic, assign) long long goodsId;
@property (nonatomic, assign) long long shopId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger type;
@property (nonatomic) double price;
@property (nonatomic) double discountPrice;
@property (nonatomic, strong) NSString *purchaseNote;
@property (nonatomic, assign) int buyCount;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * desp;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * standardName;
@property (nonatomic, assign) long long standardId;
@property (nonatomic, assign) int isSelect;

@property(nonatomic,copy) NSString *goodId_standardId;
// 获取购物车数据
+ (NSArray *)getShoppingCarOrder;
// 添加到购物车
+ (void)addShoppingCar:(NSObject *)addOrder;
// 减少订单数目
+ (void)reduceShoppingOrder:(NSString *)key;
// 删除订单
+ (void)deleteShoppingOrder:(NSString *)key;
// 退出登录清空购物车
+ (void)cleanShoppingCar;
//更新购物车
+(void)updateShoppingOrder:(BOOL)isSelect andGoodsId:(NSString *)key;
// 获取添加减少购物车数量
+ (void)addShoppingCount;
+ (void)reduceShoppingCount:(NSInteger)reduceCount;
+ (NSInteger)getShoppingCount;

// 获取总价格 (原价和现价)
+ (NSArray *)getPrice;
//获取要购买商品
+ (NSArray *)getShoppingGoodsWithGoodsId:(NSString *)key;
//获取所有要购买的商品
+ (NSArray *)geBuyGoodsData;

+ (NSArray *)getUnSelectedGoods;

@end

#pragma mark - Login Info
@interface LoginInfo : BaseModel
@property (nonatomic, assign) long userId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, copy)   NSString * token;
@property (nonatomic, assign)   NSInteger isLogined;
@end

@class UserInfoTemp;
@interface UserInfoTemp:BaseModel
@property(nonatomic,assign) long long   userId;
@property(nonatomic,strong) NSString  *userName;
@property(nonatomic,assign) NSInteger  age;

+(UserInfoTemp *)getUserInfoWithUserId:(long long)userId;

//根据条件获取
+(NSArray *)getAllUserInfoWithCondition:(NSString *)condition;

+(void)insertUserInfo:(UserInfoTemp *)user;

+(void)insertUserInfos:(NSArray<UserInfoTemp*>*)users;

+(void)udateUserInfo:(UserInfoTemp *)user;

@end












