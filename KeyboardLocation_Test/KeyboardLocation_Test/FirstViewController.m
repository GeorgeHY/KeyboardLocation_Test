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
    CGRect _originInputFrame;
    
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
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.inputView resignFirstResponder];
        self.inputView.hidden = YES;
        self.inputView.frame = _originInputFrame;
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
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    

    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"------ cell.frame = %@",NSStringFromCGRect(cell.frame));
    CGRect frame = self.inputView.frame;
    frame.origin.y = CGRectGetMaxY(cell.frame);
    [UIView animateWithDuration:1 animations:^{
        self.inputView.hidden = NO;
        self.inputView.frame = frame;
        [self.inputView becomeFirstResponder];
        self.inputView.returnKeyType = UIReturnKeyDone;
    } completion:^(BOOL finished) {
        //
    }];
    
    NSLog(@"测试");

}


-(void)viewWillDisappear:(BOOL)animated{
    [self.headView removeFromSuperview];
    self.inputView.frame = _originInputFrame;
}
-(void)dealloc{
    
}


@end

