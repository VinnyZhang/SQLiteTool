//
//  ViewController.m
//  SQLiteTool
//
//  Created by apple on 13-12-2.
//  Copyright (c) 2013年 SQLiteTool. All rights reserved.
//

#import "ViewController.h"
#import "sqlite3.h"

#define DataBase_1 @"gc20131129.sqlite"
#define  DataBase_2 @"FoundCitys5.sqlite"
#define  DataBase_3 @"FoundCitys1.sqlite"

@interface ViewController ()

@end

@implementation ViewController

@synthesize databasePath_1,databasePath_2,databasePath_3;


#pragma mark - life cycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    baseArray=[[NSMutableArray alloc] init];
    
//    [self readDatabase_hotel_city_town];
//    [self writeDatabase_hotel_city_town];
    
    [self sqliteToplist];
    
}

#pragma mark - 将sqlite导入到plist -

-(void)sqliteToplist{
    [self readDatabase_hotel_city_town];
    NSMutableArray *keys=[[NSMutableArray alloc] init];
    for (int i=0; i<[baseArray count]; i++) {
        NSMutableDictionary *tempDic=[baseArray objectAtIndex:i];
        NSString *keyStr=[tempDic objectForKey:@"pinyin"];

        NSString *key=[keyStr substringToIndex:1];
        
        BOOL haskey=NO;
        for (int i=0; i<[keys count]; i++) {
            if ([[keys objectAtIndex:i] isEqualToString:key]) {
                haskey=YES;
                break;
            }
        }
        if (!haskey) {
            [keys addObject:key];
        }
    }
    
    for (int i=0; i<[keys count]; i++) {
        for (int j=i; j<[keys count]; j++) {
            NSString *dic_j=[keys objectAtIndex:j];
            NSString *dic_i=[keys objectAtIndex:i];
            if ([dic_j compare:dic_i]==NSOrderedAscending) {
                [keys setObject:dic_j atIndexedSubscript:i];
                [keys setObject:dic_i atIndexedSubscript:j];
            }
        }
    }
    
    NSMutableDictionary *keyDic=[[NSMutableDictionary alloc] init];
    int count=0;
    for (int i=0; i<[keys count]; i++) {
        NSMutableArray *keyArray=[[NSMutableArray alloc] init];
        for (int j=0; j<[baseArray count]; j++) {
            NSDictionary *dic=[baseArray objectAtIndex:j];
            if ([[keys objectAtIndex:i] isEqualToString:[[dic objectForKey:@"pinyin"] substringToIndex:1]]) {
                [keyArray addObject:[dic objectForKey:@"name"]];
                count++;
            }
        }
        [keyDic setObject:keyArray forKey:[[keys objectAtIndex:i] uppercaseString]];
    }
    NSString *docs = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/hotel_cities.plist"] ;
    [keyDic writeToFile:docs atomically:YES];
    
}

#pragma mark - 读hotel_city_town表 -

-(void)readDatabase_hotel_city_town{
    
    [baseArray removeAllObjects];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.databasePath_1 = [documentsDirectory stringByAppendingPathComponent:DataBase_1];
    NSLog(@"==%@",self.databasePath_1);
    //打开或创建数据库
    sqlite3 *database;
    if (sqlite3_open([self.databasePath_1 UTF8String] , &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }
    //创建数据库表
    //    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS FIELDS (TAG INTEGER PRIMARY KEY, FIELD_DATA TEXT);";
    //    char *errorMsg;
    //    if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
    //        sqlite3_close(database);
    //        NSAssert(0, @"创建数据库表错误: %s", errorMsg);
    //    }
    //执行查询
    NSString *query = @"SELECT * FROM hotel_city_town";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //依次读取数据库表格FIELDS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] init];
            //获得数据
            int tag = sqlite3_column_int(statement, 0);
            char *rowData = (char *)sqlite3_column_text(statement, 1);
            NSString *provinceID=@"";
            [provinceID UTF8String];
            if (rowData!=NULL) {
                 provinceID= [[NSString alloc] initWithUTF8String:rowData];
                [tempDic setObject:provinceID forKey:@"provinceID"];
            }
            else
            {
                [tempDic setObject:provinceID forKey:@"provinceID"];
            }
            
            char *cityIDC=(char *) sqlite3_column_text(statement,2);
            NSString *cityID=@"";
            if (cityIDC!=NULL) {
                cityID=[[NSString alloc] initWithUTF8String:cityIDC];
                [tempDic setObject:cityID forKey:@"cityID"];
            }
            else{
                [tempDic setObject:@"" forKey:@"cityID"];
            }
            
            char *regionIDC=(char *)sqlite3_column_text(statement,3);
            NSString *regionID=@"";
            if (regionIDC!=NULL) {
                regionID=[[NSString alloc] initWithUTF8String:regionIDC];
                [tempDic setObject:regionID forKey:@"regionID"];
            }
            else{
                [tempDic setObject:regionID forKey:@"regionID"];
            }
            
            char *nameC=(char *)sqlite3_column_text(statement, 4);
            NSString *name=@"";
            if (nameC!=NULL) {
                name=[[NSString alloc] initWithUTF8String:nameC];
                [tempDic setObject:name forKey:@"name"];
            }
            else{
                [tempDic setObject:name forKey:@"name"];
            }
            char *pinyinC=(char *)sqlite3_column_text(statement, 5);
            NSString *pinyin=@"";
            if (pinyinC!=NULL) {
                pinyin=[[NSString alloc] initWithUTF8String:pinyinC];
                [tempDic setObject:pinyin forKey:@"pinyin"];
            }
            else{
                [tempDic setObject:pinyin forKey:@"pinyin"];
            }
            char *jianpinC=(char *)sqlite3_column_text(statement, 6);
            NSString *jianpin=@"";
            if (jianpinC!=NULL) {
                jianpin=[[NSString alloc] initWithUTF8String:jianpinC];
                [tempDic setObject:jianpin forKey:@"jianpin"];
            }
            else{
                [tempDic setObject:jianpin forKey:@"jianpin"];
            }
            
            [baseArray addObject:tempDic];
            NSLog(@"%i=%@==%@==%@==%@==%@==%@",tag,provinceID,cityID,regionID,name,pinyin,jianpin);
        }
        sqlite3_finalize(statement);
    }

}

#pragma mark -写ZHOTEL_CITY_TOWN-

-(void)writeDatabase_hotel_city_town{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.databasePath_3 = [documentsDirectory stringByAppendingPathComponent:DataBase_3];
    //打开或创建数据库
    sqlite3 *database;
    if (sqlite3_open([self.databasePath_3 UTF8String] , &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }

    if (sqlite3_open([self.databasePath_3 UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }
    //向表格插入数据
    for (int i=0; i<[baseArray count]; i++) {
        NSMutableDictionary *dic=[baseArray objectAtIndex:i];
        char *insert="INSERT OR REPLACE INTO ZHOTEL_CITY_TOWN (Z_ENT,Z_OPT,ZCITYID,ZJIANPIN,ZNAME,ZPINYIN,ZPROVINCEID,ZREGIONID) VALUES(?,?,?,?,?,?,?,?);";
        
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(database, insert, -1, &stmt, nil) == SQLITE_OK) {
//            sqlite3_bind_int(stmt, 1, i);
//            sqlite3_bind_text(stmt, 2, [textField.text UTF8String], -1, NULL);
            NSLog(@"=%@==%@==%@==%@==%@==%@",[dic objectForKey:@"cityID"],[dic objectForKey:@"jianpin"],[dic objectForKey:@"name"],[dic objectForKey:@"pinyin"],[dic objectForKey:@"provinceID"],[dic objectForKey:@"regionID"]);
            sqlite3_bind_int(stmt, 1, 8);
            sqlite3_bind_int(stmt, 2, 1);
            sqlite3_bind_text(stmt, 3, [[dic objectForKey:@"cityID"] UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4, [[dic objectForKey:@"jianpin"] UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 5, [[dic objectForKey:@"name"] UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 6, [[dic objectForKey:@"pinyin"] UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 7, [[dic objectForKey:@"provinceID"] UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 8, [[dic objectForKey:@"regionID"] UTF8String], -1, NULL);
        }
        char *errorMsg = NULL;
        if (sqlite3_step(stmt) != SQLITE_DONE)
            NSAssert(0, @"更新数据库表FIELDS出错: %s", errorMsg);
        sqlite3_finalize(stmt);
    }
    
    //关闭数据库
    sqlite3_close(database);
    
}

@end
