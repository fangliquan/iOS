
#import "DBManagerBase.h"
#import <CoreData/CoreData.h>
#import <pthread.h>
#import "PublicUtil.h"
#import "SystemInfo.h"
#import "VersionInfo.h"
#import "Informations.h"
#import "AccountInfo.h"
//定义数据名称
#define SYSTEM_DATABASE_NAME_PREFIX @"microleo_system"
#define USER_DATABASE_NAME_PREFIX @"microleo_user_v2"

#define OLD_USER_DATABASE_NAME_PREFIX @"microleo_user_v1"
#define DEFAULT_SERVER_ADDRESS  @"www.microleo.com"

@interface DBManager(){
    BOOL _isSystemDBInitialized;
    BOOL _isUserDBInitialized;
    NSString *_userDBPath;
    NSString *_systemDBPath;
}
@end

@implementation DBManager

static DBManager *_sharedInstance = nil;

#pragma mark - privatenction
-(void)generateDBDefine
{
    // system db 系统数据表
    NSArray *systemDBTables = [[NSArray alloc] initWithObjects:
                                    [SystemInfo class],
                                    [LoginInfo class],
                                    [VersionInfo class],
                                    nil];
    
    // user db 在这里创建表
    NSArray *userDBTables = [[NSArray alloc] initWithObjects:[GoodsShoppingOrder class],[UserInfoTemp class],nil];
    
    _dbDef = [[NSDictionary alloc] initWithObjectsAndKeys:systemDBTables, SYSTEM_DATABASE_NAME_PREFIX, userDBTables, USER_DATABASE_NAME_PREFIX, nil];
}

-(BOOL) createTable:(NSString*)tableName schema:(NSDictionary*)tableDict inDB:(sqlite3*)db
{
    BOOL ret = YES;
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"create table if not exists %@ (", tableName ];
    
    NSArray *fields = [tableDict allKeys];
    for (NSString *field in fields)
    {
        NSString *type = [tableDict objectForKey:field];
        
        [sql appendFormat:@"%@ %@,", field, type];
    }
    
    [sql deleteCharactersInRange:NSMakeRange(sql.length-1,1)]; // remove the last comma
    [sql appendString:@")"];
    
    char *errmsg;
    int rc = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errmsg);
    if (rc != SQLITE_OK)
    {
        NSLog(@"%s fail, rc = %d, reason = %s , sql = %@",__FUNCTION__ ,rc, errmsg, sql);
        ret = NO;
    }
    
    return ret;
}

-(BOOL) updateTable:(NSString*)tableName schema:(NSDictionary*)tableDict inDB:(sqlite3*)db
{
    BOOL ret = YES;
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
    sqlite3_stmt *stmt;
    int rc = sqlite3_prepare_v2(db,[sql UTF8String],-1,&stmt,0);
    if (rc == SQLITE_OK)
    {
        sqlite3_step(stmt);
        
        NSMutableDictionary *oldTableDict = [[NSMutableDictionary alloc]init];
        int count = sqlite3_column_count(stmt);
        for (int i =0; i < count; i++)
        {
            const char *name = sqlite3_column_name(stmt, i);
            const char *type = sqlite3_column_decltype(stmt, i);
            
            [oldTableDict setObject:[PublicUtil NSStringFromCString:type] forKey:[PublicUtil NSStringFromCString:name]];
        }
        
        sqlite3_finalize(stmt);
        
        NSMutableArray *addedFields = [[NSMutableArray alloc] init];
        NSMutableArray *modifiedFields = [[NSMutableArray alloc] init];
        NSMutableArray *removedFields = [[NSMutableArray alloc] init];
        NSMutableArray *keepedFields = [[NSMutableArray alloc] init];
        
        NSArray *keys = [tableDict allKeys];
        for (NSString *key in keys)
        {
            NSString *newType = [tableDict objectForKey:key];
            NSString *oldType  = [oldTableDict objectForKey:key];
            if (oldType == nil)
            {
                // added field
                [addedFields addObject:key];
            }
            else
            {
                if (![oldType isEqualToString:newType])
                {
                    //modified field
                    [modifiedFields addObject:key];
                }
                else
                {
                    [keepedFields addObject:key];
                }
            }
        }
        
        keys = [oldTableDict allKeys];
        for (NSString *key in keys)
        {
            NSString *newType = [tableDict objectForKey:key];
            if (newType == nil)
            {
                // removed field
                [removedFields addObject:key];
            }
        }
        
        if ([modifiedFields count]==0 && [removedFields count]==0)
        {
            for (NSString *key in addedFields)
            {
                NSString *newType = [tableDict objectForKey:key];
                NSString *sql = [NSString stringWithFormat:@"alter table %@ add %@ %@", tableName, key, newType];
                char *errMsg;
                if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"%s fail, sql=%@, reason=%s", __FUNCTION__, sql, errMsg);
                }
            }
        }
        else
        {
            if ([keepedFields count] > 0)
            {
                NSString *sql = [NSString stringWithFormat:@"alter table %@ rename to %@_temp", tableName, tableName];
                char *errMsg;
                if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"%s fail, sql=%@, reason=%s", __FUNCTION__, sql, errMsg);
                    ret = NO;
                }
                else
                {
                    ret = [self createTable:tableName schema:tableDict inDB:db];
                    if (ret)
                    {
                        NSMutableString *fields = [[NSMutableString alloc]init];
                        for (NSString *key in keepedFields)
                        {
                            [fields appendFormat:@"%@,", key];
                        }
                        
                        [fields deleteCharactersInRange:NSMakeRange(fields.length-1, 1)];
                        
                        sql = [NSString stringWithFormat:@"insert into %@ (%@) select %@ from %@_temp", tableName, fields, fields, tableName];
                        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
                        {
                            NSLog(@"%s fail, sql=%@, reason=%s", __FUNCTION__, sql, errMsg);
                            ret = NO;
                        }
                    }
                    
                    sql = [NSString stringWithFormat:@"drop table %@_temp", tableName];
                    sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg);
                }
            }
        }
    }
    else
    {
        NSLog(@"%s fail, rc = %d, sql = %@",__FUNCTION__ , rc, sql);
        ret = NO;
    }
    
    return ret;
}

-(BOOL)isTable:(NSString*)tableName inArray:(NSArray*)tables
{
    BOOL ret = NO;
    for (NSString *items in tables)
    {
        if ([items isEqualToString:tableName])
        {
            ret = YES;
            break;
        }
    }
    
    return ret;
}

-(BOOL)updateDBTables:(NSArray*)dbTables inDB:(sqlite3*)db
{
    BOOL ret = YES;
    
    NSString *sql = @"SELECT tbl_name FROM sqlite_master WHERE type='table'";
    sqlite3_stmt *stmt;
    int rc = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    if (rc == SQLITE_OK)
    {
        NSMutableArray *tables = [[NSMutableArray alloc]init];
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            const char * sTableName = (const char *)sqlite3_column_text(stmt, 0);
            NSString *tableName = [PublicUtil NSStringFromCString:sTableName];
            [tables addObject:tableName];
        }
        sqlite3_finalize(stmt);
        
        for (int i = 0; i < [dbTables count]; i++){
            Class tableClass = [dbTables objectAtIndex: i];
            if (![self isTable:[tableClass getTableName] inArray:tables])
            {
                NSString *createTable = [tableClass getCreateTableSQL];
                char *errmsg;
                int rc = sqlite3_exec(db, [createTable UTF8String], NULL, NULL, &errmsg);
                if (rc != SQLITE_OK)
                {
                    NSLog(@"%s fail, rc = %d, reason = %s , sql = %@",__FUNCTION__ ,rc, errmsg, sql);
                    ret = NO;
                }
                
                if ([[tableClass getTableName] isEqualToString:[Informations getTableName]]) {
                    Informations * dbCreateTime = [[Informations alloc] init];
                    dbCreateTime.itemName = KEY_DB_CREATE_TIMESTAMP;
                    dbCreateTime.itemValue = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
                    
                    sql = [Informations getInsertDataSQL:dbCreateTime];
                    rc = sqlite3_exec(db, [sql UTF8String], NULL, NULL, nil);
                    
                    if (rc != SQLITE_OK)
                    {
                        NSLog(@"%s fail, rc = %d, reason = %s , sql = %@",__FUNCTION__ ,rc, errmsg, sql);
                        ret = NO;
                    }
                }
            }
            else
            {
                NSMutableDictionary *newTableDict = [[NSMutableDictionary alloc]init];
                
                LKModelInfos* infos = [tableClass getModelInfos];
                for (int i=0; i<infos.count; i++) {
                    LKDBProperty* property =  [infos objectWithIndex:i];
                    [tableClass columnAttributeWithProperty:property];
                    [newTableDict setValue:property.sqlColumnType forKey:property.sqlColumnName];
                }
                
                ret = [self updateTable:[tableClass getTableName] schema:newTableDict inDB:db];
            }
            
            if (!ret)
                break;
        }
    }
    else
    {
        ret = NO;
         NSLog(@"%s fail, rc = %d",__FUNCTION__ ,rc);
    }
    
    
    return ret;
}

-(NSString *)sysDBDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

-(NSString *)userDBDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

-(BOOL)prepareSystemDB
{
    BOOL ret = YES;
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.db", DEFAULT_SERVER_ADDRESS, SYSTEM_DATABASE_NAME_PREFIX];
    _systemDBPath = [[self sysDBDirectory] stringByAppendingPathComponent:fileName];
    
    sqlite3 *systemDB;
    pthread_mutex_lock(&_systemDBMutex);
    
    int rc = sqlite3_open([_systemDBPath UTF8String], &systemDB);
    if (rc != SQLITE_OK ) {
        NSLog(@"create system database fail, rc = %d", rc);
        ret = NO;
    }
    else
    {
        NSArray *dbTables = [_dbDef objectForKey:SYSTEM_DATABASE_NAME_PREFIX];
        ret = [self updateDBTables:dbTables inDB:systemDB];
        sqlite3_close(systemDB);
    }
    pthread_mutex_unlock(&_systemDBMutex);
    
    if (ret) {
        _isSystemDBInitialized = YES;
    
        //prevent files from being backed up to iCloud
        NSURL *sysDBURL = [NSURL fileURLWithPath:_systemDBPath];
        [self addSkipBackupAttributeToItemAtURL:sysDBURL];
    }
    
    return ret;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

-(BOOL)prepareUserDB
{
    BOOL ret = YES;
    int rc = SQLITE_OK;

    sqlite3 * systemDB =[self getSystemDB];
    if (systemDB == NULL)
        return NO;
    
    pthread_mutex_lock(&_systemDBMutex);
    long userId = -1;
    NSString *sql = @"select userId from LoginInfo where isLogined = 1";
    sqlite3_stmt *stmt;
    rc = sqlite3_prepare_v2(systemDB, [sql UTF8String], -1, &stmt, nil);
    if (rc == SQLITE_OK) {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            userId = sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }
    else
    {
        NSLog(@"get current user error, rc = %d", rc);
    }
    pthread_mutex_unlock(&_systemDBMutex);
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%ld.db", DEFAULT_SERVER_ADDRESS, USER_DATABASE_NAME_PREFIX, userId];
    _userDBPath = [[self userDBDirectory] stringByAppendingPathComponent:fileName];

    if (userId <= 0)
    {
        return NO;
    }
    
    [self deleteOldUserDB:userId];
    
    sqlite3 *userDB;
    pthread_mutex_lock(&_userDBMutex);
    
    rc = sqlite3_open([_userDBPath UTF8String], &userDB);
    if (rc != SQLITE_OK ) {
        NSLog(@"create user database fail, rc = %d", rc);
        ret = NO;
    }
    else
    {
        NSArray *dbTables = [_dbDef objectForKey:USER_DATABASE_NAME_PREFIX];
        ret = [self updateDBTables:dbTables inDB:userDB];
        sqlite3_close(userDB);
    }
    pthread_mutex_unlock(&_userDBMutex);
    
    if (ret)
    {
        _isUserDBInitialized = YES;
        
        //prevent files from being backed up to iCloud
        NSURL *userDBURL = [NSURL fileURLWithPath:_userDBPath];
        [self addSkipBackupAttributeToItemAtURL:userDBURL];
    }
    
    return YES;
}

- (BOOL)deleteUserDB:(NSString *)dbName andUserId:(long)userId {
    
    BOOL ret = NO;
    
    // delete old user db file
    NSString *oldFileName = [NSString stringWithFormat:@"%@_%@_%ld.db", DEFAULT_SERVER_ADDRESS, dbName, userId];
    NSString *oldUserDBPath = [[self userDBDirectory] stringByAppendingPathComponent:oldFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:oldUserDBPath]) {
        ret = [fileManager removeItemAtPath:oldUserDBPath error:nil];
    }
    
    return ret;
}

- (BOOL)deleteOldUserDB:(long)userId {
    return [self deleteUserDB:OLD_USER_DATABASE_NAME_PREFIX andUserId:userId];
}

- (BOOL)deleteCurrentUserDB:(long)userId  {
    BOOL ret = [self deleteUserDB:USER_DATABASE_NAME_PREFIX andUserId:userId];
    if (ret) {
        _isUserDBInitialized = NO;
    }
    return ret;
}

#pragma mark - public 
-(sqlite3*)getSystemDB
{
    if (!_isSystemDBInitialized)
    {
        [self prepareSystemDB];
    }
    
    sqlite3 *systemDB = nil;
    int rc = SQLITE_OK;
    pthread_mutex_lock(&_systemDBMutex);
    if (sqlite3_open([_systemDBPath UTF8String], &systemDB) !=SQLITE_OK ) {
        NSLog(@"create system database fail, rc = %d", rc);
    }
    
    pthread_mutex_unlock(&_systemDBMutex);
    
    return systemDB;
}

-(sqlite3*)getUserDB
{
    if (!_isUserDBInitialized)
    {
        [self prepareUserDB];
    }
    
    sqlite3 *userDB = nil;
    int rc = SQLITE_OK;
    
    pthread_mutex_lock(&_userDBMutex);
    if (sqlite3_open([_userDBPath UTF8String], &userDB) !=SQLITE_OK ) {
        NSLog(@"create user database fail, rc = %d", rc);
    }
    pthread_mutex_unlock(&_userDBMutex);
    return userDB;
}

-(void) enterLogoffState
{
    _isUserDBInitialized = NO;
}

#pragma mark - loadTableFirstData
-(id)loadTableFirstData:(Class)modelClass Condition:(NSString*)condition
{
    NSArray *result;
    if(condition != nil) {
        result = [self loadTableData:modelClass Condition:[NSString stringWithFormat:@" %@ limit 1", condition]];
    } else {
        result = [self loadTableData:modelClass Condition:@" limit 1"];
    }
    if(result != nil && result.count > 0)
    {
        return result[0];
    }
    return nil;
}

#pragma mark - updateTableData
-(void)updateTableData:(Class)modelClass UpdateColumns:(NSString *)columns
{
    [self updateTableData:modelClass UpdateColumns:columns Condition:nil];
}

-(void)updateTableData:(Class)modelClass UpdateColumns:(NSString *)columns Condition:(NSString*)condition
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"update %@ set %@", [modelClass getTableName], columns];
    if (condition != nil) {
        [sql appendFormat:@" where %@", condition];
    }
    
    sqlite3 *db = nil;
    if([modelClass isInSystemDB]) {
        db = [self getSystemDB];
        pthread_mutex_lock(&_systemDBMutex);
    } else {
        db = [self getUserDB];
        pthread_mutex_lock(&_userDBMutex);
    }
    
    sqlite3_stmt *stmt;
    int rc = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    if (rc != SQLITE_OK)
    {
        NSLog(@"updateTableData fail, rc = %d",rc);
    }
    sqlite3_step(stmt);
    sqlite3_close(db);
    if([modelClass isInSystemDB]) {
        pthread_mutex_unlock(&_systemDBMutex);
    } else {
        pthread_mutex_unlock(&_userDBMutex);
    }
}

#pragma mark - loadTableData
-(NSArray*)loadTableData:(Class)modelClass
{
    return [self loadTableData:modelClass Condition:[NSString stringWithFormat:@" order by %@ desc", [modelClass getPrimaryKey]]];
}

-(NSArray*)loadTableData:(Class)modelClass Condition:(NSString*)condition
{
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"select * from %@ ", [modelClass getTableName]];
    if(condition != nil && condition.length > 0) {
        [sql appendString:condition];
    }
    
    return [self loadTableData:modelClass BySql:sql];
}
-(NSArray*)loadTableCloumnData:(Class)modelClass andCloumnName:(NSString *)cloumnName andIsDistinct:(BOOL)isDistinct Condition:(NSString*)condition{
    NSMutableString *sql = [NSMutableString string];
    if (isDistinct) {
        [sql appendFormat:@"select DISTINCT %@ from %@ where ", cloumnName ,[modelClass getTableName]];
    }else{
        [sql appendFormat:@"select  %@ from %@ where", cloumnName ,[modelClass getTableName]];
    }
    
    if(condition != nil && condition.length > 0) {
        [sql appendString:condition];
    }
    
    return [self loadTableData:modelClass BySql:sql];
}

-(NSArray*)loadTableData:(Class)modelClass BySql:(NSString*)sql
{
//    ENTER_FUNC;
    NSArray *ret = nil;
    sqlite3 *db = nil;
    if([modelClass isInSystemDB]) {
        db = [self getSystemDB];
        pthread_mutex_lock(&_systemDBMutex);
    } else {
        db = [self getUserDB];
        pthread_mutex_lock(&_userDBMutex);
    }
    
    sqlite3_stmt *stmt;
    int rc = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    if (rc == SQLITE_OK)
    {
        NSMutableArray *queryResult = [[NSMutableArray alloc] init];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            id result = [[modelClass alloc] init];
            
            for(int columnIdx = 0; columnIdx < sqlite3_column_count(stmt); columnIdx++)
            {
                NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(stmt, columnIdx)];
                int columnType = sqlite3_column_type(stmt, columnIdx);
                id columnValue = nil;
                
                if (columnType == SQLITE_INTEGER) {
                    columnValue = [NSNumber numberWithLongLong:(long long int)sqlite3_column_int64(stmt, columnIdx)];
                }
                else if (columnType == SQLITE_FLOAT) {
                    columnValue = [NSNumber numberWithDouble:sqlite3_column_double(stmt, columnIdx)];
                }
                else {
                    char* columnCharValue = (char*)sqlite3_column_text(stmt, columnIdx);
                    
                    if (columnCharValue == nil) {
                        if (columnType == SQLITE_TEXT || columnType == SQLITE3_TEXT) {
                            columnValue = @"";
                        }
                    } else {
                        columnValue = [[NSString alloc] initWithUTF8String:columnCharValue];
                    }
                }
                
                if (columnValue != nil) {
                    [result setValue:columnValue forKey:columnName];
                }
                
            }
            
            [queryResult addObject:result];
        }
        ret = queryResult;
        sqlite3_finalize(stmt);
    }
    else
    {
        NSLog(@"loadUsers fail, rc = %d",rc);
    }
    
    sqlite3_close(db);
    if([modelClass isInSystemDB]) {
        pthread_mutex_unlock(&_systemDBMutex);
    } else {
        pthread_mutex_unlock(&_userDBMutex);
    }
//    EXIT_FUNC;
    return ret;
}

-(long)getTableDataCount:(Class)modelClass Condition:(NSString*)condition {
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"select count(*) from %@ ", [modelClass getTableName]];
    if(condition != nil && condition.length > 0) {
        [sql appendString:@" where "];
        [sql appendString:condition];
    }
    
    //    ENTER_FUNC;
    NSInteger ret = 0;
    sqlite3 *db = nil;
    if([modelClass isInSystemDB]) {
        db = [self getSystemDB];
        pthread_mutex_lock(&_systemDBMutex);
    } else {
        db = [self getUserDB];
        pthread_mutex_lock(&_userDBMutex);
    }
    
    sqlite3_stmt *stmt;
    int rc = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    if (rc == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            ret = (long)sqlite3_column_int64(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }
    else
    {
        NSLog(@"loadUsers fail, rc = %d",rc);
    }
    
    sqlite3_close(db);
    if([modelClass isInSystemDB]) {
        pthread_mutex_unlock(&_systemDBMutex);
    } else {
        pthread_mutex_unlock(&_userDBMutex);
    }
    //    EXIT_FUNC;
    return ret;
    
}

-(BOOL)cleanTableData:(Class)modelClass
{
    return [self cleanTableData:modelClass Condition:@""];
}

-(BOOL)cleanTableData:(Class)modelClass PrimaryKey:(long)pk
{
    return [self cleanTableData:modelClass Condition:[NSString stringWithFormat:@" where %@=%ld", [modelClass getPrimaryKey], pk]];
}
-(BOOL)cleanTableData:(Class)modelClass withStringPrimaryKey:(NSString *)pk
{
    return [self cleanTableData:modelClass Condition:[NSString stringWithFormat:@" where %@='%@'", [modelClass getPrimaryKey], pk]];
}

-(BOOL)cleanTableData:(Class)modelClass Condition:(NSString*)condition
{
    //    ENTER_FUNC;
    BOOL ret = NO;
    
    sqlite3 *db = nil;
    if([modelClass isInSystemDB]) {
        db = [self getSystemDB];
        pthread_mutex_lock(&_systemDBMutex);
    } else {
        db = [self getUserDB];
        pthread_mutex_lock(&_userDBMutex);
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ %@", [modelClass getTableName], condition];
    
//    int rc = sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL);
    
    int rc = sqlite3_exec(db, "BEGIN;", 0, 0, nil);
    
    rc = sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL);
    
    rc = sqlite3_exec(db, "COMMIT;", 0, 0, nil);
    
    if (rc == SQLITE_OK)
    {
        ret = YES;
    }
    else
    {
        NSLog(@"clean %@ fail, rc = %d", [modelClass getTableName], rc);
        ret = NO;
    }
    
    sqlite3_close(db);
    if([modelClass isInSystemDB]) {
        pthread_mutex_unlock(&_systemDBMutex);
    } else {
        pthread_mutex_unlock(&_userDBMutex);
    }
    //    EXIT_FUNC;
    
    return ret;
}

-(BOOL)saveData:(BaseModel*)model
{
    BOOL ret = YES;
//    ENTER_FUNC;
    
    sqlite3 *db = nil;
    if([[model class] isInSystemDB]) {
        db = [self getSystemDB];
        pthread_mutex_lock(&_systemDBMutex);
    } else {
        db = [self getUserDB];
        pthread_mutex_lock(&_userDBMutex);
    }
    
    NSString *sql = [model.class getInsertDataSQL:model];
    
    //创建Informations表
    if (![[model class] isInSystemDB]) {
        NSString * creatInformations = @"CREATE TABLE  IF NOT EXISTS Informations(itemValue text,itemName text PRIMARY KEY,deleted integer,updateTime integer)";
        char *errMessage;
        int result = sqlite3_exec(db, [creatInformations UTF8String], NULL, NULL, &errMessage);
        if (result != SQLITE_OK)
        {
            NSLog(@"%s fail, rc = %d, reason = %s , sql = %@",__FUNCTION__ ,result, errMessage, creatInformations);
        }
    }
    
    int rc = sqlite3_exec(db, "BEGIN;", 0, 0, nil);
    
    
    rc = sqlite3_exec(db, [sql UTF8String], NULL, NULL, nil);
    
    rc = sqlite3_exec(db, "COMMIT;", 0, 0, nil);
    
    if (rc != SQLITE_OK)
    {
        NSLog(@"%s fail, rc=%d",__FUNCTION__, rc);
        ret = NO;
    }
    
    sqlite3_close(db);
    
    if([[model class] isInSystemDB]) {
        pthread_mutex_unlock(&_systemDBMutex);
    } else {
        pthread_mutex_unlock(&_userDBMutex);
    }
//    EXIT_FUNC;
    
    return ret;
}

-(BOOL)saveData:(NSArray*)modelArray modelClass:(Class)modelClass
{
    BOOL ret = YES;
//    ENTER_FUNC;
    
    sqlite3 *db = nil;
    if([modelClass isInSystemDB]) {
        db = [self getSystemDB];
        pthread_mutex_lock(&_systemDBMutex);
    } else {
        db = [self getUserDB];
        pthread_mutex_lock(&_userDBMutex);
    }
    
    NSMutableString *sql = [[NSMutableString alloc]init];
    for(BaseModel *model in modelArray) {
        [sql appendFormat:@"%@;", [modelClass getInsertDataSQL:model]];
    }
    
    int rc = sqlite3_exec(db, "BEGIN;", 0, 0, nil);
    
    rc = sqlite3_exec(db, [sql UTF8String], NULL, NULL, nil);
    
    rc = sqlite3_exec(db, "COMMIT;", 0, 0, nil);
    
    if (rc != SQLITE_OK)
    {
        NSLog(@"%s fail, rc=%d",__FUNCTION__, rc);
        ret = NO;
    }
    
    sqlite3_close(db);
    
    if([modelClass isInSystemDB]) {
        pthread_mutex_unlock(&_systemDBMutex);
    } else {
        pthread_mutex_unlock(&_userDBMutex);
    }
//    EXIT_FUNC;
    
    return ret;
}

#pragma mark - singleton method
+(DBManager *)sharedInstance {
    if (_sharedInstance == nil) {
        @synchronized(self) {
            _sharedInstance = [[DBManager alloc] init];
        }
    }
    
    return _sharedInstance;
}

-(id)init {
    if(self=[super init]) {
        _delegates = (GCDMulticastDelegate<DBManagerDelegate> *)[[GCDMulticastDelegate alloc] init];
        
        [self generateDBDefine];
        
        _isSystemDBInitialized = NO;
        _isUserDBInitialized = NO;
        
        pthread_mutex_init(&_systemDBMutex, NULL);
        pthread_mutex_init(&_userDBMutex, NULL);
    }
    
    return self;
}

#pragma mark - delegates management
-(void)addDelegate:(id<DBManagerDelegate>)delegate
{
    @synchronized(_delegates) {
        [_delegates addDelegate:delegate
                  delegateQueue:dispatch_get_main_queue()];
    }
}

-(void)removeDelegate:(id<DBManagerDelegate>)delegate
{
    @synchronized(_delegates) {
        [_delegates removeDelegate:delegate];
    }
}
#pragma mark - information methods
-(void)saveInformationItem:(NSString*)key value:(NSString*)value{
    Informations *info = [[DBManager sharedInstance]loadTableFirstData:[Informations class] Condition:[NSString stringWithFormat:@" where itemName = '%@'", key]];
    if(!info) {
        info = [[Informations alloc]init];
        info.itemName = key;
    }
    info.itemValue = [NSString stringWithFormat:@"%@", value];
    [[DBManager sharedInstance] saveData:info];
}

-(NSString*)getInformationItem:(NSString*)key defaultValue:(NSString*)defaultValue {
    NSString *value = [self getInformationItem:key];
    if (value) {
        return value;
    }
    return defaultValue;
}

-(NSString*)getInformationItem:(NSString*)key{
    Informations *info = [[DBManager sharedInstance]loadTableFirstData:[Informations class] Condition:[NSString stringWithFormat:@" where itemName = '%@'", key]];
    if(info) {
        return info.itemValue;
    }
    return nil;
}

-(void)saveLongInformationItem:(NSString*)key longValue:(long long)value{
    [self saveInformationItem:key value:[NSString stringWithFormat:@"%lld",value]];
}
-(long long)getLongInformationItem:(NSString*)key{
    long long longValue = 0;
    NSString *strValue = [self getInformationItem:key];
    if (strValue) {
        longValue = [strValue longLongValue];
    }
    return longValue;
}

@end
