//
//  ViewController.m
//  crashhack
//
//  Created by 董希成 on 16/6/16.
//  Copyright © 2016年 董希成. All rights reserved.
//

#import "ViewController.h"
#import "NSPrimary+CrashHack.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString* value = nil;
    id dictionary = @{@"temp":@"ok", @"key":value};
    NSLog(@"dic%@",dictionary);
    
    id temp = [dictionary test];
    NSLog(@"%@",temp);
    
    
    
    if( [dictionary respondsToSelector:@selector(viewDidLoad)] ) {
        NSLog(@"支持");
    } else {
        NSLog(@"不支持");
    }
    id arrayValue = nil;
    id t = @[@"1",@"22",@"333", arrayValue, @"4444"];
    NSLog(@"%@",t);
    NSDictionary* dic = t;
    NSArray* array = t;
    NSLog(@"%@,%@", dic[@"1"], array[1] );
    NSLog(@"%@,%@", dic[@"1"], array[10]);
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [arr addObject:@"test"];
    [arr addObject:arrayValue];
    NSLog(@"arr = %@", arr);
}

-(id) test{
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
