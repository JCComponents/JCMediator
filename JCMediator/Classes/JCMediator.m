//
//  JCMediator.m
//  JCMediator_Example
//
//  Created by JC on 2018/5/22.
//  Copyright © 2018年 lswh. All rights reserved.
//

#import "JCMediator.h"

@interface JCMediator ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation JCMediator

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params
{
    return [self performTarget:targetName action:actionName params:params shouldCacheTarget:NO];
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)bShouldCacheTarget
{
    NSString *targetClassStr = [NSString stringWithFormat:@"Target_%@",targetName];
    NSString *actionStr = nil;
    
    if (params != nil)
    {
        actionStr = [NSString stringWithFormat:@"Action_%@:",actionName];
    }
    else
    {
        actionStr = [NSString stringWithFormat:@"Action_%@",actionName];
    }
    
    Class targetClass = NSClassFromString(targetClassStr);
    id target = _cachedTarget[targetClassStr];
    if (!target) {
        target = [[targetClass alloc]init];
        if (bShouldCacheTarget) {
            //做target缓存，解决如cell刷新时频繁调用组件方法产生的alloc开销）
            self.cachedTarget[targetClassStr] = target;
        }
    }
    
    SEL action = NSSelectorFromString(actionStr);
    if(target == nil)
    {
        return nil;
    }
    if([target respondsToSelector:action])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        return [target performSelector:action withObject:params];
        
#pragma clang diagnostic pop
    }else
    {
        //无响应请求时，调用默认notFound方法
        SEL action = NSSelectorFromString(@"notFound:");
        if([target respondsToSelector:action])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            return [target performSelector:action withObject:params];
            
#pragma clang diagnostic pop
        }else
        {
            //notFound方法也无响应时
            return nil;
        }
    }
}

- (void)releaseCachedTargetWithTargetName:(NSString *)targetName
{
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    [_cachedTarget removeObjectForKey:targetClassString];
}

#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget
{
    if (_cachedTarget == nil) {
        _cachedTarget = [NSMutableDictionary dictionary];
    }
    return _cachedTarget;
}

@end
