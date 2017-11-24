//
//  ViewController.m
//  JimmyPicEditor
//
//  Created by wjpMac on 2017/11/24.
//  Copyright © 2017年 JiPing Wu. All rights reserved.
//

#import "ViewController.h"
#import "Button.h"
#import "lbl_AlertController.h"
#import "imageTool.h"
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define  autolyout(h) h*([UIScreen mainScreen].bounds.size.height/667)
#define KBase_tag     100
@interface ViewController ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIViewControllerTransitioningDelegate>
{
    
    /** 图片数组 */
    NSMutableArray *photos;
  
    /** 图片排列容器 */
    UIView *contain;
    
    /** 记录拖拽空间的坐标大小 */
    CGPoint nextPoint;
    CGRect nextFrame;
    
    /** 记录即将替换空间的坐标大小 */
    CGPoint valuePoint;
    CGRect valueFrame;
    
    /** 记录点击的图片按钮 */
//    Button *lastBtn;
    
    /** 记录已经上传的图片数量 */
    NSInteger PhotosNum;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
  
    //初始化照片数组
    photos = [[NSMutableArray alloc]init];
  
  
    //创建ui
    [self creatUi];
}

#pragma － mark ui

-(void)creatUi{
   
    
    //1.上传图片按钮
    CGFloat btnWidth = (Screen_Width - autolyout(9)) / 4;
    CGFloat headericonheight = Screen_Width - btnWidth - autolyout(3);
    
    //上传图片的底板
    contain = [[UIView alloc]initWithFrame:CGRectMake(0, 50, Screen_Width, headericonheight + btnWidth + autolyout(3))];
    contain.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contain];
    
    
    //上传头像的按钮
    Button *headbtn = [[Button alloc]initWithFrame:CGRectMake(0, 0, headericonheight, headericonheight)];
    headbtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    headbtn.tag = 100;
    [headbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    headbtn.selected = NO;
    [contain addSubview:headbtn];
    [headbtn setBackgroundImage:[UIImage imageNamed:@"headerUpdata"] forState:UIControlStateNormal];
    [headbtn addTarget:self action:@selector(click_updataPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加拖拽手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [pan setMaximumNumberOfTouches:1]; // 最小手指数
    [headbtn addGestureRecognizer:pan];
   
    
    //上传非头像的照片按钮
    for (int i = 0; i < 4; i ++) {
        Button *btn = [[Button alloc]initWithFrame:CGRectMake(Screen_Width - btnWidth, (i) * (btnWidth + autolyout(3)), btnWidth, btnWidth)];
        btn.tag = 101 + i;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.selected = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"photoAdd"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click_updataPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [contain addSubview:btn];
        
        // 添加拖拽手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [pan setMaximumNumberOfTouches:1]; // 最小手指数
        [btn addGestureRecognizer:pan];
    }
    for (int j = 4; j < 7; j ++) {
        Button *btn = [[Button alloc]initWithFrame:CGRectMake((j - 4) * (btnWidth + autolyout(3)), 3 * (btnWidth + autolyout(3)), btnWidth, btnWidth)];
        btn.titleLabel.textColor = [UIColor redColor];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.selected = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"photoAdd"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click_updataPhoto:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (j) {
            case 4:
                btn.tag = 107;
                break;
            case 5:
                btn.tag = 106;
                break;
            case 6:
                btn.tag = 105;
                break;
                
            default:
                break;
        }
        [contain addSubview:btn];
        
        // 添加拖拽手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [pan setMaximumNumberOfTouches:1]; // 最小手指数
        [btn addGestureRecognizer:pan];
    }
}

#pragma mark - 上传图片按钮的点击事件
-(void)click_updataPhoto:(Button *)sender{
   
    if (sender.selected == NO) {//如果没点击过 这个按钮上面没有图片
        lbl_AlertController *alert = [lbl_AlertController actionTitle:@"从相册选择" topTitle:@"相册" midstTitle:@"相机" bottomTitle:@"取消" topEvent:^{
            [self openFile];
        } midstEvent:^{
            [self takePhoto];
        } bottomEvent:^{
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (sender.selected == YES){//如果点击过 这个按钮上有照片了
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            //删除照片
            [photos removeObject:sender.image];
            
            //重新排序
            [self photosRanking];
            
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
   
    
}

#pragma mark - 点击上传头像提示事件
- (void)tapGesRe:(UITapGestureRecognizer *)sender{
    [sender.view removeFromSuperview];
   lbl_AlertController *alert = [lbl_AlertController actionTitle:@"从相册选择" topTitle:@"相册" midstTitle:@"相机" bottomTitle:@"取消" topEvent:^{
        [self openFile];
    } midstEvent:^{
        [self takePhoto];
    } bottomEvent:^{
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 进去相册选择图片
- (void)openFile{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - 使用相机拍摄图片
- (void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置选择后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertController *alert_c = [UIAlertController alertControllerWithTitle:@"提示" message:@"模拟机没有相机功能,请在真机使用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action_1 = [UIAlertAction actionWithTitle:@"知道" style:UIAlertActionStyleDefault handler:nil];
        [alert_c addAction:action_1];
        [self presentViewController:alert_c animated:YES completion:nil];
    }
}
#pragma mark - 从相册选择图片后调用的方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
       
        //照片压缩
        UIImage *newImg = [imageTool compress:image];
        //退出系统相册/相机
        [picker dismissViewControllerAnimated:NO completion:nil];
        
        //添加照片进入数组
        [photos addObject:newImg];
        //记录数组的count
        PhotosNum = photos.count;
        //排序
        [self photosRanking];
        
   
    }
}

#pragma mark - 拖拽事件
-(void)pan:(UIPanGestureRecognizer*)recognizer{
    Button *recognizerView = (Button *)recognizer.view;
    //获取移动偏移量
    CGPoint recognizerPoint = [recognizer translationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (recognizerView.selected == NO) {
            
        }else{
            //开始的时候改变拖动view的外观（放大，改变颜色等）
            [UIView animateWithDuration:0.2 animations:^{
                if (recognizerView.tag == 100) {
                    recognizerView.transform = CGAffineTransformMakeScale(0.35, 0.35);
                }else{
                    recognizerView.transform = CGAffineTransformMakeScale(0.75, 0.75);
                }
                recognizerView.alpha = 0.7;
            }];
            //把拖动view放到最上层
            [self.view bringSubviewToFront:recognizerView];
            //valuePoint保存最新的移动位置
            valuePoint = recognizerView.center;
            
        }
        
        CGFloat btnWidth = (Screen_Width - autolyout(9)) / 4;
        CGFloat headericonheight = Screen_Width - btnWidth - autolyout(3);
        
        if (recognizerView.tag == 100) {
            valueFrame =CGRectMake(0, 0, headericonheight, headericonheight);
        }else{
            valueFrame = CGRectMake(0, 0, btnWidth, btnWidth);
        }
        
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        
        //更新pan.view的center
        CGFloat x = recognizerView.center.x + recognizerPoint.x;
        CGFloat y = recognizerView.center.y + recognizerPoint.y;
        
        if (recognizerView.selected == YES) {
            recognizerView.center = CGPointMake(x, y);
        }
        //因为拖动会持续执行 所以每次结束都要清空
        [recognizer setTranslation:CGPointZero inView:self.view];
        
        for (Button * bt in contain.subviews) {
            //判断是否移动到另一个view区域
            //CGRectContainsPoint(rect,point)
            //判断某个点是否被某个frame包含
            if (CGRectContainsPoint(bt.frame, recognizerView.center)&&bt!=recognizerView){
                //开始位置
                NSInteger fromIndex = recognizerView.tag - KBase_tag;
                
                //需要移动到的位置
                NSInteger toIndex = bt.tag - KBase_tag;
                
                //往后移动
                if ((toIndex-fromIndex)>0) {
                    //从开始位置移动到结束位置
                    //把移动view的下一个view移动到记录的view的位置(valuePoint)，并把下一view的位置记为新的nextPoint，并把view的tag值-1,依次类推
                    if (bt.selected == NO||recognizerView.selected == NO) {
                        
                    }else{
                        [UIView animateWithDuration:0.2 animations:^{
                            for (NSInteger i = fromIndex+1; i<=toIndex; i++) {
                                Button * nextBt = (Button*)[self.view viewWithTag:KBase_tag+i];
                                nextFrame = nextBt.frame;
                                nextPoint = nextBt.center;
                                
                                nextBt.frame = valueFrame;
                                nextBt.center = valuePoint;
                                
                                valueFrame = nextFrame;
                                valuePoint = nextPoint;
                                
                                nextBt.tag--;
                            }
                            recognizerView.tag = KBase_tag + toIndex;
                        }];
                    }
                }
                //往前移动
                else{
                    //从开始位置移动到结束位置
                    //把移动view的上一个view移动到记录的view的位置(valuePoint)，并把上一view的位置记为新的nextPoint，并把view的tag值+1,依次类推
                    if (bt.selected == NO||recognizerView.selected == NO) {
                        
                    }else{
                        [UIView animateWithDuration:0.2 animations:^{
                            for (NSInteger i = fromIndex-1; i>=toIndex; i--) {
                                Button * nextBt = (Button*)[self.view viewWithTag:KBase_tag+i];
                                nextFrame = nextBt.frame;
                                nextPoint = nextBt.center;
                                
                                nextBt.frame = valueFrame;
                                nextBt.center = valuePoint;
                                
                                valueFrame = nextFrame;
                                valuePoint = nextPoint;
                                
                                nextBt.tag++;
                            }
                            recognizerView.tag = KBase_tag + toIndex;
                        }];
                    }
                }
            }
        }
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        
        if (recognizerView.selected == YES) {
            //结束时候恢复view的外观（放大，改变颜色等）
            [UIView animateWithDuration:0.2 animations:^{
                recognizerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                recognizerView.alpha = 1;
                recognizerView.frame = valueFrame;
                recognizerView.center = valuePoint;
                [self photosDataRanking];
                
            }];
            
        }
    }
    
    
}
#pragma mark - 图片UI重新排列(删除照片 添加照片的时候调用)
-(void)photosRanking{
 
    for (int i = 0; i < 8; i ++) {
        Button *btn = [self.view viewWithTag:100 + i];
        if (i < photos.count) {//有照片的 按钮状态变成有照片
            btn.image = photos[i];
            [btn setImage:photos[i] forState:UIControlStateNormal];
            btn.selected = YES;
            
        }else{//没照片 按钮状态变成没照片
            if (i == 0) {
                btn.selected = NO;
                [btn setImage:[UIImage imageNamed:@"headerUpdata"] forState:UIControlStateNormal];
            }else{
                btn.selected = NO;
                [btn setImage:[UIImage imageNamed:@"photoAdd"] forState:UIControlStateNormal];
            }
        }
    }
    
    
    
   
    
}
#pragma mark - 图片数据重新排列
-(void)photosDataRanking{
    [photos removeAllObjects];
   
    for (int i = 0; i < PhotosNum; i ++) {
        Button *btn = [self.view viewWithTag:100 + i];
        [photos addObject:btn.image];
       
    }
    
    
    
}





@end
