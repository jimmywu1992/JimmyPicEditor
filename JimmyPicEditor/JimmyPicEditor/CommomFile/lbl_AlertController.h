//
//  lbl_AlertController.h
//  Alert
//
//  Created by 张丹 on 16/6/13.
//  Copyright © 2016年 ***. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lbl_AlertController : UIAlertController

/**
 *  @author 张丹
 *
 *  UIAlertControllerStyleAlert
 *
 *  @param title        主标题
 *  @param destructiveT 确定
 *  @param cancelT      取消
 *  @param des          确定点击事件
 *  @param cancel       取消点击事件
 *
 *  @return lbl_AlertController
 */
+ (lbl_AlertController *)alertTitle:(NSString *)title destructiveTitle:(NSString *)destructive cancelTitle:(NSString *)cancel desEvent:(void (^)())des cancelEvent:(void (^)())cal;

/**
 *  @author 张丹
 *
 *  UIAlertControllerStyleActionSheet
 *
 *  @param title
 *  @param top      第1个action
 *  @param midst    第2个aciton
 *  @param bottom   第3个action
 *  @param topev    第1个action 事件
 *  @param midstev  第2个action 事件
 *  @param bottomev 第3个action 事件
 *
 *  @return lbl_AlertController
 */

+ (lbl_AlertController *)actionTitle:(NSString *)title topTitle:(NSString *)top midstTitle:(NSString *)midst bottomTitle:(NSString *)bottom topEvent:(void (^)())topev midstEvent:(void (^)())midstev bottomEvent:(void (^)())bottomev;

@end
