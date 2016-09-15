//
//  GetOutViewController.m
//  Hicube
//
//  Created by AaronYang on 6/3/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "GetOutViewController.h"
#import "BaseTableViewCell.h"
#import "User.h"
#define TitleArray @[@"可取金额",@"姓名",@"开户行",@"开户支行",@"银行账号",@"提现金额"]
#define placeHolderArray @[@"请输入收款人姓名",@"请输入开户行",@"请输入开户支行",@"请输入银行账号",@"请输入提现金额"]
static NSString *const identifier = @"baseTableViewCell";
@interface GetOutViewController (){
    UIButton * commitButton;
}

@property (nonatomic, strong) User * user;
@property (nonatomic, strong) NSMutableArray * fieldArray;
@end

@implementation GetOutViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fieldArray = [NSMutableArray arrayWithCapacity:placeHolderArray.count];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 60)];
    commitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, tableView.width-40, 40)];
    [commitButton commonStyle];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:commitButton];
    commitButton.enabled = NO;
    tableView.tableFooterView = footView;
    
    [tableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:identifier];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    client = [[BSClient alloc]initWithDelegate:self action:@selector(requestUserDidFinish:obj:)];
    [client findProfileByUsername:[BSEngine currentEngine].user.phone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self showText:@"操作成功"];
    }else{
        commitButton.enabled = YES;
    }
    return YES;
}

-(void)requestUserDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        NSMutableDictionary * dic = list[0];
        [dic setObject:[dic getStringValueForKey:@"id" defaultValue:@""] forKey:@"ID"];
        self.user = [[User alloc] initWithDictionary:dic error:nil];
        [[BSEngine currentEngine] setCurrentUser:self.user password:nil tok:nil];
        [tableView reloadData];
        commitButton.enabled = YES;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return TitleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.imageView.hidden = YES;
    cell.textLabel.text = TitleArray[indexPath.row];
    
    UITextField * field = VIEWWITHTAG(cell.contentView, indexPath.row+900);
    UILabel * label = VIEWWITHTAG(cell.contentView, 800);
    if (indexPath.row==0) {
        if (!label) {
             label = [[UILabel alloc]initWithFrame:CGRectMake(cell.width-100, 10, 80, 20)];
            label.textAlignment = NSTextAlignmentRight;
            label.tag = 800;
            label.textColor = [UIColor redColor];
            [cell.contentView addSubview:label];
        }
        label.text = [NSString stringWithFormat:@"%@元",self.user?[NSString stringWithFormat:@"%.2f",self.user.balance]:@"0"];
    }else{
        if (!field) {
            field = [[UITextField alloc] initWithFrame:CGRectMake(cell.width-200, 10, 180, 20)];
            field.tag = indexPath.row+900;
            [cell.contentView addSubview:field];
            [self.fieldArray addObject:field];
            field.textAlignment = NSTextAlignmentRight;
            field.placeholder = placeHolderArray[indexPath.row-1];
            [cell.contentView addSubview:field];
        }
    }
    
    return cell;
}


-(void)commit:(UIButton *)button{
    button.enabled = NO;
    NSString * name = ((UITextField *)self.fieldArray[0]).text;
    NSString * bankName = ((UITextField *)self.fieldArray[1]).text;
    NSString * bBankName = ((UITextField *)self.fieldArray[2]).text;
    NSString * accountNum = ((UITextField *)self.fieldArray[3]).text;
    NSString * amount = ((UITextField *)self.fieldArray[4]).text;
    if (![name hasValue]) {
        [self showText:placeHolderArray[0]];
        return;
    }
    if (![bankName hasValue]) {
        [self showText:placeHolderArray[1]];
        return;
    }
    if (![bBankName hasValue]) {
        [self showText:placeHolderArray[2]];
        return;
    }
    if (![accountNum hasValue]) {
        [self showText:placeHolderArray[3]];
        return;
    }
    if (![amount hasValue]) {
        [self showText:placeHolderArray[4]];
        return;
    }
    [super startRequest];
    [client drawCashWtihBankName:bankName branchBankName:bBankName accountNum:accountNum ownerName:name amount:amount];
}
@end
