//
//  imageTool.m
//  21days
//
//  Created by wjpMac on 16/7/19.
//  Copyright © 2016年 wjpMac. All rights reserved.
//

#import "imageTool.h"

@implementation imageTool

+ (UIImage *)cutImage:(UIImage*)image
{
    
   
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (390 / 272.32)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * 272.32 / 390;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * 390 / 272.32;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}
static NSData *data;
+ (NSString *) image2DataURL: (UIImage *) image{

    data = UIImageJPEGRepresentation(image, 1);
     
    NSLog(@"压缩前%fM",data.length / 1024.f / 1024.f);
     
     
     
     if (data.length>100*1024) {
         if (data.length>1024*1024) {//1M以及以上
             data=UIImageJPEGRepresentation(image, 0.1);
         }else if (data.length>512*1024) {//0.5M-1M
             data=UIImageJPEGRepresentation(image, 0.2);
         }else if (data.length>200*1024) {//0.25M-0.5M
             data=UIImageJPEGRepresentation(image, 0.5);
         }
         
     }
     
     NSLog(@"压缩后%fK",data.length / 1024.f);

 
    NSString *mimeType = nil;

    
    if ([self imageHasAlpha: image]) {
      
        mimeType = @"image/png";
    } else {
       
        mimeType = @"image/jpg";
    }
     NSLog(@"转码结束");
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [data base64EncodedStringWithOptions: 0]];
    
}

static NSData *imagedata;
+(UIImage *)compress:(UIImage *)oriImage{
   
    data=UIImageJPEGRepresentation(oriImage, 1);
    
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(oriImage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(oriImage, 0.3);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(oriImage, 0.7);
        }
        
    }
    UIImage *xin = [UIImage imageWithData:data];
    return xin;

}



+ (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

@end
