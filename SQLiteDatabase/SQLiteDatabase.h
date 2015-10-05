//
//  SQLDatabase.h
//
//  Created by Sergo Beruashvili on 10/2/13.
//  Copyright (c) 2013 Sergo Beruashvili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "SQLiteResult.h"
#import "SQLiteRow.h"

@class SQLiteResult;

@interface SQLiteDatabase : NSObject

+ (instancetype)sharedInstance;
+ (instancetype)databaseWithFileName:(NSString *)name;
- (instancetype)initWithFileName:(NSString *)name;

@property (nonatomic,readonly) NSString *databaseFileName;

//set this before accessing the actual database file itself
@property (nonatomic) BOOL includeInICloudBackup;

/**
 * Sets current instance as sharedInstance
 */
- (instancetype)setAsSharedInstance;

/**
 *  is used for SELECT something from database
 *
 *  @param query   SQL statement string , may contain parameters params to bind
 *  @param params  Dictionary of parameters , if query contains any bind-able params , currently may contain NSString and NSNumber objects , might be nil
 *  @param success callback block after query finishes successfully
 *  @param failure callback block if query fails
 */
-(void)executeQuery:(NSString *)query
         withParams:(NSDictionary *)params
            success:(void(^)(SQLiteResult *result))success
            failure:(void(^)(NSString *errorMessage))failure;


/**
 *  is used for INSERT/UPDATE/DELETE something from database
 *
 *  @param query   SQL statement string , may contain parameters params to bind
 *  @param params  Dictionary of parameters , if query contains any bind-able params , currently may contain NSString and NSNumber objects , might be nil
 *  @param success callback block after query finishes successfully
 *  @param failure callback block if query fails
 */
-(void)executeUpdate:(NSString *)query
          withParams:(NSDictionary *)params
             success:(void(^)(SQLiteResult *result))success
             failure:(void(^)(NSString *errorMessage))failure;

@end



