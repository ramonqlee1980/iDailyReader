
@protocol PopupTableViewDelegate;
@interface PopupTableView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSString *_title;
    NSArray *_options;
}

@property (nonatomic, assign) id<PopupTableViewDelegate> delegate;

// The options is a NSArray, contain some NSDictionaries, the NSDictionary contain 2 keys, one is "img", another is "text".
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions;
// If animated is YES, PopListView will be appeared with FadeIn effect.
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@end

@protocol PopupTableViewDelegate <NSObject>
- (void)popTableView:(PopupTableView *)popListView didSelectedIndex:(NSInteger)anIndex;
- (void)popTableViewDidCancel;
@end