//
//  FirstViewController.m
//  KeyboardLocation_Test
//
//  Created by iwind on 15/1/21.
//  Copyright (c) 2015年 iwind. All rights reserved.
//

#import "FirstViewController.h"
#define kCellHeight 100
@interface FirstViewController() <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

{
    CGRect _originInputFrame;//初始输入框frame
    CGRect _keyBoardFrame;//键盘frame
    CGRect _originTVFrame;//初始tableview frame
    
    
}


@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) UIView * headView;
@property (strong, nonatomic) UITextView * inputView;
@property (strong, nonatomic) UITableViewCell * currentCell;
@property (strong, nonatomic) NSIndexPath * currentIndex;
@property (strong, nonatomic) NSIndexPath * displayIndex;//回复后显示index
@end

@implementation FirstViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    
    [self.tv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //测试在Navibar上添加view
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(140, 0, 40, 40)];
    self.headView.backgroundColor = [UIColor redColor];
    [self.navigationController.navigationBar addSubview:self.headView];
    
    //添加输入框
    self.inputView = [[UITextView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height, [[UIScreen mainScreen]bounds].size.width, 44)];
    self.inputView.delegate = self;
    self.inputView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.inputView];
    //保存原始frame以便初始化
    _originInputFrame = self.inputView.frame;
    _originTVFrame = self.tv.frame;
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    
}

-(void)keyboardWillChangeFrame:(NSNotification *)notif{
    NSDictionary * info = [notif userInfo];
    CGFloat duration = [[info objectForKeyedSubscript:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue * value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyBoardFrame = [value CGRectValue];//获取键盘frame
    
    //修改textview y值
    CGRect frame1 = self.inputView.frame;
    frame1.origin.y = _keyBoardFrame.origin.y-frame1.size.height;//去除Navi和状态栏的高

    CGRect currentTvFrame = _originTVFrame;

    CGRect frame2 = [[UIApplication sharedApplication] statusBarFrame];
    
    //键盘弹起更改tableview高度
    currentTvFrame.size.height = currentTvFrame.size.height -frame1.size.height-_keyBoardFrame.size.height;

    //定位回复的cell
//    [self.tv setContentOffset:CGPointMake(0,self.currentIndex.row * kCellHeight-self.navigationController.navigationBar.frame.size.height-frame2.size.height) animated:YES];

    [self.tv scrollToRowAtIndexPath:_currentIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.tv.scrollEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^{
        self.inputView.frame = frame1;
        self.tv.frame = currentTvFrame;
    }];
    

    
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        //判断输入的字是否是回车，即按
        [self.inputView resignFirstResponder];
        
        self.inputView.frame = _originInputFrame;
        self.tv.frame = _originTVFrame;
        
        
        [self.tv scrollToRowAtIndexPath:self.currentIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];//是回复的cell居中显示
        self.tv.scrollEnabled = YES;
        
        //此处可添加回复请求等
        
        return NO;
    }
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
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
    NSLog(@"self.currentIndex.row = %ld",self.currentIndex.row);
    
    
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



@end

