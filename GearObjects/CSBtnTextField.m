//
//  CSTextField.m
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 14..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSBtnTextField.h"

@implementation CSBtnTextField

-(id) object
{
    return ((UIView*)csView);
}

//===========================================================================
#pragma mark -

-(void) setText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        [((UITextField*)csView) setText:txt];

    else if([txt isKindOfClass:[NSNumber class]] )
        [((UITextField*)csView) setText:[((NSNumber*)txt) stringValue]];
}

-(NSString*) getText
{
    return ((UITextField*)csView).text;
}

-(void) setTextColor:(UIColor*)color
{
    [((UITextField*)csView) setTextColor:color];
}

-(UIColor*) getTextColor
{
    return ((UITextField*)csView).textColor;
}

-(void) setBackgroundColor:(UIColor*)color
{
    [((UITextField*)csView) setBackgroundColor:color];
}

-(UIColor*) getBackgroundColor
{
    return ((UITextField*)csView).backgroundColor;
}

-(void) setFont:(UIFont*)font
{
    [((UITextField*)csView) setFont:font];
}
-(UIFont*) getFont
{
    return ((UITextField*)csView).font;
}

-(void) setTextAlignment:(NSNumber*)alignNum
{
    UITextAlignment align = [alignNum integerValue];
    [((UITextField*)csView) setTextAlignment:align];
}

-(NSNumber*) getTextAlignment
{
    return [NSNumber numberWithInteger:((UITextField*)csView).textAlignment];
}

-(void) setButtonBackgroundColor:(UIColor*)color
{
    [confirmButton.layer setBackgroundColor:color.CGColor];
}

-(UIColor*) getButtonBackgroundColor
{
    return( [UIColor colorWithCGColor: confirmButton.layer.backgroundColor ] );
}

-(void) setButtonText:(NSString*)txt
{
    [confirmButton setTitle:txt];
}

-(NSString*) getButtonText
{
    return confirmButton.titleLabel.text;
}

//===========================================================================


#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;

    csView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, MINSIZE2)];
    [csView setBackgroundColor:[UIColor clearColor]];

    txtField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250, MINSIZE2)];
    [txtField setBackgroundColor:[UIColor whiteColor]];
    [txtField setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

    confirmButton = [[BButton alloc] initWithFrame:CGRectMake(251, 0, 70, MINSIZE2)];
    [confirmButton addTarget:self action:@selector(confirmAction:)];
    [confirmButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight];
    [confirmButton.titleLabel setFont:CS_FONT(13)];
    [confirmButton setTitle:@"Confirm"];

    [csView addSubview:txtField];
    [csView addSubview:confirmButton];

    csCode = CS_BTNTEXTFIELD;

    txtField.textColor = [UIColor blackColor];
    txtField.font = CS_FONT(16);
    [txtField setText:NSLocalizedString(@"Text Field",@"Text Field")];
    [txtField setBorderStyle:UITextBorderStyleRoundedRect];
    [txtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [txtField setDelegate:self];
    [txtField setClearButtonMode:UITextFieldViewModeWhileEditing];

    self.info = NSLocalizedString(@"Button Text Field", @"Button Text Field");

    NSDictionary *d1 = MAKE_PROPERTY_D(@"Default Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Text Color", P_COLOR, @selector(setTextColor:),@selector(getTextColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Background Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"L/R Alignment", P_ALIGN, @selector(setTextAlignment:),@selector(getTextAlignment));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"Button Text", P_TXT, @selector(setButtonText:),@selector(getButtonText));
    NSDictionary *d7 = MAKE_PROPERTY_D(@"Button Background Color", P_COLOR, @selector(setButtonBackgroundColor:),@selector(getButtonBackgroundColor));

    pListArray = [NSArray arrayWithObjects:d1,d2,d3,d4,d5,d6,d7, nil];

    NSMutableDictionary MAKE_ACTION_D(@"Enter Text", A_TXT, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Close Keyboard", A_TXT, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Confirm Button", A_TXT, a3);
    actionArray = [NSArray arrayWithObjects:a1, a2, a3, nil];

    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if( (self=[super initWithCoder:aDecoder]) ){
        txtField = [aDecoder decodeObjectForKey:@"txtField"];
        [txtField setDelegate:self];
        confirmButton = [aDecoder decodeObjectForKey:@"confirmButton"];
        [confirmButton addTarget:self action:@selector(confirmAction:)];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:txtField forKey:@"txtField"];
    [encoder encodeObject:confirmButton forKey:@"confirmButton"];
}

#pragma mark - Gear's Unique Actions

// Enter Text 동작.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];

    SEL act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
    
    if( nil == act ) return YES;  // do nothing
    
    NSNumber *nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
    
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:textField.text];
        else
            ; // todo: error handleing
    }
    return YES;
}


// End Text Editing 동작.
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    SEL act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:1] objectForKey:@"selector"]).pointerValue;
    
    if( nil == act ) return;  // do nothing
    
    NSNumber *nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:1]) objectForKey:@"mNum"];
    
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:textField.text];
        else
            ;
    }
}

// Confirm Button Action
-(void) confirmAction:(id)sender
{
    [txtField resignFirstResponder];
    
    SEL act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:2] objectForKey:@"selector"]).pointerValue;
    
    if( nil == act ) return;  // do nothing
    
    NSNumber *nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:2]) objectForKey:@"mNum"];
    
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
    
    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:txtField.text];
        else
            ; // todo: error handleing
    }
}

@end