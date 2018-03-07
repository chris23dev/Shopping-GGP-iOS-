//
//  GGPMallRepository.m
//  GGP Malls
//
//  Created by Janet Lin on 1/5/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPCategory.h"
#import "GGPClient.h"
#import "GGPEvent.h"
#import "GGPMovie.h"
#import "GGPMallMovie.h"
#import "GGPMovieTheater.h"
#import "GGPMallManager.h"
#import "GGPMallRepository.h"
#import "GGPParkingSite.h"
#import "GGPSale.h"
#import "GGPSweepstakes.h"
#import "NSArray+GGPAdditions.h"

@implementation GGPMallRepository

#pragma mark Alerts methods

+ (void)fetchAlertsWithCompletion:(void (^)(NSArray *alerts))onComplete {
    if ([GGPMallManager shared].selectedMall) {
        [[GGPClient sharedInstance] fetchAlertsForMallId:[GGPMallManager shared].selectedMall.mallId withCompletion:^(NSArray *alerts, NSError *error) {
            if (onComplete) {
                onComplete(alerts);
            }
        }];
    } else if (onComplete) {
        onComplete(nil);
    }
}

#pragma mark Category methods

+ (void)fetchTenantCategoriesWithCompletion:(void(^)(NSArray *categories))onComplete {
    if ([GGPMallManager shared].selectedMall) {
        __block NSMutableArray *categories;
        __block NSArray *tenants;
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        [[GGPClient sharedInstance] fetchCategoriesWithCompletion:^(NSArray *fetchedCategories, NSError *error) {
            categories = fetchedCategories.mutableCopy;
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [[GGPClient sharedInstance] fetchTenantsForMallId:[GGPMallManager shared].selectedMall.mallId withCompletion:^(NSArray *fetchedTenants, NSError *error) {
            tenants = fetchedTenants;
            dispatch_group_leave(group);
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (onComplete) {
                [self mapTenants:tenants toCategories:categories];
                [self mapChildCategoriesForCategories:categories];
                [self sortAndFilterCategories:categories];
                onComplete(categories);
            }
        });
    } else if (onComplete) {
        onComplete(nil);
    }
}

+ (void)fetchSaleCategoriesWithCompletion:(void(^)(NSArray *categories))onComplete {
    if ([GGPMallManager shared].selectedMall) {
        __block NSMutableArray *categories;
        __block NSArray *campaigns;
        __block NSArray *sales;
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        [[GGPClient sharedInstance] fetchCategoriesWithCompletion:^(NSArray *fetchedCategories, NSError *error) {
            categories = fetchedCategories.mutableCopy;
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [[GGPClient sharedInstance] fetchCampaignsWithCompletion:^(NSArray *fetchedCampaigns, NSError *error) {
            campaigns = [fetchedCampaigns ggp_arrayWithFilter:^BOOL(GGPCategory *category) {
                return [GGPCategory isValidCampaignCategoryCode:category.code];
            }];
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [GGPMallRepository fetchSalesWithCompletion:^(NSArray *fetchedSales) {
            sales = fetchedSales;
            dispatch_group_leave(group);
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (onComplete) {
                [categories addObjectsFromArray:campaigns];
                [self mapSales:sales toCategories:categories];
                [self mapChildCategoriesForCategories:categories];
                [self sortAndFilterCategories:categories];
                
                onComplete(categories);
            }
        });
    } else if (onComplete) {
        onComplete(nil);
    }
}

#pragma mark Event methods

+ (void)fetchEventsWithCompletion:(void(^)(NSArray *events))onComplete {
    if ([GGPMallManager shared].selectedMall) {
        __block NSArray *events;
        __block NSArray *tenants;
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        [[GGPClient sharedInstance] fetchEventsForMallId:[GGPMallManager shared].selectedMall.mallId withCompletion:^(NSArray *fetchedEvents, NSError *error) {
            events = fetchedEvents;
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [GGPMallRepository fetchTenantsWithCompletion:^(NSArray *fetchedTenants) {
            tenants = fetchedTenants;
            dispatch_group_leave(group);
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self mapTenants:tenants toEvents:events];
            if (onComplete) {
                onComplete(events);
            }
        });
    } else if (onComplete) {
        onComplete(nil);
    }
}

#pragma mark Heroes methods

+ (void)fetchHeroesWithCompletion:(void (^)(NSArray *heroes))onComplete {
    if ([GGPMallManager shared].selectedMall) {
        [[GGPClient sharedInstance] fetchHeroesForMallId:[GGPMallManager shared].selectedMall.mallId withCompletion:^(NSArray *heroes, NSError *error) {
            if (onComplete) {
                onComplete(heroes);
            }
        }];
    } else if (onComplete) {
        onComplete(nil);
    }
}

#pragma mark Mall methods

+ (void)fetchMallById:(NSInteger)mallId onComplete:(void (^)(GGPMall *mall))onComplete {
    [[GGPClient sharedInstance] fetchMallFromMallId:mallId withCompletion:^(GGPMall *mall, NSError *error) {
        if (onComplete) {
            onComplete(mall);
        }
    }];
}

+ (void)fetchMinimalMallsWithCompletion:(void(^)(NSArray *malls))onComplete {
    [[GGPClient sharedInstance] fetchMinimalMallsWithCompletion:^(NSArray *malls, NSError *error) {
        if (onComplete) {
            onComplete(malls);
        }
    }];
}

#pragma mark Movie Theater methods

+ (void)fetchMovieTheatersWithCompletion:(void(^)(NSArray *movieTheaters))onComplete {
    if ([GGPMallManager shared].selectedMall) {
        [[GGPClient sharedInstance] fetchMovieTheatersForMallId:[GGPMallManager shared].selectedMall.mallId withCompletion:^(NSArray *theaters, NSError *error) {
            if (onComplete) {
                onComplete(theaters);
            }
        }];
    } else if (onComplete) {
        onComplete(nil);
    }
}

#pragma mark Park Assist Site methods

+ (void)fetchParkingSiteWithCompletion:(void(^)(GGPParkingSite *site))onComplete {
    if ([GGPMallManager shared].selectedMall) {
        [[GGPClient sharedInstance] fetchParkingSiteForMallId:[GGPMallManager shared].selectedMall.mallId withCompletion:^(GGPParkingSite *site) {
            if (onComplete) {
                onComplete(site);
            }
        }];
    } else if (onComplete) {
        onComplete(nil);
    }
}

#pragma mark Sales methods

+ (void)fetchSalesWithCompletion:(void(^)(NSArray *sales))onComplete {
    [self fetchSalesWithTenants:nil andCompletion:onComplete];
}

+ (void)fetchSalesWithTenants:(NSArray *)allTenants andCompletion:(void(^)(NSArray *sales))onComplete {
    if ([GGPMallManager shared].selectedMall) {
        __block NSArray *sales;
        __block NSArray *tenants = allTenants;
        dispatch_group_t group = dispatch_group_create();
        
        if (!tenants) {
            dispatch_group_enter(group);
            [GGPMallRepository fetchTenantsWithCompletion:^(NSArray *fetchedTenants) {
                tenants = fetchedTenants;
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_enter(group);
        [[GGPClient sharedInstance] fetchSalesForMallId:[GGPMallManager shared].selectedMall.mallId withCompletion:^(NSArray *fetchedSales, NSError *error) {
            sales = fetchedSales;
            dispatch_group_leave(group);
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self mapTenants:tenants toSales:sales];
            if (onComplete) {
                onComplete(sales);
            }
        });
    } else if (onComplete) {
        onComplete(nil);
    }
}

+ (void)fetchSalesForTenantId:(NSInteger)tenantId withCompletion:(void(^)(NSArray *sales))onComplete {
    if (![GGPMallManager shared].selectedMall) {
        onComplete(nil);
        return;
    }
    
    [GGPMallRepository fetchSalesWithCompletion:^(NSArray *sales) {
        if (onComplete) {
            NSArray *filteredSales = [sales ggp_arrayWithFilter:^BOOL(GGPSale *sale) {
                return sale.tenant.tenantId == tenantId;
            }];
            onComplete(filteredSales);
        }
    }];
}

#pragma mark Tenants methods

+ (void)fetchTenantsWithCompletion:(void(^)(NSArray *tenants))onComplete {
    if (![GGPMallManager shared].selectedMall) {
        onComplete(nil);
        return;
    }
    
    [[GGPClient sharedInstance] fetchTenantsForMallId:[GGPMallManager shared].selectedMall.mallId withCompletion:^(NSArray *tenants, NSError *error) {
        if (onComplete) {
            [self mapParentTenantForTenants:tenants];
            [self mapChildTenantsForTenants:tenants];
            onComplete(tenants);
        }
    }];
}

#pragma mark Date Ranges

+ (void)fetchDateRangesWithCompletion:(void (^)(NSArray *dateRanges))onComplete {
    if ([GGPMallManager shared].selectedMall) {
        [[GGPClient sharedInstance] fetchDateRangesForMallId:[GGPMallManager shared].selectedMall.mallId withCompletion:^(NSArray *dateRanges, NSError *error) {
            if (onComplete) {
                onComplete(dateRanges);
            }
        }];
    } else if (onComplete) {
        onComplete(nil);
    }
}

#pragma mark Sweepstakes

+ (void)fetchSweepstakesWithCompletion:(void (^)(GGPSweepstakes *sweepstakes))onComplete {
    [[GGPClient sharedInstance] fetchSweepstakeswithCompletion:^(NSArray *sweepstakes, NSError *error) {
        if (onComplete) {
            GGPSweepstakes *validSweepstakes = [sweepstakes ggp_firstWithFilter:^BOOL(GGPSweepstakes *sweepstakes) {
                return sweepstakes.isValid;
            }];
            onComplete(validSweepstakes);
        }
    }];
}

#pragma mark - MallMovie

+ (void)fetchMallMoviesWithCompletion:(void (^)(NSArray *theaters, NSArray *mallMovies))onComplete {
    [self fetchMovieTheatersWithCompletion:^(NSArray *movieTheaters) {
        if (onComplete) {
            NSArray *mallMovies = [self mallMoviesFromTheaters:movieTheaters];
            onComplete(movieTheaters, mallMovies);
        }
    }];
}

#pragma mark - Mapping methods

#pragma mark Mall Movie Mapping

+ (NSArray *)mallMoviesFromTheaters:(NSArray *)theaters {
    NSMutableArray *mallMovies = [NSMutableArray new];
    
    for (GGPMovie *movie in [self distinctMoviesFromTheaters:theaters]) {
        NSMutableDictionary *showtimesLookup = [NSMutableDictionary new];
        NSArray *theatersShowingMovie = [self theatersShowingMovie:movie.movieId fromTheaters:theaters];
        
        for (GGPMovieTheater *theater in theatersShowingMovie) {
            NSArray *showtimes = [self showtimesAtTheater:theater forMovieId:movie.movieId];
            [showtimesLookup setObject:showtimes forKey:theater];
        }
        
        GGPMallMovie *mallMovie = [[GGPMallMovie alloc] initWithMovie:movie showtimesLookup:showtimesLookup andNumberOfTheatersAtMall:theaters.count];
        
        [mallMovies addObject:mallMovie];
    }
    
    return mallMovies;
}

+ (NSArray *)distinctMoviesFromTheaters:(NSArray *)theaters {
    NSMutableArray *distinctMovies = [NSMutableArray new];
    for (GGPMovieTheater *theater in theaters) {
        for (GGPMovie *movie in theater.movies) {
            BOOL exist = [distinctMovies ggp_anyWithFilter:^BOOL(GGPMovie *evaluatedMovie) {
                return evaluatedMovie.movieId == movie.movieId;
            }];
            if (!exist) {
                [distinctMovies addObject:movie];
            }
        }
    }
    return distinctMovies;
}

+ (NSArray *)theatersShowingMovie:(NSInteger)movieId fromTheaters:(NSArray *)theaters {
    return [theaters ggp_arrayWithFilter:^BOOL(GGPMovieTheater *theater) {
        return [theater.movies ggp_anyWithFilter:^BOOL(GGPMovie *movie) {
            return movie.movieId == movieId;
        }];
    }];
}

+ (NSArray *)showtimesAtTheater:(GGPMovieTheater *)theater forMovieId:(NSInteger)movieId {
    GGPMovie *movie = [theater.movies ggp_firstWithFilter:^BOOL(GGPMovie *movie) {
        return movie.movieId == movieId;
    }];
    
    return movie.showtimes;
}

#pragma mark - Tenant Mapping

+ (void)mapTenants:(NSArray *)tenants toEvents:(NSArray *)events {
    for (GGPEvent *event in events) {
        event.tenant = [tenants ggp_firstWithFilter:^BOOL(GGPTenant *tenant) {
            return tenant.tenantId == event.tenantId;
        }];
    }
}

+ (void)mapTenants:(NSArray *)tenants toSales:(NSArray *)sales {
    for (GGPSale *sale in sales) {
        sale.tenant = [tenants ggp_firstWithFilter:^BOOL(GGPTenant *tenant) {
            return tenant.tenantId == sale.tenant.tenantId;
        }];
    }
}

+ (void)mapParentTenantForTenants:(NSArray *)tenants {
    for (GGPTenant *tenant in tenants) {
        if (tenant.isChildTenant) {
            tenant.parentTenant = [tenants ggp_firstWithFilter:^BOOL(GGPTenant *parentTenant) {
                return parentTenant.tenantId == tenant.parentId;
            }];
        }
    }
}

+ (void)mapChildTenantsForTenants:(NSArray *)tenants {
    for (GGPTenant *tenant in tenants) {
        if (tenant.childIds.count > 0) {
            tenant.childTenants = [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *childTenant) {
                return [tenant.childIds containsObject:@(childTenant.tenantId)];
            }];
        }
    }
}

#pragma mark Category Mapping

+ (void)mapChildCategoriesForCategories:(NSArray *)categories {
    for (GGPCategory *category in categories) {
        category.childFilters = [categories ggp_arrayWithFilter:^BOOL(GGPCategory *childCategory) {
            return childCategory.parentId == category.filterId && childCategory.filteredItems.count > 0;
        }];
    }
}

+ (void)mapTenants:(NSArray *)tenants toCategories:(NSArray *)categories {
    for (GGPCategory *category in categories) {
        category.filteredItems = [tenants ggp_arrayWithFilter:^BOOL(GGPTenant *evaluatedTenant) {
            for (GGPCategory *tenantCategory in evaluatedTenant.categories) {
                if (tenantCategory.filterId == category.filterId) {
                    return YES;
                }
            }
            return NO;
        }];
    }
}

+ (void)mapSales:(NSArray *)sales toCategories:(NSArray *)categories {
    for (GGPCategory *category in categories) {
        category.filteredItems = [sales ggp_arrayWithFilter:^BOOL(GGPSale *sale) {
            NSMutableArray *saleCategories = [NSMutableArray new];
            [saleCategories addObjectsFromArray:sale.categories];
            [saleCategories addObjectsFromArray:sale.campaignCategories];
            
            for (GGPCategory *saleCategory in saleCategories) {
                if (saleCategory.filterId == category.filterId) {
                    return YES;
                }
            }
            return NO;
        }];
    }
}

+ (void)sortAndFilterCategories:(NSMutableArray *)categories {
    [GGPCategory removeEmptyAndChildCategoriesFromCategories:categories];
    
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *campaignSort = [NSSortDescriptor sortDescriptorWithKey:@"isCampaign" ascending:NO];
    
    [categories sortUsingDescriptors:@[campaignSort, nameSort]];
}

@end
