//
//  NSString+ZXAdd.m
//  ZXtouchView
//
//  Created by 朱志先 on 16/6/13.
//  Copyright © 2016年 朱志先. All rights reserved.
//

#import "NSString+ZXAdd.h"


@implementation NSString (ZXAdd)

- (CGFloat)pathScale {
    if (self.length == 0 || [self hasSuffix:@"/"]) return 1;
    NSString *name = self.stringByDeletingPathExtension;
    __block CGFloat scale = 1;
    [name enumerateRegexMatches:@"@[0-9]+\\.?[0-9]*x$" options:NSRegularExpressionAnchorsMatchLines usingBlock: ^(NSString *match, NSRange matchRange, BOOL *stop) {
        scale = [match substringWithRange:NSMakeRange(1, match.length - 2)].doubleValue;
    }];
    return scale;
}
- (void)enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block {
    if (regex.length == 0 || !block) return;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!regex) return;
    [pattern enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([self substringWithRange:result.range], result.range, stop);
    }];
}

- (NSString *)stringByAppendingPathScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    NSString *ext = self.pathExtension;
    NSRange extRange = NSMakeRange(self.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
    return [self stringByReplacingCharactersInRange:extRange withString:scaleStr];
}

- (NSString *)adaptiveImageName
{
    if (self.pathScale > 1) {
        return self;
    }
    NSArray *scales = [NSBundle preferredScales];
    CGFloat scale = ((NSNumber *)scales[0]).floatValue;
    
    return [self stringByAppendingPathScale:scale];
}

+ (NSString *)adaptiveImagePathWithFullImageName:(NSString *)fullImageName
{
    return [[NSBundle mainBundle] pathForResource:[fullImageName adaptiveImageName] ofType:nil];
}

- (NSString *)adaptiveImagePath
{
    return [[NSBundle mainBundle] pathForResource:[self adaptiveImageName] ofType:nil];
}

+ (NSString *)filePathWithfileName:(NSString *)fileName Type:(NSString *)type
{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:type];
}

@end
