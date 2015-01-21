//
//  FirstViewController.m
//  KeyboardLocation_Test
//
//  Created by iwind on 15/1/21.
//  Copyright (c) 2015年 iwind. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController() <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) UIView * headView;

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

    NSLog(@"测试");
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.headView removeFromSuperview];
}
-(void)dealloc{
    
}


@end

