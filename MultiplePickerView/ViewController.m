//
//  ViewController.m
//  MultiplePickerView
//
//  Created by Jeevan on 27/09/17.
//  Copyright © 2017 com.axio. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate> {
    UIPickerView *pickerView;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSMutableArray *selectedArray;    // To store which rows are selected
@property (nonatomic, strong) NSArray *dataArray;           // Picker data
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pickerView = [[UIPickerView alloc] init];
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float pickerWidth = screenWidth * 3 / 4;
    
    // Calculate the starting x coordinate.
    float xPoint = 10;//screenWidth / 2 - pickerWidth / 2;
    
    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    
    // Set the picker's frame. We set the y coordinate to 50px.
    [pickerView setFrame: CGRectMake(xPoint, _textField.frame.origin.y + 40, pickerWidth, 200.0f)];
    
    // Before we add the picker view to our view, let's do a couple more
    // things. First, let the selection indicator (that line inside the
    // picker view that highlights your selection) to be shown.
    pickerView.showsSelectionIndicator = YES;
    
    // Allow us to pre-select the third option in the pickerView.
    
    self.selectedArray = [NSMutableArray array];
    self.dataArray = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4"];
    
    // 2. Add tap recognizer to your picker view
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerTapped:)];
    tapRecognizer.delegate = self;
    _textField.inputView = pickerView;
    [pickerView addGestureRecognizer:tapRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (void)pickerTapped:(UITapGestureRecognizer *)tapRecognizer
{
    // 3. Find out wich row was tapped (idea based on https://stackoverflow.com/a/25719326)
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [pickerView rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(pickerView.bounds, 0.0, (CGRectGetHeight(pickerView.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:pickerView]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            NSUInteger index = [self.selectedArray indexOfObject:[NSNumber numberWithInteger:selectedRow]];
            
            if (index != NSNotFound) {
                NSLog(@"Row %ld OFF", (long)selectedRow);
                [self.selectedArray removeObjectAtIndex:index];
            } else {
                NSLog(@"Row %ld ON",  (long)selectedRow);
                [self.selectedArray addObject:[NSNumber numberWithInteger:selectedRow]];
            }
            // I don't know why calling reloadAllComponents sometimes scrolls to the first row
            //[self.pickerView reloadAllComponents];
            // This workaround seems to work correctly:
            pickerView.dataSource = self;
            NSLog(@"Rows reloaded");
        }
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
 
    UITableViewCell *cell = (UITableViewCell *)view;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBounds: CGRectMake(0, 0, cell.frame.size.width -20 , 44)];
    }
    
    BOOL isSelected = [self.selectedArray indexOfObject:[NSNumber numberWithInteger:row]] != NSNotFound;
    NSString *text = [self.dataArray objectAtIndex:row];
    
    if (isSelected) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    cell.textLabel.text = text;
    cell.tag = row;
    
    return cell;
    

}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    [_textField setText:[_dataArray objectAtIndex: row]];
    

    NSMutableArray *arr = [NSMutableArray array];
    
    int index;
    for (NSString *str in _selectedArray)
    {
        index = [str intValue];
        [arr addObject:_dataArray[index]];
        //do stuff using index
    }

    [_textField setText:[arr componentsJoinedByString:@","]];

}

@end
