//
//  CustomTableViewController.m
//  MyDebt
//
//  Created by 罗若峰 on 13-6-16.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "PayTableViewController.h"
#import "PayItem.h"
#import "PayTableViewCell.h"
#import "ArchiveUtil.h"
#import "AddViewController.h"
#import "LocalNotificationUtil.h"

typedef NS_ENUM(NSInteger,NUMBER_OF_SECTION)
{
    //以下是枚举成员
    NUMBER_OF_SECTION_NEED_RETURN = 0,
    NUMBER_OF_SECTION_RETURNED = 1
};

@interface PayTableViewController ()

@property (nonatomic,getter = isOverThanCloseCell) Boolean overThanCloseCell;
@property (nonatomic,retain) NSIndexPath * indexPathOfOperationCell;
@property (nonatomic,retain) NSIndexPath * indexPathOfPrevOperationCell;
@property (nonatomic,retain) NSNumber * numberOfNeedReturn;
@property (nonatomic,retain) NSNumber * numberOfReturned;

@end

@implementation PayTableViewController


@synthesize types=types,paies=paies,overThanCloseCell = overThanCloseCell,indexPathOfOperationCell = indexPathOfOperationCell,indexPathOfPrevOperationCell = indexPathOfPrevOperationCell,numberOfNeedReturn=numberOfNeedReturn,numberOfReturned=numberOfReturned,titlesForHeader=titlesForHeader,payItemPayTypeDid=payItemPayTypeDid,payItemPayType=payItemPayType;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    overThanCloseCell = NO;
    indexPathOfOperationCell = nil;
    indexPathOfPrevOperationCell = nil;
    numberOfNeedReturn = [NSNumber numberWithInteger:NUMBER_OF_SECTION_NEED_RETURN];
    numberOfReturned = [NSNumber numberWithInteger:NUMBER_OF_SECTION_RETURNED];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    
    NSMutableArray *payItemPayTypeArray = [NSMutableArray arrayWithObjects:payItemPayType,payItemPayTypeDid, nil];
    NSMutableDictionary *contentDictionary = [[ArchiveUtil shareArchiveUtil] getPayItemDictionaryByPayItemPayTypes:payItemPayTypeArray];
    
    types = [NSMutableDictionary dictionaryWithObjects:
             [NSArray arrayWithObjects:
              [contentDictionary objectForKey:payItemPayType],
              [contentDictionary objectForKey:payItemPayTypeDid],
              nil] forKeys:[NSArray arrayWithObjects:numberOfNeedReturn,numberOfReturned, nil]];
    
    indexPathOfPrevOperationCell = nil;
    indexPathOfOperationCell = nil;
    
    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self closeOptionCell];
}

- (void) closeOptionCell
{
    if(indexPathOfOperationCell){
        if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_NEED_RETURN)
            [[types objectForKey:numberOfNeedReturn] removeLastObject];
        
        else if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_RETURNED)
            [[types objectForKey:numberOfReturned] removeLastObject];
        
        NSArray *deleteCells = [NSArray arrayWithObject:indexPathOfOperationCell];
        [self.tableView deleteRowsAtIndexPaths:deleteCells withRowAnimation:UITableViewRowAnimationRight];
        
        [self.tableView reloadData];
        
        indexPathOfOperationCell = nil;
        indexPathOfPrevOperationCell = nil;
    }
}

- (void) closeOptionCellAndRemoveOpertionCell
{
    if(indexPathOfOperationCell){
        if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_NEED_RETURN)
        {
            [[types objectForKey:numberOfNeedReturn] removeLastObject];
            [[types objectForKey:numberOfNeedReturn] removeObjectAtIndex:[indexPathOfPrevOperationCell row]];
        }
        else if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_RETURNED)
        {
            [[types objectForKey:numberOfReturned] removeLastObject];
            [[types objectForKey:numberOfReturned] removeObjectAtIndex:[indexPathOfPrevOperationCell row]];
        }
        NSArray *deleteCells = [NSArray arrayWithObjects:indexPathOfPrevOperationCell,indexPathOfOperationCell,nil];
        [self.tableView deleteRowsAtIndexPaths:deleteCells withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView reloadData];
        
        indexPathOfOperationCell = nil;
        indexPathOfPrevOperationCell = nil;
    }
}

- (void) closeOptionCellAndMoveOpertionCell
{
    if(indexPathOfOperationCell){
        
        NSMutableArray *currentSubArray = [types objectForKey:numberOfReturned];
        NSMutableArray *otherSubArray = nil;
        NSInteger otherSection = 0;
        
        if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_NEED_RETURN)
        {
            currentSubArray = [types objectForKey:numberOfNeedReturn];
            otherSubArray = [types objectForKey:numberOfReturned];
            otherSection = NUMBER_OF_SECTION_RETURNED;
        }
        else if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_RETURNED)
        {
            currentSubArray = [types objectForKey:numberOfReturned];
            otherSubArray = [types objectForKey:numberOfNeedReturn];
            otherSection = NUMBER_OF_SECTION_NEED_RETURN;
        }
        
        //操作当前类的数据 types对象
        [otherSubArray insertObject:[currentSubArray objectAtIndex:indexPathOfPrevOperationCell.row] atIndex:0];
        [currentSubArray removeLastObject];
        [currentSubArray removeObjectAtIndex:[indexPathOfPrevOperationCell row]];
        
        NSIndexPath *insertIndexPathOfPrevOperationCell = [NSIndexPath indexPathForRow:0 inSection:otherSection];
        
        //操作表格列的增删
        NSArray *insertCells = [NSArray arrayWithObjects:insertIndexPathOfPrevOperationCell,nil];
        NSArray *deleteCells = [NSArray arrayWithObjects:indexPathOfPrevOperationCell,indexPathOfOperationCell,nil];
        
        
        [self.tableView beginUpdates];
        
        [self.tableView insertRowsAtIndexPaths:insertCells withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView deleteRowsAtIndexPaths:deleteCells withRowAnimation:UITableViewRowAnimationRight];
        
        indexPathOfOperationCell = nil;
        indexPathOfPrevOperationCell = nil;
        
        [self.tableView endUpdates];
        
        
    }
}

#pragma mark - 按钮事件

-(void)detail:(id)sender
{
    AddViewController *addViewControllerd = [[AddViewController alloc] init];
    addViewControllerd.title = @"修改";
    NSString *arrayKey = nil;
    if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_NEED_RETURN)
    {
        arrayKey = payItemPayType;
    }
    else if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_RETURNED)
    {
        arrayKey = payItemPayTypeDid;
    }
    [addViewControllerd setPayItemPayType:PayItemPayTypeReceivable];
    [addViewControllerd setUpdate:YES];
    [addViewControllerd setArrayKey:arrayKey];
    PayItem *aPayItem = [[ArchiveUtil shareArchiveUtil] getPayItemIndexOfArray:indexPathOfPrevOperationCell.row FromArrayKey:arrayKey];
    [addViewControllerd setIndexOfArray:indexPathOfPrevOperationCell.row];
    [addViewControllerd setAPayItem:aPayItem];
    [self.navigationController pushViewController:addViewControllerd animated:YES];
    
    
}

- (void)delete:(id)sender
{
    NSMutableArray *array = nil;
    NSString *keyOfData = nil;
    if(indexPathOfPrevOperationCell.section == NUMBER_OF_SECTION_NEED_RETURN)
    {
        array = [types objectForKey:numberOfNeedReturn];
        keyOfData = payItemPayType;
    }
    else if(indexPathOfPrevOperationCell.section == NUMBER_OF_SECTION_RETURNED)
    {
        array = [types objectForKey:numberOfReturned];
        keyOfData = payItemPayTypeDid;
    }
    PayItem *deletePayItem = [[ArchiveUtil shareArchiveUtil] deletePayItemIndex:indexPathOfPrevOperationCell.row fromArrayKey:keyOfData];
    
    [[LocalNotificationUtil sharedLocalNotificationUtil] cancelPayItemLocalNotificationUtilByPayItemId:deletePayItem.payItemId];
    
    [array removeObjectAtIndex:indexPathOfPrevOperationCell.row];
    [array removeLastObject];
    
    NSArray *deleteCells = [NSArray arrayWithObjects:indexPathOfOperationCell,indexPathOfPrevOperationCell,nil];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:deleteCells withRowAnimation:UITableViewRowAnimationRight];
    
    indexPathOfOperationCell = nil;
    indexPathOfPrevOperationCell = nil;
    [self.tableView endUpdates];
}

-(void)didPay:(id)sender
{
    PayItem *movedItem = [[ArchiveUtil shareArchiveUtil] movePayItem:indexPathOfPrevOperationCell.row fromPayItemPayTypeKey:payItemPayType toPayItemPayTypeKey:payItemPayTypeDid];
    [[LocalNotificationUtil sharedLocalNotificationUtil] addPayItemLocalNotificationUtil:movedItem];
    [self closeOptionCellAndMoveOpertionCell];
}


-(void)undo:(id)sender
{
    PayItem *movedItem = [[ArchiveUtil shareArchiveUtil] movePayItem:indexPathOfPrevOperationCell.row fromPayItemPayTypeKey:payItemPayTypeDid toPayItemPayTypeKey:payItemPayType];
    [[LocalNotificationUtil sharedLocalNotificationUtil] addPayItemLocalNotificationUtil:movedItem];
    [self closeOptionCellAndMoveOpertionCell];
}

-(void)import:(id)sender

{
    NSString *arrayKey = nil;
    if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_NEED_RETURN)
    {
        arrayKey = payItemPayType;
    }
    else if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_RETURNED)
    {
        arrayKey = payItemPayTypeDid;
    }
    [[ArchiveUtil shareArchiveUtil] importIndexOfArray:indexPathOfPrevOperationCell.row inArrayKey:arrayKey];
    NSArray *reloadRows = [NSArray arrayWithObject:indexPathOfPrevOperationCell];
    [self.tableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationNone];
    
    NSMutableArray *currentSubArray = nil;
    if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_NEED_RETURN)
    {
        currentSubArray = [types objectForKey:numberOfNeedReturn];
    }
    else if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_RETURNED)
    {
        currentSubArray = [types objectForKey:numberOfReturned];
    }
    [currentSubArray removeLastObject];
    NSArray *deleteCells = [NSArray arrayWithObjects:indexPathOfOperationCell,nil];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:deleteCells withRowAnimation:UITableViewRowAnimationRight];
    
    indexPathOfOperationCell = nil;
    indexPathOfPrevOperationCell = nil;
    
    [self.tableView endUpdates];
}


#pragma mark - Table view data source

#define TABLE_CONTENT_INSET self.tableView.contentInset.top
#define CELL_HEIGHT 75
#define DATE_TAG 101
#define NAME_TAG 102
#define NUMBER_TAG 103
#define IMPORT_TAG 104
#define CREATE_DATE_TAG 105
#define HEADER_HEIGHT 25

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [types count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == NUMBER_OF_SECTION_NEED_RETURN)
        return [[types objectForKey:numberOfNeedReturn] count];
    else if(section == NUMBER_OF_SECTION_RETURNED)
        return [[types objectForKey:numberOfReturned] count];
    return  0;
}

- (BOOL)isExpireDateString:(NSString *)dateString
{
    if(dateString && ![dateString isEqualToString:@""])
    {
        NSDate *date = [NSDate dateWithString:dateString format:@"yyyy-MM-dd HH:mm"];
        NSDate *earlierDate = [[NSDate date] earlierDate:date];
        return earlierDate == date;
    }
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customCell";
    
    if(indexPathOfOperationCell  && indexPath.section == indexPathOfOperationCell.section &&
       indexPath.row == indexPathOfOperationCell.row){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"opertion"];
        
        cell.backgroundView = [[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"buttonStrip2"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *did = [UIButton buttonWithType:UIButtonTypeCustom];
        did.frame = CGRectMake(12*1, 0, 65, CELL_HEIGHT);
        if(indexPath.section ==  NUMBER_OF_SECTION_NEED_RETURN)
        {
            [did setImage:[UIImage imageNamed:@"did_pay"] forState:UIControlStateNormal];
            [did setImage:[UIImage imageNamed:@"did_pay_press"] forState:UIControlStateHighlighted];
            [did addTarget:self action:@selector(didPay:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (indexPath.section == NUMBER_OF_SECTION_RETURNED)
        {
            [did setImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
            [did setImage:[UIImage imageNamed:@"undo_press"] forState:UIControlStateHighlighted];
            [did addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.contentView addSubview:did];
        
        UIButton *import = [UIButton buttonWithType:UIButtonTypeCustom];
        import.frame = CGRectMake(12*2+65, 0, 65, CELL_HEIGHT);
        UIImage *importImage = [UIImage imageNamed:@"import"];
        UIImage *importImagePress = [UIImage imageNamed:@"import_press"];
        [import setImage:importImage forState:UIControlStateNormal];
        [import setImage:importImagePress forState:UIControlStateHighlighted];
        [import addTarget:self action:@selector(import:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:import];
        
        UIButton *detail = [UIButton buttonWithType:UIButtonTypeCustom];
        detail.frame = CGRectMake(12*3+65*2, 0, 65, CELL_HEIGHT);
        [detail setImage:[UIImage imageNamed:@"detail"] forState:UIControlStateNormal];
        [detail setImage:[UIImage imageNamed:@"detail_press"] forState:UIControlStateHighlighted];
        [detail addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:detail];
        
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        delete.frame = CGRectMake(12*4+65*3, 0, 65, CELL_HEIGHT);
        [delete setImage:[UIImage imageNamed:@"bin"] forState:UIControlStateNormal];
        [delete setImage:[UIImage imageNamed:@"bin_press"] forState:UIControlStateHighlighted];
        [delete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:delete];
        
        return cell;
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self getCell:CellIdentifier];
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (UITableViewCell *)getCell:(NSString *)reuseIdentifier
{
    UITableViewCell  *cell = [[PayTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    return cell;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PayItem *item = nil;
    if(indexPath.section == 0){
        if(indexPathOfOperationCell && indexPathOfOperationCell.section == indexPath.section
           && indexPathOfOperationCell.row <= indexPath.row)
            item = (PayItem *)[[types objectForKey:numberOfNeedReturn] objectAtIndex:(indexPath.row-1)];
        else
            item = (PayItem *)[[types objectForKey:numberOfNeedReturn] objectAtIndex:indexPath.row];
        ((UILabel *)[cell.contentView viewWithTag:DATE_TAG]).text = item.dateString;
        
        ((UILabel *)[cell.contentView viewWithTag:NAME_TAG]).text = item.name;
        
        ((UILabel *)[cell.contentView viewWithTag:NUMBER_TAG]).text = [NSString stringWithFormat:@"￥ %@.00",[self moneyStyleFromNormalFloat:[NSMutableString stringWithFormat:@"%.0f" ,item.money,nil]],nil];
        
        ((UILabel *)[cell.contentView viewWithTag:CREATE_DATE_TAG]).text = item.createDateString;
    }
    else if(indexPath.section == 1){
        if(indexPathOfOperationCell && indexPathOfOperationCell.section == indexPath.section
           && indexPathOfOperationCell.row <= indexPath.row)
            item = (PayItem *)[[types objectForKey:numberOfReturned] objectAtIndex:(indexPath.row-1)];
        else
            item = (PayItem *)[[types objectForKey:numberOfReturned] objectAtIndex:indexPath.row];
        
        ((UILabel *)[cell.contentView viewWithTag:DATE_TAG]).text = item.dateString;

        ((UILabel *)[cell.contentView viewWithTag:CREATE_DATE_TAG]).text = item.createDateString;
        
        ((UILabel *)[cell.contentView viewWithTag:NAME_TAG]).text = item.name;
        
        ((UILabel *)[cell.contentView viewWithTag:NUMBER_TAG]).text = [NSString stringWithFormat:@"￥ %@.00",[self moneyStyleFromNormalFloat:[NSMutableString stringWithFormat:@"%.0f" ,item.money,nil]],nil];
    }
    if([self isExpireDateString:item.dateString])
    {
        ((UILabel *)[cell.contentView viewWithTag:NUMBER_TAG]).textColor=[[UIColor alloc] initWithString:@"#ff0000"];
    }
    else{
        ((UILabel *)[cell.contentView viewWithTag:NUMBER_TAG]).textColor=[[UIColor alloc] initWithString:@"#449900"];
    }
    if(item.import)
        [((UIImageView *)[cell.contentView viewWithTag:IMPORT_TAG]) setAlpha:1];
    else
        [((UIImageView *)[cell.contentView viewWithTag:IMPORT_TAG]) setAlpha:0];
}

-(NSString *)moneyStyleFromNormalFloat:(NSMutableString *)normal
{
    int cont=1;
    NSMutableString *result = [[NSMutableString alloc] initWithString:normal];
    for (int i=0; i<normal.length/3; i++) {
        [result insertString:@" " atIndex:normal.length-cont*3];;
        cont++;
    }
    return result;
}

#pragma mark - Table view delegate

- (void)addOneNumberOfRowInSection:(NSInteger)section
{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPathOfOperationCell)
    {
        
        //operation cell 不可点
        if(indexPath.section == indexPathOfOperationCell.section
           && indexPath.row == indexPathOfOperationCell.row)
        {
            return;
        }
        
        
        if(indexPathOfOperationCell
           && indexPath.section == indexPathOfOperationCell.section
           && indexPath.row+1 == indexPathOfOperationCell.row)
        {
            if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_NEED_RETURN)
                [[types objectForKey:numberOfNeedReturn] removeLastObject];
            
            else if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_RETURNED)
                [[types objectForKey:numberOfReturned] removeLastObject];
            
            NSArray *deleteCells = [NSArray arrayWithObject:indexPathOfOperationCell];
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:deleteCells withRowAnimation:UITableViewRowAnimationRight];
            
            indexPathOfOperationCell = nil;
            indexPathOfPrevOperationCell = nil;
            [tableView endUpdates];
            return;
        }
        
        //关闭老的operation cell， 打开新的operation cell
        
        if(indexPath.section == indexPathOfOperationCell.section
           && indexPath.row > indexPathOfOperationCell.row)
        {
            overThanCloseCell = YES;
        }
        if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_NEED_RETURN)
            [[types objectForKey:numberOfNeedReturn] removeLastObject];
        
        else if(indexPathOfOperationCell.section == NUMBER_OF_SECTION_RETURNED)
            [[types objectForKey:numberOfReturned] removeLastObject];
        
        NSArray *deleteCells = [NSArray arrayWithObject:indexPathOfOperationCell];
        [tableView deleteRowsAtIndexPaths:deleteCells withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    
    //将空对象加入到集合
    PayItem *nilItem = [[PayItem alloc] init];
    if(indexPath.section == NUMBER_OF_SECTION_NEED_RETURN)
    {
        [[types objectForKey:numberOfNeedReturn] addObject:nilItem];
    }
    else if(indexPath.section == NUMBER_OF_SECTION_RETURNED)
    {
        [[types objectForKey:numberOfReturned] addObject:nilItem];
    }
    
    
    //先做 删除 再做 新增，所以如果新增cell的在删除cell之下，index会改变
    if(overThanCloseCell)
    {
        indexPathOfOperationCell = indexPath;
        indexPathOfPrevOperationCell = [NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
    }
    else
    {
        indexPathOfOperationCell = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
        indexPathOfPrevOperationCell = indexPath;
    }
    
    NSArray *insertCells = [NSArray arrayWithObject:indexPathOfOperationCell];
    
    overThanCloseCell = NO;
    [tableView insertRowsAtIndexPaths:insertCells withRowAnimation:UITableViewRowAnimationLeft];
    
    //屏幕当前的下边缘
    float downside = self.tableView.frame.size.height;
    
    //设置 操作行 的下线
    float operationDownside = (indexPathOfOperationCell.row+1) * CELL_HEIGHT+HEADER_HEIGHT-self.tableView.contentOffset.y;
    
    if(indexPath.section == NUMBER_OF_SECTION_RETURNED)
    {
        operationDownside += ([self.tableView numberOfRowsInSection:0]*CELL_HEIGHT)+HEADER_HEIGHT;
        
    }
    
    //操作行的下线在屏幕的下边缘之下
    if( downside <  operationDownside)
    {
        CGPoint bottomOffset;
        if (IOS_VERSION >= 7.0) {
            bottomOffset = CGPointMake(self.tableView.contentOffset.x,self.tableView.contentOffset.y+(operationDownside-downside)+44);
        }
        else
        {
            bottomOffset = CGPointMake(self.tableView.contentOffset.x,self.tableView.contentOffset.y+(operationDownside-downside));
        }
        
        [self.tableView setContentOffset:bottomOffset animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == NUMBER_OF_SECTION_NEED_RETURN)
    {
        return 0;
    }
    else if(section == NUMBER_OF_SECTION_RETURNED)
    {
        if(IOS_VERSION >= 7.0)
        {
            return 0;
        }
        return 5;
    }
    return 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == NUMBER_OF_SECTION_NEED_RETURN){
        return [titlesForHeader objectAtIndex:0];
    }
    else if(section == NUMBER_OF_SECTION_RETURNED)
    {
        return [titlesForHeader objectAtIndex:1];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

@end
