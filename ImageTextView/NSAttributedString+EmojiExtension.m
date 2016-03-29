//
//  NSAttributedString+EmojiExtension.m
//  ImageTextView
//
//  Created by UGOMEDIA on 16/3/29.
//  Copyright © 2016年 GeekRRK. All rights reserved.
//

#import "NSAttributedString+EmojiExtension.h"

@implementation NSAttributedString (EmojiExtension)

- (NSString *)getPlainString {
    //最终纯文本
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    
    //替换下标的偏移量
    __block NSUInteger base = 0;
    
    //遍历
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      //检查类型是否是自定义NSTextAttachment类
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          //替换
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          
                          //增加偏移量
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                      }
                  }];
    
    return plainString;
}

@end
