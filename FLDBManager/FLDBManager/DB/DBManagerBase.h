
#import <Foundation/Foundation.h>
#import "DBManagerDelegate.h"
#import "GCDMulticastDelegate.h"
#import "BaseModel.h"
#import <sqlite3.h>

@interface DBManager : NSObject {
    NSDictionary *_dbDef;
    
    GCDMulticastDelegate<DBManagerDelegate> *_delegates;
    
    pthread_mutex_t _systemDBMutex;
    pthread_mutex_t _userDBMutex;
}

#pragma mark - singleton method
+(DBManager *)sharedInstance;

#pragma mark - base api
-(void)addDelegate:(id<DBManagerDelegate>)delegate;
-(void)removeDelegate:(id<DBManagerDelegate>)delegate;

-(sqlite3*) getSystemDB;
-(sqlite3*) getUserDB;

- (BOOL)deleteCurrentUserDB;

-(void) enterLogoffState;

-(void)updateTableData:(Class)modelClass UpdateColumns:(NSString *)columns;
-(void)updateTableData:(Class)modelClass UpdateColumns:(NSString *)columns Condition:(NSString*)condition;

-(id)loadTableFirstData:(Class)modelClass Condition:(NSString*)condition;

-(NSArray*)loadTableData:(Class)modelClass;
-(NSArray*)loadTableData:(Class)modelClass Condition:(NSString*)condition;
-(NSArray*)loadTableCloumnData:(Class)modelClass andCloumnName:(NSString *)cloumnName andIsDistinct:(BOOL)isDistinct Condition:(NSString*)condition;

-(long)getTableDataCount:(Class)modelClass Condition:(NSString*)condition;

-(BOOL)cleanTableData:(Class)modelClass;
-(BOOL)cleanTableData:(Class)modelClass PrimaryKey:(long)pk;
-(BOOL)cleanTableData:(Class)modelClass withStringPrimaryKey:(NSString *)pk;
-(BOOL)cleanTableData:(Class)modelClass Condition:(NSString*)condition;

-(BOOL)saveData:(BaseModel*)model;
-(BOOL)saveData:(NSArray*)modelArray modelClass:(Class)modelClass;

-(void)saveInformationItem:(NSString*)key value:(NSString*)value;
-(NSString*)getInformationItem:(NSString*)key;
-(NSString*)getInformationItem:(NSString*)key defaultValue:(NSString*)defaultValue;

-(void)saveLongInformationItem:(NSString*)key longValue:(long long)value;
-(long long)getLongInformationItem:(NSString*)key;
@end
