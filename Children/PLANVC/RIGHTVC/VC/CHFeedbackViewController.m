//
//  CHFeedbackViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/23.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHFeedbackViewController.h"

@interface CHFeedbackViewController ()
@property (nonatomic, strong) UITextView *problemText;
@property (nonatomic, strong) CHTextField *contactField;
@property (nonatomic, strong) CHButton *feedbackBut;
@property (nonatomic, strong) CHLabel *wordsNum;
@end

@implementation CHFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.title = CHLocalizedString(@"意见反馈", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    CHLabel *problemLab = [CHLabel createWithTit:CHLocalizedString(@"问题详情", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:problemLab];
    
    CHLabel *line0 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 0.8) textAlignment:0];
    [self.view addSubview:line0];
    
    self.problemText = [[UITextView alloc] init];
    self.problemText.delegate = self;
    self.problemText.textColor = CHUIColorFromRGB(0xbdbdbd, 1.0);
    self.problemText.text = CHLocalizedString(@"请详细描述您遇到的问题，我们会仔细聆听", nil);
    [self.view addSubview:self.problemText];
    
    _wordsNum = [CHLabel createWithTit:@"500/500" font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:2];
    [self.view addSubview:_wordsNum];
    
    CHLabel *line1 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 0.8) textAlignment:0];
    [self.view addSubview:line1];
    
    CHLabel *line2 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 0.8) textAlignment:0];
    [self.view addSubview:line2];
    
    CHLabel *contactLab = [CHLabel createWithTit:CHLocalizedString(@"联系方式", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:contactLab];
    
    CHLabel *line3 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 0.8) textAlignment:0];
    [self.view addSubview:line3];
    
    self.contactField = [CHTextField createWithPlace:CHLocalizedString(@"请留下电话或邮箱,方便我们联系您 ", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 14)];
    self.contactField.delegate = self;
    [self.view addSubview:self.contactField];
    
    CHLabel *line4 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 0.8) textAlignment:0];
    [self.view addSubview:line4];
    
    self.feedbackBut = [CHButton createWithTit:CHLocalizedString(@"提交", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        
    }];
    _feedbackBut.enabled = NO;
    [self.view addSubview:self.feedbackBut];
    
    [problemLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    
    [line0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(problemLab.mas_bottom).mas_offset(8);
        make.right.mas_equalTo(-25);
        make.left.mas_equalTo(25);
        make.height.mas_equalTo(1);
    }];
    
    [self.problemText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line0).mas_offset(4);
        make.right.mas_equalTo(-30);
        make.left.mas_equalTo(35);
        make.height.mas_equalTo(CHMainScreen.size.height/3.5);
    }];
    
    [_wordsNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.problemText.mas_bottom).mas_offset(1);
        make.right.mas_equalTo(-30);
    }];
    
    [line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_wordsNum.mas_bottom).mas_offset(4);
        make.right.mas_equalTo(-25);
        make.left.mas_equalTo(25);
        make.height.mas_equalTo(1);
    }];
    
    [line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(-25);
        make.left.mas_equalTo(25);
        make.height.mas_equalTo(1);
    }];
    
    [contactLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
    }];
    
    [line3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contactLab.mas_bottom).mas_offset(8);
        make.right.mas_equalTo(-25);
        make.left.mas_equalTo(25);
        make.height.mas_equalTo(1);
    }];
    
    [_contactField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line3.mas_bottom).mas_offset(4);
        make.right.mas_equalTo(-35);
        make.left.mas_equalTo(35);
        make.height.mas_equalTo(33);
    }];
    
    [line4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contactField.mas_bottom).mas_offset(4);
        make.right.mas_equalTo(-25);
        make.left.mas_equalTo(25);
        make.height.mas_equalTo(1);
    }];
    
    [self.feedbackBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *realTextViewText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果有高亮
    if (selectedRange&&pos) {
        return YES;
    }
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
    }
    else{
        _wordsNum.text = [NSString stringWithFormat:@"%lu/500",500 - realTextViewText.length];
    }
    if (realTextViewText.length > 0 && _contactField.text.length > 0 && ![realTextViewText isEqualToString:@"\n"]) {
        _feedbackBut.enabled = YES;
    }else{
        _feedbackBut.enabled = NO;
    }
    if (realTextViewText.length > 500) {
        NSInteger length = text.length + 500 - realTextViewText.length;
        NSRange rg = {0,MAX(length,0)};
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *realTextViewText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textField resignFirstResponder];
    }
    //如果有高亮
    if (selectedRange&&pos) {
        return YES;
    }
    if (realTextViewText.length > 0 && _problemText.text.length > 0 && ![_problemText.text isEqualToString:CHLocalizedString(@"请详细描述您遇到的问题，我们会仔细聆听", nil)] && ![realTextViewText isEqualToString:@"\n"]) {
        _feedbackBut.enabled = YES;
    }
    else{
        _feedbackBut.enabled = NO;
    }
    if (realTextViewText.length > 100) {
        NSInteger length = string.length + 100 - realTextViewText.length;
        NSRange rg = {0,MAX(length,0)};
        if (rg.length>0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:CHLocalizedString(@"请详细描述您遇到的问题，我们会仔细聆听", nil)]) {
        textView.text = @"";
        textView.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length < 1) {
        textView.text = CHLocalizedString(@"请详细描述您遇到的问题，我们会仔细聆听", nil);
        textView.textColor = CHUIColorFromRGB(0xbdbdbd, 1.0);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
