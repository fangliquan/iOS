
#import "AccountInfo.h"
#import "DBManager.h"
#define kShoppingCarCount    @"kShoppingCarCount"   // 购物车数字提示

#pragma mark- GoodsShoppingOrder
@implementation GoodsShoppingOrder

+ (NSString *)getPrimaryKey {
    return @"goodsId";
}

+ (NSString *)getTableName {
    return @"GoodsShoppingOrder";
}

// 获取购物车数据
+ (NSArray *)getShoppingCarOrder {
    return [[DBManager sharedInstance] loadTableData:[GoodsShoppingOrder class] Condition:nil];
}

// 添加到购物车
+ (void)addShoppingCar:(NSObject *)addOrder {
    NSString* goodId_standardId = @"";//key
   if ([addOrder isKindOfClass:[GoodsShoppingOrder class]]) {
        GoodsShoppingOrder * addBookOrder = (GoodsShoppingOrder *)addOrder;
        goodId_standardId = addBookOrder.goodId_standardId;
    }
    GoodsShoppingOrder * bookOrder = [GoodsShoppingOrder getPictureBookOrder:goodId_standardId];
    if (bookOrder) {    // 存在, 购买数量加1
        bookOrder.buyCount += 1;
        [[DBManager sharedInstance] cleanTableData:[GoodsShoppingOrder class] Condition:[NSString stringWithFormat:@" where  goodId_standardId ='%@'",goodId_standardId ]];
        [bookOrder save];
    } else {    // 不存在直接存储
      
            GoodsShoppingOrder * addBookOrder = [[GoodsShoppingOrder alloc] init];
   
            
            [[DBManager sharedInstance] cleanTableData:[GoodsShoppingOrder class] Condition:[NSString stringWithFormat:@" where  goodId_standardId = '%@'", addBookOrder.goodId_standardId ]];

            [addBookOrder save];

    }
    [GoodsShoppingOrder addShoppingCount];
}

// 减少订单数目
+ (void)reduceShoppingOrder:(NSString *)key {
    GoodsShoppingOrder * order = [GoodsShoppingOrder getPictureBookOrder:key];
    if (order.buyCount > 1) {
        order.buyCount -= 1;

        [[DBManager sharedInstance] cleanTableData:[GoodsShoppingOrder class] Condition:[NSString stringWithFormat:@" where  goodId_standardId ='%@'",key ]];
        [order save];
        
        [GoodsShoppingOrder reduceShoppingCount:1];
    }
}

// 删除订单
+ (void)deleteShoppingOrder:(NSString *)key {
     GoodsShoppingOrder * order = [GoodsShoppingOrder getPictureBookOrder:key];
    [GoodsShoppingOrder reduceShoppingCount:order.buyCount];
    [[DBManager sharedInstance] cleanTableData:[GoodsShoppingOrder class] Condition:[NSString stringWithFormat:@" where  goodId_standardId ='%@'",key ]];
}

// 退出登录清空购物车
+ (void)cleanShoppingCar {
    [[DBManager sharedInstance] cleanTableData:[GoodsShoppingOrder class]];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kShoppingCarCount];
}

//更新购物车
+(void)updateShoppingOrder:(BOOL)isSelect andGoodsId:(NSString *)key{
    
    [[DBManager sharedInstance]updateTableData:[GoodsShoppingOrder class] UpdateColumns:[NSString stringWithFormat:@" isSelect = %d",isSelect?1 :0] Condition:[NSString stringWithFormat: @" goodId_standardId = '%@'",key]];
}

+ (GoodsShoppingOrder *)getPictureBookOrder:(NSString *)key {
    return [[DBManager sharedInstance] loadTableFirstData:[GoodsShoppingOrder class] Condition:[NSString stringWithFormat:@" where goodId_standardId = '%@'", key]];
}

// 获取添加减少购物车数量
+ (void)addShoppingCount {
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:kShoppingCarCount];
    count ++;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:kShoppingCarCount];
}

+ (void)reduceShoppingCount:(NSInteger)reduceCount {
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:kShoppingCarCount];
    if (count > 0) {
        count -= reduceCount;
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:kShoppingCarCount];
    }
}

+ (NSInteger)getShoppingCount {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kShoppingCarCount];
}

// 获取总价格 (原价和现价)
+ (NSArray *)getPrice {
    double currentCostPrice = 0;
    double costPrice = 0;
    double buyCount = 0;
    NSArray * orders = [GoodsShoppingOrder getShoppingCarOrder];
    for (GoodsShoppingOrder * order in orders) {
        if (order.isSelect) {
            currentCostPrice += order.discountPrice * order.buyCount;
            costPrice += order.price * order.buyCount;
            buyCount +=1;
        }

    }
    return [NSArray arrayWithObjects:[NSNumber numberWithDouble:currentCostPrice], [NSNumber numberWithDouble:costPrice], [NSNumber numberWithDouble:buyCount],nil];
}


+ (NSArray *)getShoppingGoodsWithGoodsId:(NSString *)key{
    
    return [[DBManager sharedInstance] loadTableData:[GoodsShoppingOrder class] Condition:[NSString stringWithFormat:@" where goodId_standardId = '%@' and isSelect = 1", key]];
}

+ (NSArray *)getUnSelectedGoods{
    
    return [[DBManager sharedInstance] loadTableData:[GoodsShoppingOrder class] Condition:[NSString stringWithFormat:@" where  isSelect = 0"]];
}

+ (NSArray *)geBuyGoodsData{
    return [[DBManager sharedInstance] loadTableData:[GoodsShoppingOrder class] Condition:[NSString stringWithFormat:@" where  isSelect = 1"]];
}
@end


#pragma mark - Login Info
@implementation LoginInfo

@synthesize userId;
@synthesize deviceId;
@synthesize token;
@synthesize isLogined;

+(bool)isInSystemDB {
    return YES;
}

+(NSString *)getPrimaryKey
{
    return @"userId";
}

+(NSString *)getTableName
{
    return @"LoginInfo";
}

@end

@implementation UserInfoTemp

+(bool)isInSystemDB {
    return NO;
}

+(NSString *)getPrimaryKey
{
    return @"userId";
}

+(NSString *)getTableName
{
    return @"UserInfoTemp";
}

+(UserInfoTemp *)getUserInfoWithUserId:(long long)userId{
    return [[DBManager sharedInstance] loadTableFirstData:[UserInfoTemp class] Condition:[NSString stringWithFormat:@" where userId = %lld", userId]];
}

//根据条件获取
+(NSArray *)getAllUserInfoWithCondition:(NSString *)condition{
    
       return [[DBManager sharedInstance] loadTableData:[UserInfoTemp class] Condition:condition];
}
+(void)insertUserInfo:(UserInfoTemp *)user{
    if (![UserInfoTemp getUserInfoWithUserId:user.userId]) {
        [[DBManager sharedInstance] saveData:user];
    }
}

+(void)insertUserInfos:(NSArray<UserInfoTemp*>*)users{
    
    [[DBManager sharedInstance]saveData:users modelClass:[UserInfoTemp class]];
    
}

+(void)udateUserInfo:(UserInfoTemp *)user{
      [[DBManager sharedInstance]updateTableData:[UserInfoTemp class] UpdateColumns:[NSString stringWithFormat: @"userName = '%@'",@"大家好"] Condition:[NSString stringWithFormat:@" userId = %lld",user.userId]];
}

@end

