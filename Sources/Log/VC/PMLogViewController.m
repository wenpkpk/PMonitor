//
//  PMLogViewController.m
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import "PMLogViewController.h"
#import "PMLogTableViewCell.h"
#import "PMLogDataSource.h"
#import "PMLogFilterViewController.h"
#import "PMService.h"
#import "PMLogConfig.h"

#define kEmptyCellHeight                80

@interface PMLogViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView        *tableView;
@property(nonatomic, strong) PMLogDataSource    *logDataSource;
@property(nonatomic, strong) UIBarButtonItem    *fontIncreaseItem;
@property(nonatomic, strong) UIBarButtonItem    *fontDecreaseItem;
@property(nonatomic, strong) PMLogConfig        *logConfig;

@end


@implementation PMLogViewController

- (instancetype)initWithDataSource:(PMLogDataSource *)logDataSource logConfig:(PMLogConfig *)logConfig
{
    self = [super init];
    
    if (self) {
        self.title = @"Log";
        self.backText = @"退出";
        self.logDataSource = logDataSource;
        self.logConfig = logConfig;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataSourceDidUpdate:)
                                                     name:kNotifPMLogDataSourceDidUpdate
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(configDidUpdate:)
                                                     name:kNotifPMLogConfigDidUpadte
                                                   object:nil];
    }
    
    return self;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (void)dataSourceDidUpdate:(NSNotification *)notif
{
    [self reloadData];
}

- (void)configDidUpdate:(NSNotification *)notif
{
    [self reloadData];
}

- (void)reloadData
{
    BOOL scrollToBottom = NO;
    
    if (fabs(self.tableView.contentOffset.y + self.tableView.bounds.size.height) >= fabs(self.tableView.contentSize.height) - kEmptyCellHeight) {
        scrollToBottom = YES;
    } else {
    }
 
    [self checkFontAdjuestEnable];
    [self.tableView reloadData];
    
    if (scrollToBottom) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createRightItems];
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)createRightItems
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"+" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self
            action:@selector(fontIncrease)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *fontIncrease = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"-" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self
            action:@selector(fontDecrease)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *fontDecrease = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"C" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self
            action:@selector(clearLog)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *clearLog = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Filter" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 40, 30);
    [btn addTarget:self
            action:@selector(filter)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.fontIncreaseItem = fontIncrease;
    self.fontDecreaseItem = fontDecrease;
    self.navigationItem.rightBarButtonItems = @[filter, clearLog, fontIncrease, fontDecrease];
    [self checkFontAdjuestEnable];
}

- (void)checkFontAdjuestEnable
{
    self.fontIncreaseItem.enabled = kLogMaxFontLevel != self.logConfig.fontLevel;
    self.fontDecreaseItem.enabled = 0 != self.logConfig.fontLevel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    [super back];
    [self.pmWindow resignKeyWindow];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)fontIncrease
{
    [self.logConfig fontIncrease:1];
    [self reloadData];
}

- (void)fontDecrease
{
    [self.logConfig fontIncrease:-1];
    [self reloadData];
}

- (void)clearLog
{
    [self.logDataSource clearLog];
}

- (void)filter
{
    PMLogFilterViewController *vc = [[PMLogFilterViewController alloc] initWithBizes:self.logConfig.bizes
                                                                         filterBizes:self.logConfig.filterBizes];
    vc.pmWindow = self.pmWindow;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return [self.logDataSource numberOfItems:self.logConfig.filterBizes];
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        PMLogDataModel *log = [self.logDataSource logAtItemIndex:indexPath.row bizes:self.logConfig.filterBizes];
        
        return [PMLogTableViewCell height4DataModel:log config:self.logConfig];
    } else {
        if (0 == indexPath.row) {
            return kEmptyCellHeight;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[PMLogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
    }

    if (0 == indexPath.section) {
        PMLogDataModel *log = [self.logDataSource logAtItemIndex:indexPath.row bizes:self.logConfig.filterBizes];
        [cell bindData:log config:self.logConfig];
    } else {
    }

    return cell;
}

#pragma mark - public

@end
