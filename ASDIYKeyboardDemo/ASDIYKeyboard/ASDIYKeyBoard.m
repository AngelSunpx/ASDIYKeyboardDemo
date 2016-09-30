//
//  ASDIYKeyBoard.m
//  ASDIYKeyboardDemo
//
//  Created by 孙攀翔 on 30/9/2016.
//  Copyright © 2016 AngelSun. All rights reserved.
//

#import "ASDIYKeyBoard.h"

//键盘宽度
#define RANDOMKEYBOARD_WIDTH            [UIScreen mainScreen].bounds.size.width
//键盘高度
#define RANDOMKEYBOARD_HEIGHT           RANDOMKEYBOARD_WIDTH*216/320
//键盘按钮高度
#define RANDOMKEYBOARD_BTN_HEIGHT       (RANDOMKEYBOARD_HEIGHT-60)/4
//键盘背景色
#define RANDOMKEYBOARD_BACKGROUNDCOLOR  [UIColor colorWithRed:(float)229/255.0f green:(float)229/255.0f blue:(float)231/255.0f alpha:1.0]
//固定按钮颜色
#define RANDOMKEYBOARD_CONSTANTBTNCOLOR [UIColor colorWithRed:(float)193/255.0f green:(float)195/255.0f blue:(float)199/255.0f alpha:1.0]
//按钮按下颜色
#define RANDOMKEYBOARD_BTNPRESSCOLOR    [UIColor colorWithRed:(float)133/255.0f green:(float)133/255.0f blue:(float)133/255.0f alpha:1.0]

#define STR_RETURN              @"完成"
#define STR_SPACE               @"空格"
#define STR_CHANGEBOARD_A       @"#+123"
#define STR_CHANGEBOARD_B       @"ABC"
#define STR_CHANGESYMBOL_A      @"#+="
#define STR_CHANGESYMBOL_B      @"123"

#define kChar_Letter_Arr        @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"]
#define kChar_Number_Arr        @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"]
#define kChar_Symbol_A_Arr      @[@"-",@"/",@":",@";",@"(",@")",@"$",@"&",@"@",@"\""]
#define kChar_Symbol_B_Arr      @[@"[",@"]",@"{",@"}",@"#",@"%",@"^",@"*",@"+",@"=",@"_",@"\\",@"|",@"~",@"<",@">",@"€",@"£",@"¥",@"·"]
#define kChar_Punctuation_Arr   @[@".",@",",@"?",@"!",@"'"]
#define kChar_Space             @" "
#define kChar_Backward          @""

static const CGFloat BTNCORNERRADIUS = 6.0; //按钮圆角
static const CGFloat BORDERWIDTH = 0.3;     //按钮边框
static const CGFloat BTNFONT = 15;          //字体大小

@implementation ASDIYKeyBoard
{
    NSArray *_letterArr;                    //小写字母字符
    NSArray *_upperLetterArr;               //大写字母字符
    NSArray *_numberArr;                    //数字字符
    NSArray *_symbolArr_A;                  //符号字符A
    NSArray *_symbolArr_B;                  //符号字符B
    
    NSMutableArray *_letterBtnArray;        //字母按钮数组
    NSMutableArray *_numberBtnArray;        //数字按钮数组
    NSMutableArray *_symbolBtnArray;        //符号按钮数组
    NSMutableArray *_numAndSymBtnArray;     //数字+符号按钮数组
    NSMutableArray *_punctuationBtnArray;   //标点符号数组
    
    UIButton *_returnBtn;                   //完成
    UIButton *_spaceBtn;                    //空格
    UIButton *_changeBoardBtn;              //字母、数字字符键盘切换
    UIButton *_deleteBtn;                   //退格
    UIButton *_capsLockBtn;                 //大小写切换
    UIButton *_changeSymbolBtn;             //更多字符切换
    
    UIImage *_backImageHighlight;           //按钮按下背景图
    
    BOOL _isLetterBoard;                    //切换字母键盘标识
    BOOL _isNumberBoard;                    //切换数字、更多字符标识
    BOOL _isUppercase;                      //大小写切换标识
}

@synthesize textInput = _textInput;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBounds:CGRectMake(0, 0, RANDOMKEYBOARD_WIDTH, RANDOMKEYBOARD_HEIGHT)];
        [self setBackgroundColor:RANDOMKEYBOARD_BACKGROUNDCOLOR];
        
        _backImageHighlight = [self imageFromColor:RANDOMKEYBOARD_BTNPRESSCOLOR];
        
        [self initCharacter];
        
        _letterBtnArray = [NSMutableArray new];
        _numberBtnArray = [NSMutableArray new];
        _symbolBtnArray = [NSMutableArray new];
        _numAndSymBtnArray = [NSMutableArray new];
        _punctuationBtnArray = [NSMutableArray new];
        
        _isLetterBoard = YES;
        _isNumberBoard = YES;
        _isUppercase = NO;
        
        [self initConstantBtn];//固定按钮
        [self initLetterBtn];//字母按钮
        [self initNumAndSymbolBtn];//数字符号标点按钮
        
        [self loadCharaterOnBtn];
    }
    return self;
}

- (void)setTextInput:(id<UITextInput>)textInput
{
    if ([textInput isKindOfClass:[UITextField class]]) {
        [(UITextField *)textInput setInputView:self];
    } else if ([textInput isKindOfClass:[UITextView class]]){
        [(UITextView *)textInput setInputView:self];
        [_returnBtn setTitle:@"换行" forState:UIControlStateNormal];
    }
    _textInput = textInput;
}

- (id<UITextInput>)textInput
{
    return _textInput;
}

#pragma mark - init method
- (void)initCharacter
{
    _letterArr = [self randomizedArray:kChar_Letter_Arr];
//    _letterArr = kChar_Letter_Arr;
    _upperLetterArr = [self uppercaseArray:_letterArr];
    _numberArr = [self randomizedArray:kChar_Number_Arr];
    _symbolArr_A = [self randomizedArray:kChar_Symbol_A_Arr];
    _symbolArr_B = [self randomizedArray:kChar_Symbol_B_Arr];
}

- (void)initConstantBtn
{
    _returnBtn = [self creatButtonWithFrame:CGRectMake(RANDOMKEYBOARD_WIDTH-3-74*(RANDOMKEYBOARD_WIDTH-18)/302, RANDOMKEYBOARD_HEIGHT-3-RANDOMKEYBOARD_BTN_HEIGHT, 74*(RANDOMKEYBOARD_WIDTH-18)/302, RANDOMKEYBOARD_BTN_HEIGHT)];
    [_returnBtn setBackgroundColor:RANDOMKEYBOARD_CONSTANTBTNCOLOR];
    [_returnBtn setTitle:STR_RETURN forState:UIControlStateNormal];
    [_returnBtn addTarget:self action:@selector(btnReturn:) forControlEvents:UIControlEventTouchUpInside];
    
    _spaceBtn = [self creatButtonWithFrame:CGRectMake(74*(RANDOMKEYBOARD_WIDTH-18)/302+9, RANDOMKEYBOARD_HEIGHT-3-RANDOMKEYBOARD_BTN_HEIGHT, 154*(RANDOMKEYBOARD_WIDTH-18)/302, RANDOMKEYBOARD_BTN_HEIGHT)];
    [_spaceBtn setTitle:STR_SPACE forState:UIControlStateNormal];
    [_spaceBtn addTarget:self action:@selector(btnSpace:) forControlEvents:UIControlEventTouchUpInside];
    
    _changeBoardBtn = [self creatButtonWithFrame:CGRectMake(3, RANDOMKEYBOARD_HEIGHT-3-RANDOMKEYBOARD_BTN_HEIGHT, 74*(RANDOMKEYBOARD_WIDTH-18)/302, RANDOMKEYBOARD_BTN_HEIGHT)];
    [_changeBoardBtn setBackgroundColor:RANDOMKEYBOARD_CONSTANTBTNCOLOR];
    [_changeBoardBtn setTitle:STR_CHANGEBOARD_A forState:UIControlStateNormal];
    [_changeBoardBtn addTarget:self action:@selector(btnChangeBoard:) forControlEvents:UIControlEventTouchUpInside];
    
    _deleteBtn = [self creatButtonWithFrame:CGRectMake(RANDOMKEYBOARD_WIDTH-3-(RANDOMKEYBOARD_WIDTH-68)/7, RANDOMKEYBOARD_HEIGHT-18-RANDOMKEYBOARD_BTN_HEIGHT*2, (RANDOMKEYBOARD_WIDTH-68)/7, RANDOMKEYBOARD_BTN_HEIGHT)];
    [_deleteBtn setBackgroundColor:RANDOMKEYBOARD_CONSTANTBTNCOLOR];
    [_deleteBtn setImage:[UIImage imageNamed:@"deleteChar"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(btnDeleteChar:) forControlEvents:UIControlEventTouchUpInside];
    
    _capsLockBtn = [self creatButtonWithFrame:CGRectMake(3, RANDOMKEYBOARD_HEIGHT-18-RANDOMKEYBOARD_BTN_HEIGHT*2, (RANDOMKEYBOARD_WIDTH-68)/7, RANDOMKEYBOARD_BTN_HEIGHT)];
    [_capsLockBtn setBackgroundColor:RANDOMKEYBOARD_CONSTANTBTNCOLOR];
    [_capsLockBtn setImage:[UIImage imageNamed:@"capsLock"] forState:UIControlStateNormal];
    [_capsLockBtn addTarget:self action:@selector(btnCapsLock:) forControlEvents:UIControlEventTouchUpInside];
    
    _changeSymbolBtn = [self creatButtonWithFrame:CGRectMake(3, RANDOMKEYBOARD_HEIGHT-18-RANDOMKEYBOARD_BTN_HEIGHT*2, (RANDOMKEYBOARD_WIDTH-68)/7, RANDOMKEYBOARD_BTN_HEIGHT)];
    [_changeSymbolBtn setBackgroundColor:RANDOMKEYBOARD_CONSTANTBTNCOLOR];
    [_changeSymbolBtn setTitle:STR_CHANGESYMBOL_A forState:UIControlStateNormal];
    [_changeSymbolBtn addTarget:self action:@selector(btnchangeSymbol:) forControlEvents:UIControlEventTouchUpInside];
    [_changeSymbolBtn setHidden:YES];
}

- (void)initLetterBtn
{
    for (int i = 0; i < 10; i++) {
        UIButton *btn = [self creatButtonWithFrame:CGRectMake(3+(6+(RANDOMKEYBOARD_WIDTH-60)/10)*i, 12, (RANDOMKEYBOARD_WIDTH-60)/10, RANDOMKEYBOARD_BTN_HEIGHT)];
        [btn addTarget:self action:@selector(characterPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_letterBtnArray addObject:btn];
    }
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [self creatButtonWithFrame:CGRectMake(19+(6+(RANDOMKEYBOARD_WIDTH-60)/10)*i, 27+RANDOMKEYBOARD_BTN_HEIGHT, (RANDOMKEYBOARD_WIDTH-60)/10, RANDOMKEYBOARD_BTN_HEIGHT)];
        [btn addTarget:self action:@selector(characterPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_letterBtnArray addObject:btn];
    }
    for (int i = 0; i < 7; i++) {
        UIButton *btn = [self creatButtonWithFrame:CGRectMake(15+(RANDOMKEYBOARD_WIDTH-68)/7+(6+(RANDOMKEYBOARD_WIDTH-60)/10)*i, RANDOMKEYBOARD_HEIGHT-18-RANDOMKEYBOARD_BTN_HEIGHT*2, (RANDOMKEYBOARD_WIDTH-60)/10, RANDOMKEYBOARD_BTN_HEIGHT)];
        [btn addTarget:self action:@selector(characterPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_letterBtnArray addObject:btn];
    }
}

- (void)initNumAndSymbolBtn
{
    for (int i = 0; i < 10; i++) {
        UIButton *btn = [self creatButtonWithFrame:CGRectMake(3+(6+(RANDOMKEYBOARD_WIDTH-60)/10)*i, 12, (RANDOMKEYBOARD_WIDTH-60)/10, RANDOMKEYBOARD_BTN_HEIGHT)];
        [btn addTarget:self action:@selector(characterPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setHidden:YES];
        [_numberBtnArray addObject:btn];
        [_numAndSymBtnArray addObject:btn];
    }
    
    for (int i = 0; i < 10; i++) {
        UIButton *btn = [self creatButtonWithFrame:CGRectMake(3+(6+(RANDOMKEYBOARD_WIDTH-60)/10)*i, 27+RANDOMKEYBOARD_BTN_HEIGHT, (RANDOMKEYBOARD_WIDTH-60)/10, RANDOMKEYBOARD_BTN_HEIGHT)];
        [btn addTarget:self action:@selector(characterPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setHidden:YES];
        [_symbolBtnArray addObject:btn];
        [_numAndSymBtnArray addObject:btn];
    }
    
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [self creatButtonWithFrame:CGRectMake(22+(RANDOMKEYBOARD_WIDTH-68)/7+(6+(RANDOMKEYBOARD_WIDTH-68)/7)*i, RANDOMKEYBOARD_HEIGHT-18-RANDOMKEYBOARD_BTN_HEIGHT*2, (RANDOMKEYBOARD_WIDTH-68)/7, RANDOMKEYBOARD_BTN_HEIGHT)];
        [btn addTarget:self action:@selector(characterPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setHidden:YES];
        [_punctuationBtnArray addObject:btn];
    }
}

- (void)loadCharaterOnBtn
{
    [self loadCharWithCharArray:_letterArr inBtnArray:_letterBtnArray];
    [self loadCharWithCharArray:_numberArr inBtnArray:_numberBtnArray];
    [self loadCharWithCharArray:_symbolArr_A inBtnArray:_symbolBtnArray];
    [self loadCharWithCharArray:kChar_Punctuation_Arr inBtnArray:_punctuationBtnArray];
}

#pragma mark - handle method
- (void)characterPressed:(UIButton *)sender
{
    [[UIDevice currentDevice] playInputClick];
    
    UIButton *btn = (UIButton *)sender;
    NSString *character = [NSString stringWithString:btn.titleLabel.text];
    
    if ([self.textInput isKindOfClass:[UITextField class]]) {
        NSString *text = [(UITextField *)self.textInput text];
        NSRange range = NSMakeRange(text.length, 0);
        
        if ([[(UITextField *)self.textInput delegate] respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            [[(UITextField *)self.textInput delegate] textField:(UITextField *)self.textInput shouldChangeCharactersInRange:range replacementString:character];
        }
    } else if ([self.textInput isKindOfClass:[UITextView class]]) {
        NSString *text = [(UITextView *)self.textInput text];
        NSRange range = NSMakeRange(text.length, 0);
        
        if ([[(UITextView *)self.textInput delegate] respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            [[(UITextView *)self.textInput delegate] textView:(UITextView *)self.textInput shouldChangeTextInRange:range replacementText:character];
        }
    }
    
    [self.textInput insertText:character];
}

- (void)btnReturn:(UIButton *)sender
{
    NSLog(@"Return");
    
    [[UIDevice currentDevice] playInputClick];
    
    if ([self.textInput isKindOfClass:[UITextField class]]) {
        if ([[(UITextField *)self.textInput delegate] respondsToSelector:@selector(textFieldShouldReturn:)]) {
            [[(UITextField *)self.textInput delegate] textFieldShouldReturn:(UITextField *)self.textInput];
        }
    } else if ([self.textInput isKindOfClass:[UITextView class]]) {
        NSString *text = [(UITextView *)self.textInput text];
        NSRange range = NSMakeRange(text.length, 0);
        
        if ([[(UITextView *)self.textInput delegate] respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            [[(UITextView *)self.textInput delegate] textView:(UITextView *)self.textInput shouldChangeTextInRange:range replacementText:@"\n"];
        }
        
        [self.textInput insertText:@"\n"];
    }
}

- (void)btnSpace:(UIButton *)sender
{
    NSLog(@"Space");
    
    [[UIDevice currentDevice] playInputClick];
    
    if ([self.textInput isKindOfClass:[UITextField class]]) {
        NSString *text = [(UITextField *)self.textInput text];
        NSRange range = NSMakeRange(text.length, 0);
        
        if ([[(UITextField *)self.textInput delegate] respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            [[(UITextField *)self.textInput delegate] textField:(UITextField *)self.textInput shouldChangeCharactersInRange:range replacementString:kChar_Space];
        }
    } else if ([self.textInput isKindOfClass:[UITextView class]]) {
        NSString *text = [(UITextView *)self.textInput text];
        NSRange range = NSMakeRange(text.length, 0);
        
        if ([[(UITextView *)self.textInput delegate] respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            [[(UITextView *)self.textInput delegate] textView:(UITextView *)self.textInput shouldChangeTextInRange:range replacementText:kChar_Space];
        }
    }
    
    [self.textInput insertText:kChar_Space];
}

- (void)btnChangeBoard:(UIButton *)sender
{
    NSLog(@"ChangeBoard");
    
    [[UIDevice currentDevice] playInputClick];
    
    [self switchBoard];
}

- (void)btnDeleteChar:(UIButton *)sender
{
    NSLog(@"DeleteChar");
    
    [[UIDevice currentDevice] playInputClick];
    
    if ([self.textInput isKindOfClass:[UITextField class]]) {
        NSString *text = [(UITextField *)self.textInput text];
        if ([text isEqualToString:@""]) {
            return;
        }
        NSRange range = NSMakeRange(text.length - 1, 1);
        
        if ([[(UITextField *)self.textInput delegate] respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            [[(UITextField *)self.textInput delegate] textField:(UITextField *)self.textInput shouldChangeCharactersInRange:range replacementString:kChar_Backward];
        }
    } else if ([self.textInput isKindOfClass:[UITextView class]]) {
        NSString *text = [(UITextView *)self.textInput text];
        if ([text isEqualToString:@""]) {
            return;
        }
        NSRange range = NSMakeRange(text.length - 1, 1);
        
        if ([[(UITextView *)self.textInput delegate] respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            [[(UITextView *)self.textInput delegate] textView:(UITextView *)self.textInput shouldChangeTextInRange:range replacementText:kChar_Backward];
        }
    }
    
    [self.textInput deleteBackward];
}

- (void)btnCapsLock:(UIButton *)sender
{
    NSLog(@"CapsLock");
    
    [[UIDevice currentDevice] playInputClick];
    
    [self switchCapsLock];
}

- (void)btnchangeSymbol:(UIButton *)sender
{
    NSLog(@"ChangeSymbol");
    
    [[UIDevice currentDevice] playInputClick];
    
    [self switchSymbol];
}

#pragma mark - other method
- (void)switchCapsLock
{
    if (!_isUppercase) {
        [_capsLockBtn setImage:[UIImage imageNamed:@"capsLockUpper"] forState:UIControlStateNormal];
        [_capsLockBtn setBackgroundColor:[UIColor colorWithRed:(float)52/255.0f green:(float)52/255.0f blue:(float)52/255.0f alpha:1.0]];
        
        [self loadCharWithCharArray:_upperLetterArr inBtnArray:_letterBtnArray];
    } else {
        [_capsLockBtn setImage:[UIImage imageNamed:@"capsLock"] forState:UIControlStateNormal];
        [_capsLockBtn setBackgroundColor:RANDOMKEYBOARD_CONSTANTBTNCOLOR];
        
        [self loadCharWithCharArray:_letterArr inBtnArray:_letterBtnArray];
    }
    _isUppercase = !_isUppercase;
}

- (void)switchSymbol
{
    if (!_isNumberBoard) {
        [_changeSymbolBtn setTitle:STR_CHANGESYMBOL_A forState:UIControlStateNormal];
        
        [self loadCharWithCharArray:_numberArr inBtnArray:_numberBtnArray];
        [self loadCharWithCharArray:_symbolArr_A inBtnArray:_symbolBtnArray];
    } else {
        [_changeSymbolBtn setTitle:STR_CHANGESYMBOL_B forState:UIControlStateNormal];
        
        [self loadCharWithCharArray:_symbolArr_B inBtnArray:_numAndSymBtnArray];
    }
    _isNumberBoard = !_isNumberBoard;
}

- (void)switchBoard
{
    if (!_isLetterBoard) {
        for (UIButton *btn in _letterBtnArray){
            [btn setHidden:NO];
        }
        for (UIButton *btn in _numberBtnArray){
            [btn setHidden:YES];
        }
        for (UIButton *btn in _symbolBtnArray){
            [btn setHidden:YES];
        }
        for (UIButton *btn in _punctuationBtnArray){
            [btn setHidden:YES];
        }
        [_capsLockBtn setHidden:NO];
        [_changeSymbolBtn setHidden:YES];
        [_changeBoardBtn setTitle:STR_CHANGEBOARD_A forState:UIControlStateNormal];
        if (!_isNumberBoard) {
            [self switchSymbol];
        }
    } else {
        for (UIButton *btn in _letterBtnArray){
            [btn setHidden:YES];
        }
        for (UIButton *btn in _numberBtnArray){
            [btn setHidden:NO];
        }
        for (UIButton *btn in _symbolBtnArray){
            [btn setHidden:NO];
        }
        for (UIButton *btn in _punctuationBtnArray){
            [btn setHidden:NO];
        }
        [_capsLockBtn setHidden:YES];
        [_changeSymbolBtn setHidden:NO];
        [_changeBoardBtn setTitle:STR_CHANGEBOARD_B forState:UIControlStateNormal];
        if (_isUppercase) {
            [self switchCapsLock];
        }
    }
    _isLetterBoard = !_isLetterBoard;
}

- (void)loadCharWithCharArray:(NSArray *)charArray inBtnArray:(NSMutableArray *)btnArray
{
    int i = 0;
    for (UIButton *btn in btnArray){
        [btn setTitle:[charArray objectAtIndex:i] forState:UIControlStateNormal];
        i++;
    }
}

- (void)resetKeyBoardCharacter
{
    [self initCharacter];
    [self loadCharaterOnBtn];
    
    _isLetterBoard = NO;
    [self switchBoard];
    
    _isUppercase = YES;
    [self switchCapsLock];
    
    NSLog(@"ReSet KeyBoard");
}

#pragma mark - custom method
//Creat Image With Color
- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

//Creat Custom Button
- (UIButton *)creatButtonWithFrame:(CGRect)frame
{
    UIButton *cusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cusBtn setBackgroundColor:[UIColor whiteColor]];
    [cusBtn setFrame:frame];
    [cusBtn setBackgroundImage:_backImageHighlight forState:UIControlStateHighlighted];
    [cusBtn.layer setCornerRadius:BTNCORNERRADIUS];
    [cusBtn.layer setBorderWidth:BORDERWIDTH];
    [cusBtn.layer setMasksToBounds:YES];
    [cusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cusBtn.titleLabel setFont:[UIFont systemFontOfSize:BTNFONT]];
    [self addSubview:cusBtn];
    
    return cusBtn;
}

//Random Char
- (NSArray *)randomizedArray:(NSArray *)array
{
    NSMutableArray *results = [NSMutableArray arrayWithArray:array];
    
    int i = (int)[results count];
    while(--i > 0) {
        srand((unsigned int)time(NULL));
        int j = rand() % (i+1);
        [results exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    return [NSArray arrayWithArray:results];
}

//Uppercase Char
- (NSArray *)uppercaseArray:(NSArray *)array
{
    NSMutableArray *results = [NSMutableArray new];
    for (NSString *str in array){
        NSString *upperStr = [str uppercaseString];
        [results addObject:upperStr];
    }
    
    return [NSArray arrayWithArray:results];
}

#pragma mark - UIInputViewAudioFeedback
- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

@end
