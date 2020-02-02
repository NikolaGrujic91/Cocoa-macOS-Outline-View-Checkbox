//
//  AppDelegate.h
//  Cocoa Outline View
//
//  Created by Nikola Grujic on 31/01/2020.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource>
{
    NSMutableDictionary *outlineViewData;
}

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSOutlineView *outlineView;

- (IBAction)itemChecked:(id)sender;

- (void)setDataSource;
- (void)setDelegate;

- (void)fillTestData;
- (id)findParentForItem:(id)item;
- (NSString*)getItemName:(id)item;

@end
