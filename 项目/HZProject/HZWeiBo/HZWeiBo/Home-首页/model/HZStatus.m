//
//  HZStatus.m
//  HZWeiBo
//
//  Created by 华天杰 on 2018/10/15.
//  Copyright © 2018年 BQ. All rights reserved.
//

#import "HZStatus.h"
#import <MJExtension.h>
#import "HZPhoto.h"
#import "NSDate+HZ.h"

@implementation HZStatus

+(NSDictionary*)mj_objectClassInArray{
    return @{@"pic_urls" :@"HZPhoto"};
}

/**
 *  修正微博的发送时间
 */
- (NSString *)created_at
{
    // 获取微博发送时间 Fri May 09 16:30:34 +0800 2014
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locale];
    
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate *createdDate = [formatter dateFromString:_created_at];
    
    // 判断
    if (createdDate.isToday) { // 今天以内
        if (createdDate.deltaToNow.hour >= 1) { // 1个小时以前
            return [NSString stringWithFormat:@"%d小时前", createdDate.deltaToNow.hour];
        } else if (createdDate.deltaToNow.minute >= 1) { // 1分钟以前
            return [NSString stringWithFormat:@"%d分钟前", createdDate.deltaToNow.minute];
        } else { // 1分钟以内
            return @"刚刚";
        }
    } else if (createdDate.isYesterday) { // 昨天以前
        formatter.dateFormat = @"昨天 HH:mm";
        return [formatter stringFromDate:createdDate];
    } else if (createdDate.isThisYear) { // 今年以内
        formatter.dateFormat = @"MM-dd HH:mm";
        return [formatter stringFromDate:createdDate];
    } else { // 去年以前
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:createdDate];
    }
}

/**
 *  修正微博的来源
 */
- (void)setSource:(NSString *)source
{
    if (source.length) {
        int location = [source rangeOfString:@">"].location + 1;
        int length = [source rangeOfString:@"</"].location - location;
        
        _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:NSMakeRange(location, length)]];
    } else {
        _source = @"未知来源";
    }
}
@end
