//
//  ViewController.m
//  文件的本地缓存方式
//
//  Created by t3 on 17/1/3.
//  Copyright © 2017年 feyddy. All rights reserved.
//

#import "ViewController.h"
#import "FDPerson.h"
#import "FMDB.h"

@interface ViewController ()
{
    FMDatabase *db;
}
@end

/**
 *  本地缓存数据的方式：
 1.直接写文件方式：可以存储的对象有NSString、NSArray、NSDictionary、NSData、NSNumber，数据全部存放在一个属性列表文件（*.plist文件）中。
 
 2.NSUserDefaults（偏好设置），用来存储应用设置信息，文件放在perference目录下。
 
 3.归档操作（NSkeyedArchiver），不同于前面两种，它可以把自定义对象存放在文件中。
 
 4.coreData:coreData是苹果官方iOS5之后推出的综合型数据库，其使用了ORM(Object Relational Mapping)对象关系映射技术，将对象转换成数据，存储在本地数据库中。coreData为了提高效率，甚至将数据存储在不同的数据库中，且在使用的时候将本地数据放到内存中使得访问速度更快。我们可以选择coreData的数据存储方式，包括sqlite、xml等格式。但也正是coreData 是完全面向对象的，其在执行效率上比不上原生的数据库。除此之外，coreData拥有数据验证、undo等其他功能，在功能上是几种持久化方案最多的。
 
 5.FMDB：FMDB是iOS平台的SQLite数据库框架，FMDB以OC的方式封装了SQLite的C语言API，使用起来更加面向对象，省去了很多麻烦、冗余的C语言代码，对比苹果自带的Core Data框架，更加轻量级和灵活，提供了多线程安全的数据库操作方法，有效地防止数据混乱。
 

 
 documents，tmp，app，Library。
 
 （NSHomeDirectory()），
 
 手动保存的文件在documents文件里
 
 Nsuserdefaults保存的文件在tmp文件夹里
 
 
 
 1、Documents 目录：您应该将所有de应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息。
 
 2、AppName.app 目录：这是应用程序的程序包目录，包含应用程序的本身。由于应用程序必须经过签名，所以您在运行时不能对这个目录中的内容进行修改，否则可能会使应用程序无法启动。
 
 3、Library 目录：这个目录下有两个子目录：Caches 和 Preferences
 Preferences 目录：包含应用程序的偏好设置文件。您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好.
 Caches 目录：用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。
 
 4、tmp 目录：这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。
 
 */


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    [self NSKeyedArchiverWay];
    [self FMDBWay];
    

}

#pragma mark - 直接写入plist文件
- (void)directWriteOfFirstWayCaches {
    //获取沙盒中缓存文件夹路径
    
    //沙盒主目录
    
    NSString *homePath = NSHomeDirectory();
    
    //拼接路径
    
    NSString *path = [homePath stringByAppendingPathComponent:@"Library/Caches"];
    
    //拼接路径（目标路径），这个时候如果目录下不存在这个lotheve.plist文件，这个目录实际上是不存在的。
    
    NSString *filePath = [path stringByAppendingPathComponent:@"test.plist"];
//
    NSLog(@"%@",filePath);
    
    //创建数据
    
    NSDictionary *content = @{@"dictionary1":@"1",@"dictionary2":@"2",@"dictionary3":@"3"};
    
    //将数据存到目标路径的文件中(这个时候如果该路径下文件不存在将会自动创建)
    
    //用writeToFile方法写文件会覆盖掉原来的内容
    
    [content writeToFile:filePath atomically:YES];
    
    //读取数据(通过字典的方式读出文件中的内容)
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSLog(@"%@",dic);
}


- (void)directWriteOfSecondWayCaches {
    //获取沙盒中缓存文件夹路径

    //第一个参数目标文件夹目录（NSCachesDirectory查找缓存文件夹），第二个参数为查找目录的域（NSUserDomainMask为在用户目录下查找），第三个参数为结果中主目录是否展开，不展开则显示为~

    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    //虽然该方法返回的是一个数组，但是由于一个目标文件夹只有一个目录，所以数组中只有一个元素。

    NSString *cachePath = [arr lastObject];
    
//    NSString *cachePath = [arr objectAtIndex:0];//或者使用这个方法

    
    //拼接路径（目标路径），这个时候如果目录下不存在这个lotheve.plist文件，这个目录实际上是不存在的。
    
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"test1.plist"];
    //
    NSLog(@"%@",filePath);
    
    //创建数据
    
    NSDictionary *content = @{@"dictionary1":@"1",@"dictionary2":@"2",@"dictionary3":@"3"};
    
    //将数据存到目标路径的文件中(这个时候如果该路径下文件不存在将会自动创建)
    
    //用writeToFile方法写文件会覆盖掉原来的内容
    
    [content writeToFile:filePath atomically:YES];
    
    //读取数据(通过字典的方式读出文件中的内容)
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSLog(@"%@",dic);
}

- (void)directWriteOfTmp {
    NSString *tmpPath = NSTemporaryDirectory();
    
    NSLog(@"%@",tmpPath);
    
    NSString *filePath = [tmpPath stringByAppendingPathComponent:@"test3.plist"];
    //
    NSLog(@"%@",filePath);
    
    //创建数据
    
    NSDictionary *content = @{@"dictionary1":@"1",@"dictionary2":@"2",@"dictionary3":@"3"};
    
    //将数据存到目标路径的文件中(这个时候如果该路径下文件不存在将会自动创建)
    
    //用writeToFile方法写文件会覆盖掉原来的内容
    
    [content writeToFile:filePath atomically:YES];
    
    //读取数据(通过字典的方式读出文件中的内容)
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSLog(@"%@",dic);
    
}

- (void)directWriteOfDocuments {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *filePath = [docDir stringByAppendingPathComponent:@"test4.plist"];
    //
    NSLog(@"%@",filePath);
    
    //创建数据
    
    NSDictionary *content = @{@"dictionary1":@"1",@"dictionary2":@"2",@"dictionary3":@"3"};
    
    //将数据存到目标路径的文件中(这个时候如果该路径下文件不存在将会自动创建)
    
    //用writeToFile方法写文件会覆盖掉原来的内容
    
    [content writeToFile:filePath atomically:YES];
    
    //读取数据(通过字典的方式读出文件中的内容)
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSLog(@"%@",dic);
    
}



#pragma mark - NSUserDefaults(偏好设置)
/**
 *  每个应用都有一个NSUesrDefaults实例，通过它可以存储应用配置信息以及用户信息，比如保存用户名、密码、字体大小、是否自动登录等等。数据自动保存在沙盒的Libarary/Preferences目录下。同样，该方法只能存取NSString、NSArray、NSDictionary、NSData、NSNumber类型的数据。
    在程序启动后，系统会自动创建一个NSUserDefaults的单例对象，我们可以获取这个单例来存储少量的数据，它会将输出存储在.plist格式的文件中。其优点是像字典一样的赋值方式方便简单，但缺点是无法存储自定义的数据。
 */
- (void)nsuserDefaultsWay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //存数据，不需要设置路劲，NSUserDefaults将数据保存在preferences目录下
    
    [userDefaults setObject:@"Lotheve" forKey:@"name"];
    
    [userDefaults setObject:@"NSUserDefaults" forKey:@"demo"];
    
    //立刻保存（同步）数据（如果不写这句话，会在将来某个时间点自动将数据保存在preferences目录下）
    
    [userDefaults synchronize];

    [self getData];

}

- (void)getData {
    //获取NSUserDefaults对象
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //读取数据
    
    NSString *name = [userDefaults objectForKey:@"name"];
    
    NSString *demo = [userDefaults objectForKey:@"demo"];
    
    //打印数据
    
    NSLog(@"name = %@ demo =%@",name,demo);
    
}



#pragma mark - NSKeyedArchiver（文件归档）
/**
 *  数据归档是进行加密处理的，数据在经过归档处理会转换成二进制数据，所以安全性要远远高于属性列表。另外使用归档方式，我们可以将复杂的对象写入文件中，并且不管添加多少对象，将对象写入磁盘的方式都是一样的。
    使用NSKeyedArchiver对自定义的数据进行序列化，并且保存在沙盒目录下。使用这种归档的前提是让存储的数据模型遵守NSCoding协议并且实现其两个协议方法。（当然，如果为了更加安全的存储，也可以遵守NSSecureCoding协议，这是iOS6之后新增的特性）
 
    使用归档操作存储数据的主要好处是，不同于前面两种方法只能存储几个常用的数据类型的数据，NSKeyedArchiver可以存储自定义的对象。

 */
- (void)NSKeyedArchiverWay {
    
    FDPerson *p = [[FDPerson alloc] init];
    p.name = @"Feyddy";
    p.age = 24;
    p.sex = @"M";
    p.familyMumbers = @[@"GrandFather",@"GrandMother",@"Father",@"Mother",@"Me"];
    
    
    //获取文件路径
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //文件类型可以随便取，不一定要正确的格式
    
    NSString *targetPath = [docPath stringByAppendingPathComponent:@"lotheve.plist"];
    NSLog(@"%@",targetPath);
    
    //将自定义对象保存在指定路径下
    
    [NSKeyedArchiver archiveRootObject:p toFile:targetPath];
    
    NSLog(@"文件已储存");
    
    [self getDataByNSKeyedArchiverWay];

    
}

- (void)getDataByNSKeyedArchiverWay
{
    //获取文件路径
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *targetPath = [docPath stringByAppendingPathComponent:@"lotheve.plist"];
    
    FDPerson *person = [NSKeyedUnarchiver unarchiveObjectWithFile:targetPath];
    
    NSLog(@"name = %@ , age =%ld , sex = %@ , familyMubers = %@",person.name,person.age,person.sex,person.familyMumbers);
    
    NSLog(@"文件已提取");

}


#pragma mark - coreData(比较麻烦)
/**
 *  coreData是iOS5之后苹果推出的数据持久化框架，其提供了ORM的功能，将对象和数据相互转换。其中，它提供了包括sqlite、xml、plist等本地存储文件，默认使用sqlite进行存储。coreData具有两个模型：关系模型和对象模型，关系模型即是数据库，对象模型为OC对象。
     由于我们不需要关心数据的存储，coreData使用起来算是最简单的持久化方案。要使用coreData有两个方式，一个是在创建项目的时候勾选use core data，另一个则是手动创建。
 
 可以参考：http://www.jianshu.com/p/72c12b0e55f3
 */



#pragma mark - FMDB(必须导入：libsqlite3)
/**
 *  优点:
 
 对多线程的并发操作进行处理，所以是线程安全的；
 
 以OC的方式封装了SQLite的C语言API，使用起来更加的方便；
 
 FMDB是轻量级的框架，使用灵活。
 
    缺点:
 
 因为它是OC的语言封装的，只能在ios开发的时候使用，所以在实现跨平台操作的时候存在局限性。
 
 ****FMDB有三个主要的类*****
 
 （1）FMDatabase
 
 一个FMDatabase对象就代表一个单独的SQLite数据库
 
 用来执行SQL语句
 
 （2）FMResultSet
 
 使用FMDatabase执行查询后的结果集
 
 （3）FMDatabaseQueue
 
 用于在多线程中执行多个查询或更新，它是线程安全的
 
 这里建议使用CocoaPods导入FMDB,但是我这里就不使用pod了
 */
- (void)FMDBWay {
    NSString *database_path;
    /**
     *  
     1、当数据库文件不存在时，fmdb会自己创建一个。
     
     2、 如果你传入的参数是空串：@"" ，则fmdb会在临时文件目录下创建这个数据库，数据库断开连接时，数据库文件被删除。
     
     3、如果你传入的参数是 NULL，则它会建立一个在内存中的数据库，数据库断开连接时，数据库文件被删除。
     */
    db = [FMDatabase databaseWithPath:database_path];
    
    //打开数据库：返回BOOL型。
    
    [db open];
    
    
    //关闭数据库：
    
//    [db close];
    
    
    //数据库增删改等操作:除了查询操作，FMDB数据库操作都执行executeUpdate方法，这个方法返回BOOL型。
    [self createTable];
    
    [self addData];
    
    [self changeData];
    
    [self deleteData];
    
    [self searchData];
    
    /**
     *  如果应用中使用了多线程操作数据库，那么就需要使用FMDatabaseQueue来保证线程安全了。 应用中不可在多个线程中共同使用一个FMDatabase对象操作数据库，这样会引起数据库数据混乱。 为了多线程操作数据库安全，FMDB使用了FMDatabaseQueue，使用FMDatabaseQueue很简单，首先用一个数据库文件地址来初使化FMDatabaseQueue，然后就可以将一个闭包(block)传入inDatabase方法中。 在闭包中操作数据库，而不直接参与FMDatabase的管理。
     *
     *
     */
    
    //[self multipuleWay];
    
    
    
    
}

- (void)createTable {
    if([db open]) {
        
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' INTEGER, '%@' TEXT)",@"tableName",@"id",@"name",@"age",@"address"];
        
        BOOL res = [db executeUpdate:sqlCreateTable];
        
        if(!res) {
            
            NSLog(@"error when creating db table");
            
        }else{
            
            NSLog(@"success to creating db table");
            
        }
        
//        [db close];
        
    }
}

- (void)addData {
    if([db open]) {
        
        NSString *insertSql1= [NSString stringWithFormat:
                               
                               @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                               
                               @"tableName",@"name",@"age",@"address", @"张三", @"13", @"济南"];
        
        BOOL res = [db executeUpdate:insertSql1];
        
        NSString *insertSql2 = [NSString stringWithFormat:
                                
                                @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                                
                                 @"tableName",@"name",@"age",@"address", @"李四", @"12", @"济南"];
        
        BOOL res2 = [db executeUpdate:insertSql2];
        
        if(!res||!res2) {
            
            NSLog(@"error when insert db table");
            
        }else{
            
            NSLog(@"success to insert db table");
            
        }
        
//        [db close];
        
    }
}

- (void)changeData {
    
    if([db open]) {
        
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE '%@' SET '%@' = '%@' WHERE '%@' = '%@'",
                               @"tableName", @"age", @"15", @"age", @"13"];
        
        BOOL res = [db executeUpdate:updateSql];
        
        if(!res) {
            
            NSLog(@"error when update db table");
            
        }else{
            
            NSLog(@"success to update db table");
            
        }
        
//        [db close];
        
    }
}

- (void)deleteData {
    
    if([db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               
                               @"delete from %@ where %@ = '%@'",
                               
                               @"tableName", @"name", @"张三"];
        
        BOOL res = [db executeUpdate:deleteSql];
        
        if(!res) {
            
            NSLog(@"error when delete db table");
            
        }else{
            
            NSLog(@"success to delete db table");
            
        }
        
//        [db close];
        
    }
}

- (void)searchData {
    
    //查询操作使用了executeQuery，并涉及到FMResultSet。
    
    if([db open]) {
        
        NSString * sql = [NSString stringWithFormat:
                          
                          @"SELECT * FROM %@",@"tableName"];
        
        FMResultSet * rs = [db executeQuery:sql];
        
        while([rs next]) {
            
            int intId = [rs intForColumn:@"id"];
            
            NSString * name = [rs stringForColumn:@"name"];
            
            NSString * age = [rs stringForColumn:@"age"];
            
            NSString * address = [rs stringForColumn:@"address"];
            
            NSLog(@"id = %d, name = %@, age = %@  address = %@", intId, name, age,address);
            
        }
        
//        [db close];
        
    }
    
    /**
     *  FMDB的FMResultSet提供了多个方法来获取不同类型的数据
     *
     *  @return <#return value description#>
     */
}

- (void)multipuleWay {
    NSString *database_path;
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:database_path];
    
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    dispatch_async(q1, ^{
        
        for(int i = 0; i < 50; ++i) {
            
            [queue inDatabase:^(FMDatabase *db2) {
                
                NSString *insertSql1= [NSString stringWithFormat:
                                       
                                       @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES (?, ?, ?)",
                                       
                                        @"tableName",@"name",@"age",@"address"];
                
                NSString * name = [NSString stringWithFormat:@"jack %d", i];
                
                NSString * age = [NSString stringWithFormat:@"%d", 10+i];
                
                BOOL res = [db2 executeUpdate:insertSql1, name, age,@"济南"];
                
                if(!res) {
                    
                    NSLog(@"error to inster data: %@", name);
                    
                }else{
                    
                    NSLog(@"succ to inster data: %@", name);
                    
                }
                
            }];
            
        }
        
    });
    
    dispatch_async(q2, ^{
        
        for(int i = 0; i < 50; ++i) {
            
            [queue inDatabase:^(FMDatabase *db2) {
                
                NSString *insertSql2= [NSString stringWithFormat:
                                       
                                       @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES (?, ?, ?)",
                                       
                                        @"secondTableName",@"name",@"age",@"address"];
                
                NSString * name = [NSString stringWithFormat:@"lilei %d", i];
                
                NSString * age = [NSString stringWithFormat:@"%d", 10+i];
                
                BOOL res = [db2 executeUpdate:insertSql2, name, age,@"北京"];
                
                if(!res) {
                    
                    NSLog(@"error to inster data: %@", name);
                    
                }else{
                    
                    NSLog(@"succ to inster data: %@", name);
                    
                }
                
            }];
            
        }
        
    });
}

@end
