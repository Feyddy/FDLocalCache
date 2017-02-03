//
//  FDPerson.m
//  文件的本地缓存方式
//
//  Created by t3 on 17/1/3.
//  Copyright © 2017年 feyddy. All rights reserved.
//

#import "FDPerson.h"

@implementation FDPerson
#pragma mark - NSCoding协议方法 (一定要实现)

//当进行归档操作的时候就会调用该方法

//在该方法中要写清楚要存储对象的哪些属性

- (void)encodeWithCoder:(NSCoder *)aCoder

{
    
    NSLog(@"调用了encodeWithCoder方法");
    
    [aCoder encodeObject:_name forKey:@"name"];
    
    [aCoder encodeInteger:_age forKey:@"age"];
    
    [aCoder encodeObject:_sex forKey:@"sex"];
    
    [aCoder encodeObject:_familyMumbers forKey:@"familyMumbers"];
    
}

//当进行解档操作的时候就会调用该方法

//在该方法中要写清楚要提取对象的哪些属性

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"调用了initWithCoder方法");
    
    if (self = [super init]) {
        
        self.name = [aDecoder decodeObjectForKey:@"name"];
        
        self.age = [aDecoder decodeIntegerForKey:@"age"];
        
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        
        _familyMumbers = [aDecoder decodeObjectForKey:@"familyMumbers"];
        
    }
    return self;
    
}

/*
这里还要讲一下一个小技巧：使用static修饰来替代宏定义。上面的序列化中，我们可以看到NSCoding的协议方法中对数据进行序列化并且使用一个key来保存它。正常情况下我们可以使用宏来定义key，但是过多的宏定义在编译时也会造成大量的损耗。这时候可以使用static定义静态变量来取代宏定义。

static NSString * const kUserNameKey = @"userName";
*/

@end
