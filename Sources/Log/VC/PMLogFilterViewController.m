//
//  PMLogFilterViewController.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-7.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import "PMLogFilterViewController.h"
#import "PMConfigFactory.h"

@interface PMLogFilterViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView        *tableView;
@property(nonatomic, strong) NSArray            *bizes;
@property(nonatomic, strong) NSMutableArray     *filterBizes;
@property(nonatomic, assign) BOOL               isSelectedAllOrNone;

@end


@implementation PMLogFilterViewController

- (instancetype)initWithBizes:(NSArray *)bizes filterBizes:(NSArray *)filterBizes
{
    self = [super init];
    
    if (self) {
        self.title = @"Log Filter";
        self.bizes = bizes;
        self.filterBizes = [NSMutableArray arrayWithArray:filterBizes];
        self.isSelectedAllOrNone = ([self.filterBizes containsObject:kLogBizDefault] || [self.filterBizes containsObject:kLogBizNone]);
    }
    
    return self;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.allowsMultipleSelection = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createRightItem];
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

- (void)createRightItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    btn.frame = CGRectMake(0, 0, 40, 30);
    [btn addTarget:self
            action:@selector(done)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = doneItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done
{
    NSArray *selectedList = [self.tableView indexPathsForSelectedRows];
    [self.filterBizes removeAllObjects];
    
    for (NSIndexPath *indexPath in selectedList) {
        [self.filterBizes addObject:[self.bizes objectAtIndex:indexPath.row]];
    }
    
    // save config
    [PMConfigFactory getPMLogConfig].filterBizes = self.filterBizes;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifPMLogConfigDidUpadte
                                                        object:nil
                                                      userInfo:nil];
    
    [super back];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bizes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    
    if ([self.filterBizes containsObject:[self.bizes objectAtIndex:indexPath.row]]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    NSArray *selectedList = [tableView indexPathsForSelectedRows];
    
    if ([selectedList containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [self.bizes objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.isSelectedAllOrNone || indexPath.row <= 1) {
        NSArray *selectedList = [self.tableView indexPathsForSelectedRows];
        for (NSIndexPath *idx in selectedList) {
            if (idx.row != indexPath.row) {
                [tableView deselectRowAtIndexPath:idx animated:NO];
                [self tableView:tableView didDeselectRowAtIndexPath:idx];
            }
        }
    }
    
    self.isSelectedAllOrNone = (indexPath.row <= 1);
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

@end
