//
//  PMJSViewController.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-10.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "PMJSViewController.h"
#import "PMLogTableViewCell.h"
#import "PMJSCallDataSource.h"
#import "PMLogConfig.h"
#import "PMLogDataModel.h"

#define kEmptyCellHeight                80
#define kJSTemplate                     @"AlipayJSBridge.call('',{},function(result){alert(JSON.stringify(result));});"


@interface PMJSViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property(nonatomic, strong) UITableView        *tableView;
@property(nonatomic, strong) UITextView         *tv;
@property(nonatomic, assign) float              keyboardHeight;//default is 216
@property(nonatomic, assign) BOOL               isKeyboardShow;
@property(nonatomic, assign) CGRect             oriFrame;
@property(nonatomic, strong) UIButton           *callBtn;
@property(nonatomic, strong) UIBarButtonItem    *fontIncreaseItem;
@property(nonatomic, strong) UIBarButtonItem    *fontDecreaseItem;
@property(nonatomic, strong) PMJSCallDataSource *logDataSource;
@property(nonatomic, strong) PMLogConfig        *logConfig;

@end


@implementation PMJSViewController

- (instancetype)initWithDataSource:(PMJSCallDataSource *)dataSource logConfig:(PMLogConfig *)logConfig
{
    self = [super init];
    if (self) {
        self.keyboardHeight = 216.0f;
        self.logDataSource = dataSource;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRightItems];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tv.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 120, CGRectGetWidth(self.view.frame) - 60, 120);
    self.tv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.tv];
    self.callBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 80, CGRectGetHeight(self.view.frame) - 120, 80, 120);
    self.callBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.callBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // register for keyboard notifications while visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidChangeFrameNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITextView *)tv
{
    if (!_tv) {
        _tv = [[UITextView alloc] init];
        _tv.returnKeyType = UIReturnKeyDone;
        _tv.delegate = self;
    }
    
    return _tv;
}

- (UIButton *)callBtn
{
    if (!_callBtn) {
        _callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callBtn setTitle:@"call js" forState:UIControlStateNormal];
        [_callBtn addTarget:self
                     action:@selector(callBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
        _callBtn.enabled = NO;
        _callBtn.backgroundColor = [UIColor grayColor];
    }
    
    return _callBtn;
}

#pragma mark - private



#pragma mark ______doing

- (void)checkFontAdjuestEnable
{
    self.fontIncreaseItem.enabled = kLogMaxFontLevel != self.logConfig.fontLevel;
    self.fontDecreaseItem.enabled = 0 != self.logConfig.fontLevel;
}

- (void)checkCallBtnEnable
{
    if ([self.tv.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        self.callBtn.enabled = NO;
        self.callBtn.backgroundColor = [UIColor grayColor];
    } else {
        self.callBtn.enabled = YES;
        self.callBtn.backgroundColor = [UIColor blueColor];
    }
}

- (void)back
{
    [super back];
}

- (void)reloadData
{
    BOOL scrollToBottom = NO;
    
    if (fabs(self.tableView.contentOffset.y + self.tableView.bounds.size.height) >= fabs(self.tableView.contentSize.height) - kEmptyCellHeight) {
        scrollToBottom = YES;
    } else {
    }
    
    [self checkFontAdjuestEnable];
    [self checkCallBtnEnable];
    [self.tableView reloadData];
    
    if (scrollToBottom) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         if (movedUp) {
                             self.view.frame = CGRectOffset(self.oriFrame, 0, -self.keyboardHeight);
                         } else {
                             self.view.frame = self.oriFrame;
                         }
                     } completion:NULL];
}

#pragma mark ______clicked

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

- (void)jsTemplate
{
    [self.tv setText:kJSTemplate];
    [self checkCallBtnEnable];
}

- (void)callBtnClicked:(id)sender
{
    [self.tv resignFirstResponder];
    NSString *js = [self.tv.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (js.length > 0) {
        // addLog
        PMLogDataModel *dataModel = [[PMLogDataModel alloc] init];
        dataModel.biz = kLogBizDefault;
        dataModel.logType = PMLogType_Normal;
        dataModel.log = [NSString stringWithFormat:@"【执行JS：】%@", js];
        dataModel.fileName = @"";
        dataModel.functionName = @"";
        dataModel.functionLineNumber = 0;
        [self.logDataSource addLog:dataModel];
        self.tv.text = @"";
        
        NSDate* date = [NSDate date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSString* dateString = [dateFormatter stringFromDate:date];
        dataModel.dateStr = dateString;
        [dataModel calculateHeight];
        [self reloadData];
        NSString *result = [self.wb stringByEvaluatingJavaScriptFromString:js];
        
        dataModel = [[PMLogDataModel alloc] init];
        dataModel.biz = kLogBizDefault;
        dataModel.logType = PMLogType_Normal;
        dataModel.log = [NSString stringWithFormat:@"【结果：】%@", result];
        dataModel.fileName = @"";
        dataModel.functionName = @"";
        dataModel.functionLineNumber = 0;
        [self.logDataSource addLog:dataModel];
        
        date = [NSDate date];
        dateString = [dateFormatter stringFromDate:date];
        dataModel.dateStr = dateString;
        [dataModel calculateHeight];
        [self reloadData];
    }
}

#pragma mark ______create

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
    [btn setTitle:@"JS" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self
            action:@selector(jsTemplate)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *jsTemplate = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.fontIncreaseItem = fontIncrease;
    self.fontDecreaseItem = fontDecrease;
    self.navigationItem.rightBarButtonItems = @[clearLog, fontIncrease, fontDecrease, jsTemplate];
    [self checkFontAdjuestEnable];
}

#pragma mark ______notif

-(void)keyboardWillShow:(NSNotification *)notif
{
    // Animate the current view out of the way
    NSValue *endValue = [notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = CGRectZero;
    
    [endValue getValue:&endFrame];
    self.isKeyboardShow = YES;
    self.oriFrame = self.view.frame;
    self.keyboardHeight = CGRectGetHeight(endFrame);
    [self setViewMovedUp:YES];
}

- (void)keyboardDidChangeFrame:(NSNotification *)notif
{
    if (self.isKeyboardShow) {
        NSValue *beginValue = [notif.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect beginFrame = CGRectZero;
        NSValue *endValue = [notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect endFrame = CGRectZero;
        
        [endValue getValue:&endFrame];
        [beginValue getValue:&beginFrame];
        self.keyboardHeight = CGRectGetHeight(endFrame);
        [self setViewMovedUp:YES];
    }
}

-(void)keyboardWillHide
{
    self.isKeyboardShow = NO;
    [self setViewMovedUp:NO];
}

- (void)dataSourceDidUpdate:(NSNotification *)notif
{
    [self reloadData];
}

- (void)configDidUpdate:(NSNotification *)notif
{
    [self reloadData];
}

#pragma mark - DataSource



#pragma mark - Delegates

#pragma mark ______tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return [self.logDataSource numberOfItems:@[kLogBizDefault]];
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        PMLogDataModel *log = [self.logDataSource logAtItemIndex:indexPath.row bizes:self.logConfig.filterBizes];
        
        CGFloat height = [PMLogTableViewCell height4DataModel:log config:self.logConfig];
        
        return height;
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

#pragma mark ______textView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self checkCallBtnEnable];
}

#pragma mark - public



@end
