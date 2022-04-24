//
//  JHGJudgeTextField.h
//
//
//  Created by JasonHu on 2021/6/2.
//  Copyright © 2021 JasonHu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JHMacroTools.h"

typedef BOOL (^JHGJudgeTextFieldBlock)(NSString *input);

@interface JHGJudgeTextField : UITextField

@property (nonatomic, copy) JHGJudgeTextFieldBlock judgeBlock;

- (void)setupJudgementWithBlock:(JHGJudgeTextFieldBlock)judgeBlock;

@end

