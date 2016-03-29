//
//  NSAttributedString+EmojiExtension.m
//  ImageTextView
//
//  Created by GeekRRK on 16/3/29.
//  Copyright © 2016年 GeekRRK. All rights reserved.
//

#import "NSAttributedString+EmojiExtension.h"

@implementation NSAttributedString (EmojiExtension)

- (NSString *)getPlainString {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;

    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];

                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                      }
                  }];
    
    return plainString;
}

@end
