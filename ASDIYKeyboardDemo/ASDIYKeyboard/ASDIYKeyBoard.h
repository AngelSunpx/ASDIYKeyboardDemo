//
//  ASDIYKeyBoard.h
//  ASDIYKeyboardDemo
//
//  Created by 孙攀翔 on 30/9/2016.
//  Copyright © 2016 AngelSun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASDIYKeyBoard : UIView <UIInputViewAudioFeedback>

@property (nonatomic, strong) id <UITextInput> textInput;

//重新随机排序键盘字符
- (void)resetKeyBoardCharacter;

@end
