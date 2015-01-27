//
//  ViewController.m
//  KeyboardLocation_Test
//
//  Created by iwind on 15/1/21.
//  Copyright (c) 2015年 iwind. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (strong ,nonatomic) NSArray * dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAction:(id)sender {
    
    NSLog(@"------ test");
    [self performSegueWithIdentifier:@"segue1" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    FirstViewController * firstVC = segue.destinationViewController;
    firstVC.dataSource = self.dataArr;
}

@end
