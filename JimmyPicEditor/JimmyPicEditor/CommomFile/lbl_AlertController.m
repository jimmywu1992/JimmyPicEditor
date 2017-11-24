//
//  lbl_AlertController.m
//  Alert
//
//  Created by 张丹 on 16/6/13.
//  Copyright © 2016年 ***. All rights reserved.
//

#import "lbl_AlertController.h"

@implementation lbl_AlertController

+ (lbl_AlertController *)alertTitle:(NSString *)title destructiveTitle:(NSString *)destructive cancelTitle:(NSString *)cancel desEvent:(void (^)())des cancelEvent:(void (^)())cal
{
    lbl_AlertController *alertDialog = [lbl_AlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:destructive style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        des();
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        cal();
    }];
    
    [alertDialog addAction:sureAction];
    [alertDialog addAction:cancelAction];
    
    return alertDialog;
}

+ (lbl_AlertController *)actionTitle:(NSString *)title topTitle:(NSString *)top midstTitle:(NSString *)midst bottomTitle:(NSString *)bottom topEvent:(void (^)())topev midstEvent:(void (^)())midstev bottomEvent:(void (^)())bottomev
{
    lbl_AlertController *alertDialog = [lbl_AlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:top style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        topev();
    }];
    
    UIAlertAction *pictureAction = [UIAlertAction actionWithTitle:midst style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        midstev();
    }];
    UIAlertAction *finishAction = [UIAlertAction actionWithTitle:bottom style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        bottomev();
    }];
    
    [alertDialog addAction:photoAction];
    [alertDialog addAction:pictureAction];
    [alertDialog addAction:finishAction];
    
    return alertDialog;
}

@end
