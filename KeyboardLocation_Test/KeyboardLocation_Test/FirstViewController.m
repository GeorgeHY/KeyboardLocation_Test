//
//  FirstViewController.m
//  KeyboardLocation_Test
//
//  Created by iwind on 15/1/21.
//  Copyright (c) 2015年 iwind. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController() <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

{
    CGRect _originInputFrame;//初始输入框frame
    CGRect _currentFrame;
    CGRect _keyBoardFrame;//键盘frame
    CGRect _originTVFrame;//初始tableview frame
    
    
}


@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) UIView * headView;
@property (strong, nonatomic) UITextView * inputView;

@end

@implementation FirstViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.dataSource);
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.tv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(140, 0, 40, 40)];
    self.headView.backgroundColor = [UIColor redColor];
    [self.navigationController.navigationBar addSubview:self.headView];
    self.inputView = [[UITextView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height, [[UIScreen mainScreen]bounds].size.width, 44)];
    self.inputView.delegate = self;
    self.inputView.backgroundColor = [UIColor greenColor];
    [self.tv addSubview:self.inputView];
    _originInputFrame = self.inputView.frame;
    _originTVFrame = self.tv.frame;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardhide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillChangeFrame:(NSNotification *)notif{
//    NSDictionary * info = [notif userInfo];
//    CGFloat duration = [[info objectForKeyedSubscript:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    NSValue * value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    _keyBoardFrame = [value CGRectValue];
//    NSLog(@"------- frame = %@",NSStringFromCGRect(_keyBoardFrame));
//    CGRect frame1 = self.inputView.frame;
//    CGRect frame2 = [[UIApplication sharedApplication] statusBarFrame];
//    frame1.origin.y = _keyBoardFrame.origin.y-frame1.size.height-self.navigationController.navigationBar.frame.size.height-frame2.size.height;//去除Navi和状态栏的高
//    //    frame1.origin = CGPointMake(0, 300);
//    NSLog(@"frame1 = %@",NSStringFromCGRect(frame1));
//    _currentFrame = frame1;
//    [UIView animateWithDuration:duration animations:^{
//        self.inputView.frame = frame1;
//    }];
//    
//    NSLog(@"------- self.v.frame = %@",NSStringFromCGRect(self.inputView.frame));
    
    //    NSLog(@"------ frame = %@",NSStringFromCGRect(frame));
    
    
    
}

///还原所有frame
- (void)resetFrame {
    //在这里做你响应return键的代码
    [self.inputView resignFirstResponder];
    //        self.inputView.hidden = YES;
    self.inputView.frame = _originInputFrame;
    self.tv.frame = _originTVFrame;
}

//-(void)keyboardhide:(NSNotification*)notif{
//    NSDictionary * info = [notif userInfo];
//    CGFloat duration = [[info objectForKeyedSubscript:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    //    NSValue * value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    //    CGRect frame = [value CGRectValue];
//    //    NSLog(@"------- frame = %@",NSStringFromCGRect(frame));
//    //    CGRect frame1 = self.v.frame;
//    //    frame1.origin.y = frame.origin.y-frame1.size.height;
//    //    //    frame1.origin = CGPointMake(0, 300);
//    //    NSLog(@"frame1 = %@",NSStringFromCGRect(frame1));
//    [UIView animateWithDuration:duration animations:^{
//        self.inputView.frame = _originFrame;
//    }];
//    
//    NSLog(@"------- self.v.frame = %@",NSStringFromCGRect(self.inputView.frame));
//}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self resetFrame];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    UIButton * replyBtn = [[UIButton alloc]initWithFrame:CGRectMake(260, 5, 40, 30)];
    [replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    replyBtn.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:replyBtn];
    
    return cell;
    
}
///评论action
-(void)replyAction:(UIButton*)sender{
    UIView * contentview = [sender superview];
    UITableViewCell * currentCell = (UITableViewCell *)[contentview superview];
//    [self resetFrame];
    
    
    [self.inputView becomeFirstResponder];
    if ([self.inputView isFirstResponder]) {
        CGRect cellFrame = currentCell.frame;
        CGRect originCellFrame = currentCell.frame;
        CGRect frame1 = self.tv.frame;//tableviewframe
        CGRect frame2 = self.inputView.frame;//输入框frame
//        cellFrame.origin.y = _currentFrame.origin.y-currentCell.frame.size.height;
        //        frame1.origin.y = _currentFrame.origin.y-cell.frame.size.height;
        //键盘的y-输入框的高-cell的高 与 cell初始的y做差算出偏移量
        CGFloat changeY = _keyBoardFrame.origin.y-self.inputView.frame.size.height-currentCell.frame.size.height-originCellFrame.origin.y;
        frame1.origin.y = frame1.origin.y + changeY;
//        frame2.origin.y = frame2.origin.y - changeY;
        [UIView animateWithDuration:0.5 animations:^{
            self.tv.frame = frame1;
//            self.inputView.frame = frame2;
        } completion:^(BOOL finished) {
            //
        }];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self resetFrame];
//
//  
//    [self.inputView becomeFirstResponder];
//    if ([self.inputView isFirstResponder]) {
//        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//        CGRect frame = cell.frame;
//        CGRect originFrame = cell.frame;
//        CGRect frame1 = self.tv.frame;
//        CGRect frame2 = self.inputView.frame;
//        frame.origin.y = _currentFrame.origin.y-cell.frame.size.height;
////        frame1.origin.y = _currentFrame.origin.y-cell.frame.size.height;
//        CGFloat changeY =  frame.origin.y-originFrame.origin.y;
//        frame1.origin.y = frame1.origin.y + changeY;
//        frame2.origin.y = frame2.origin.y - changeY;
//        [UIView animateWithDuration:0.5 animations:^{
//            self.tv.frame = frame1;
//            self.inputView.frame = frame2;
//        } completion:^(BOOL finished) {
//            //
//        }];
//    }

    
//    NSLog(@"------ cell.frame = %@",NSStringFromCGRect(cell.frame));
//    CGRect frame = self.inputView.frame;
//    frame.origin.y = CGRectGetMaxY(cell.frame);
//    [UIView animateWithDuration:1 animations:^{
//        self.inputView.hidden = NO;
//        self.inputView.frame = frame;
    
//        self.inputView.returnKeyType = UIReturnKeyDone;
//    } completion:^(BOOL finished) {
//        //
//    }];
//    
//    NSLog(@"测试");

}


-(void)viewWillDisappear:(BOOL)animated{
    [self.headView removeFromSuperview];
    self.inputView.frame = _originInputFrame;
}
-(void)dealloc{
    
}


@end

