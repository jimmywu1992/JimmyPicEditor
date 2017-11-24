//
//  imageTool.h
//  21days
//
//  Created by wjpMac on 16/7/19.
//  Copyright © 2016年 wjpMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface imageTool : NSObject
//切割图片
+ (UIImage *)cutImage:(UIImage*)image;
//图片压缩并且转成base64字符串
+ (NSString *) image2DataURL: (UIImage *) image;
//图片压缩
+(UIImage *)compress:(UIImage *)oriImage;
//转base64 所需
+ (BOOL) imageHasAlpha: (UIImage *) image;


@end
