//
//  JHGJudgeTextField.m
//  
//
//  Created by JasonHu on 2021/6/2.
//  Copyright © 2021 JasonHu. All rights reserved.
//

#import "JHGJudgeTextField.h"

@interface JHGJudgeTextField ()

@property (nonatomic, copy) NSString *strLastTime;

@end

@implementation JHGJudgeTextField


- (void)setupJudgementWithBlock:(JHGJudgeTextFieldBlock)judgeBlock
{
    self.judgeBlock = judgeBlock;
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        
        if (self.judgeBlock) {
            BOOL allow = self.judgeBlock(self.text);
            if (!allow) {
                self.text = self.strLastTime;
            }
        }
        self.strLastTime = self.text;
    }];

}

@end
