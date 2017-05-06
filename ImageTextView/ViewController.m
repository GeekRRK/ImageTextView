//
//  ViewController.m
//  ImageTextView
//
//  Created by GeekRRK on 16/3/29.
//  Copyright © 2016年 GeekRRK. All rights reserved.
//

#import "ViewController.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgTxtView.delegate = self;
}

- (int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (CGSize)fitsize:(CGSize)thisSize byFixedSize:(CGSize)fixedSize {
    if(thisSize.width == 0 && thisSize.height == 0) {
        return CGSizeMake(0, 0);
    }
    
    CGFloat wscale = thisSize.width / fixedSize.width;
    CGFloat hscale = thisSize.height / fixedSize.height;
    CGFloat scale = (wscale > hscale) ? wscale : hscale;
    CGSize newSize = CGSizeMake(thisSize.width / scale, thisSize.height / scale);
    
    return newSize;
}

- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (void)appendImg:(UIImage *)img {
    EmojiTextAttachment *attachment = [[EmojiTextAttachment alloc] init];
    attachment.emojiTag = [NSString stringWithFormat:@"%d", [self getRandomNumber:1 to:1000]];
    attachment.image = img;
    NSAttributedString *attributeStr = [NSAttributedString attributedStringWithAttachment:attachment];
    [self.imgTxtView.textStorage insertAttributedString:attributeStr atIndex:self.imgTxtView.selectedRange.location];
}

- (IBAction)cancelKeyBoard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)openAlbum:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
}

- (IBAction)post:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"帖子内容" message:[self.imgTxtView.textStorage getPlainString] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSData *imgData = UIImageJPEGRepresentation(image, 0);
    UIImage *img = [UIImage imageWithData:imgData];
    
    CGSize fixedSize = CGSizeMake(50, 50);
    CGSize scaleFixedSize = [self fitsize:img.size byFixedSize:fixedSize];
    UIImage *newImg = [self originImage:img scaleToSize:scaleFixedSize];
    
    [self appendImg:newImg];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
