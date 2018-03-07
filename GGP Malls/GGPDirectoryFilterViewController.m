//
//  GGPDirectoryFilterViewController.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 11/1/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPFilterItem.h"
#import "GGPDirectoryFilterSelectionViewController.h"
#import "GGPDirectoryFilterViewController.h"
#import "UIView+GGPAdditions.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import "UIStackView+GGPAdditions.h"

static NSInteger const kStackViewSpacing = 8;

@interface GGPDirectoryFilterViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIView *separator;

@property (weak, nonatomic) id <GGPFilterSelectionDelegate> filterSelectionDelegate;

@property (strong, nonatomic) GGPDirectoryFilterSelectionViewController *filterSelectionViewController;
@property (strong, nonatomic) id<GGPFilterItem> selectedFilter;
@property (assign, nonatomic) BOOL shouldShowFilterDescriptionLabel;

@end

@implementation GGPDirectoryFilterViewController

- (instancetype)initWithFilterSelectionDelegate:(id<GGPFilterSelectionDelegate>)filterSelectionDelegate {
    self = [super init];
    if (self) {
        self.filterSelectionDelegate = filterSelectionDelegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
}

- (void)configureControls {
    self.stackView.spacing = kStackViewSpacing;
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.distribution = UIStackViewDistributionFillProportionally;
    
    self.separator.backgroundColor = [UIColor ggp_lightGray];
    
    [self configureFilterSelctionView];
}

- (void)configureFilterSelctionView {
    self.filterSelectionViewController = [GGPDirectoryFilterSelectionViewController new];
    self.filterSelectionViewController.filterSelectionDelegate = self.filterSelectionDelegate;
}

- (void)configureWithFilter:(id<GGPFilterItem>)filter {
    if (!filter) {
        return;
    }
    
    [self.stackView ggp_clearArrangedSubviews];
    self.selectedFilter = filter;
    
    [self addSpacerView];
    
    if (self.shouldShowFilterDescriptionLabel) {
        [self addfilterDescriptionLabel];
    }
    
    if (!self.selectedFilter.isAllFilter) {
        [self addFilterSelectionView];
    }
    
    [self addSpacerView];
}

- (void)addSpacerView {
    [self.stackView addArrangedSubview:[UIView new]];
}

- (void)addfilterDescriptionLabel {
    UILabel *filterDescriptionLabel = [self filterDescriptionLabel];
    filterDescriptionLabel.attributedText = self.attributedStringForFilter;
    [self.stackView addArrangedSubview:filterDescriptionLabel];
}

- (UILabel *)filterDescriptionLabel {
    UILabel *descriptionLabel = [UILabel new];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.font = [UIFont ggp_regularWithSize:13];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    return descriptionLabel;
}

- (void)addFilterSelectionView {
    [self.filterSelectionViewController configureWithFilterText:self.selectedFilter.filterText];
    [self.stackView addArrangedSubview:self.filterSelectionViewController.view];
}

- (BOOL)shouldShowFilterDescriptionLabel {
    return (self.selectedFilter.type == GGPFilterTypeProduct ||
            self.selectedFilter.type == GGPFilterTypeBrand) &&
            self.selectedFilter.filteredItems.count > 1;
}

- (NSAttributedString *)attributedStringForFilter {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:[@"FILTER_DESCRIPTION" ggp_toLocalized], self.selectedFilter.filteredItems.count]];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont ggp_boldWithSize:14]
                             range:[attributedString.string rangeOfString:@(self.selectedFilter.filteredItems.count).stringValue]];
    return attributedString;
}

- (void)clearStackView {
    [self.stackView ggp_clearArrangedSubviews];
}

@end
