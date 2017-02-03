//
//  FDPerson.h
//  文件的本地缓存方式
//
//  Created by t3 on 17/1/3.
//  Copyright © 2017年 feyddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDPerson : NSObject<NSCoding>
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, strong) NSArray *familyMumbers;

@end
