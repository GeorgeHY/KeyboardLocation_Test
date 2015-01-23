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
@property (strong, nonatomic) UITableViewCell * currentCell;
@property (strong, nonatomic) NSIndexPath * currentIndex;
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
    [self.view addSubview:self.inputView];
    _originInputFrame = self.inputView.frame;
    _originTVFrame = self.tv.frame;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardhide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillChangeFrame:(NSNotification *)notif{
    NSDictionary * info = [notif userInfo];
    CGFloat duration = [[info objectForKeyedSubscript:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue * value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyBoardFrame = [value CGRectValue];
    NSLog(@"------- frame = %@",NSStringFromCGRect(_keyBoardFrame));
    CGRect frame1 = self.inputView.frame;

    frame1.origin.y = _keyBoardFrame.origin.y-frame1.size.height;//去除Navi和状态栏的高
    //    frame1.origin = CGPointMake(0, 300);
    NSLog(@"frame1 = %@",NSStringFromCGRect(frame1));
    _currentFrame = frame1;
    
    NSLog(@"_originTVFrame = %@",NSStringFromCGRect(_originTVFrame));
    CGRect currentTvFrame = _originTVFrame;
//    currentTvFrame.origin.y = currentTvFrame.origin.y-_keyBoardFrame.size.height-_inputView.frame.size.height-64;
    NSLog(@"----- currentTvFrame = %@",NSStringFromCGRect(currentTvFrame));
    CGRect frame2 = [[UIApplication sharedApplication] statusBarFrame];
    currentTvFrame.size.height = currentTvFrame.size.height -frame1.size.height-_keyBoardFrame.size.height;
//    [self.tv scrollToRowAtIndexPath:self.currentIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self.tv setContentOffset:CGPointMake(0,self.currentIndex.row*200-64) animated:YES];
    self.tv.scrollEnabled = NO;
    [UIView animateWithDuration:duration animations:^{
        self.inputView.frame = frame1;
        self.tv.frame = currentTvFrame;
    }];
    

   

    
    
    
}

///还原所有frame
//- (void)resetFrame {
//    //在这里做你响应return键的代码
//    [self.inputView resignFirstResponder];
//    self.inputView.frame = _originInputFrame;
//    self.tv.frame = _originTVFrame;
//}

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
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按
        [self.inputView resignFirstResponder];
        self.inputView.frame = _originInputFrame;
        self.tv.frame = _originTVFrame;
        [self.tv scrollToRowAtIndexPath:self.currentIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        self.tv.scrollEnabled = YES;
        self.currentCell.textLabel.text = self.inputView.text;

        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    UIButton * replyBtn = [[UIButton alloc]initWithFrame:CGRectMake(260, 5, 40, 30)];
    [replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    replyBtn.backgroundColor = [UIColor grayColor];
    replyBtn.tag = indexPath.row;
    [cell.contentView addSubview:replyBtn];
    
    return cell;
    
}
///评论action
-(void)replyAction:(UIButton*)sender{
    UIView * contentview = [sender superview];
    self.currentCell = (UITableViewCell *)[contentview superview];
    self.currentIndex = [self.tv indexPathForCell:self.currentCell];
    [self.inputView becomeFirstResponder];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.inputView resignFirstResponder];
    self.inputView.frame = _originInputFrame;
    self.tv.frame = _originTVFrame;
    [self.tv scrollToRowAtIndexPath:self.currentIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    self.tv.scrollEnabled = YES;



}



-(void)viewWillDisappear:(BOOL)animated{
    [self.headView removeFromSuperview];
    self.inputView.frame = _originInputFrame;
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
-(void)dealloc{
    
}


@end

