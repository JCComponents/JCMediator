//
//  JCMediator.h
//  JCMediator_Example
//
//  Created by JC on 2018/5/22.
//  Copyright © 2018年 lswh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCMediator : NSObject

+ (instancetype)sharedInstance;

/**
 本地组件调用入口
 
 @param targetName target名
 @param actionName action名
 @param params  杰   参数
 
 @return id
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;

/**
 本地组件调用入口(支持缓存，可高频调用)
 
 @param targetName target名
 @param actionName action名
 @param params     参数
 @param bShouldCacheTarget 是否缓存Target(设为YES,可支持高频调用，避免频繁调用组件方法时产生的alloc开销)
 @return id
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)bShouldCacheTarget;

/**
 释放target缓存

 @param targetName 要释放的target名称
 */
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

@end
