//
//  VenonTableViewController.m
//  venon
//
//  Created by Leah Steinberg on 6/30/14.
//  Copyright (c) 2014 LeahSteinberg. All rights reserved.
//

#import "VenonTableViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import <AFNetworking/AFNetworking.h>
#import "VenonFriendObject.h"
#import "VenonMakePayment.h"
#import "makePaymentViewController.h"

@interface VenonTableViewController ()
@property (strong, nonatomic) NSMutableArray *friendsList;
@property(strong, nonatomic) NSMutableArray *filteredFriendsList;


@end

@implementation VenonTableViewController

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self loadFriends];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsList = [[NSMutableArray alloc] init];
    self.filteredFriendsList = [[NSMutableArray alloc] init];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return [self.filteredFriendsList count];
    }
    else{
        return [self.friendsList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ExampleReuse" forIndexPath:indexPath];
    if(tableView == self.searchDisplayController.searchResultsTableView){
        NSLog(@"~~~~~~");
        VenonFriendObject *searchFriend = [self.filteredFriendsList objectAtIndex:indexPath.row];
        cell.textLabel.text = searchFriend.displayName;
        NSLog(@"in search, printing: %@", searchFriend.displayName);
    }
    else{
        VenonFriendObject *friend = [self.friendsList objectAtIndex:indexPath.row];

        cell.textLabel.text = friend.displayName;

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"Selected row %d", indexPath.row);
    VenonFriendObject *target;
    if(tableView == self.searchDisplayController.searchResultsTableView){
        target = [self.filteredFriendsList objectAtIndex:indexPath.row];

    }
    else{

        target = [self.friendsList objectAtIndex:indexPath.row];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    makePaymentViewController *paymentViewController = [[makePaymentViewController alloc]init];
    VenonMakePayment *newPayment = [[VenonMakePayment alloc]init];
    paymentViewController.paymentObject = newPayment;
    paymentViewController.paymentObject.targetDisplayName = target.displayName;
    paymentViewController.paymentObject.targetID = target.friendID;
    [self.navigationController pushViewController:paymentViewController animated:YES];
}

#pragma mark - search bar

- (void) filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    self.filteredFriendsList = [[NSMutableArray alloc]init];
    for(int i = 0; i<[self.friendsList count]; i++){
        VenonFriendObject *friend = [self.friendsList objectAtIndex:i];
        if(![friend.displayName rangeOfString:searchText options:NSCaseInsensitiveSearch].length ==0 ){
            [self.filteredFriendsList addObject:friend];
        }
        
    }
    
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
            [self filterContentForSearchText:searchString
                                       scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                              objectAtIndex:[self.searchDisplayController.searchBar
                                                  selectedScopeButtonIndex]]];
            return YES;
}


#pragma mark - Get friends data

-(void) loadFriends
{
    VENSession *session = [[Venmo sharedInstance] session];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *getFriendsUrl = [NSString stringWithFormat:@"https://api.venmo.com/v1/users/%@/friends?access_token=%@&limit=10000",session.user.externalId, session.accessToken];
    [manager GET:getFriendsUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject[@"data"]){
            [self addFriends:responseObject[@"data"]];
        }
        if(responseObject[@"pagination"]){
            if(responseObject[@"pagination"][@"next"]){
                [self loadMoreFriends:responseObject[@"pagination"][@"next"]];
            }
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure error: %@", error);
    }];
    
    
}



-(void)loadMoreFriends:(NSString *)moreFriendsURL{
    VENSession *session = [[Venmo sharedInstance] session];
    NSString *moreFriendsWithAccessString = [moreFriendsURL stringByAppendingString:@"&access_token="];
    NSString *moreFriendsWithAccessToken = [moreFriendsWithAccessString stringByAppendingString:session.accessToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:moreFriendsWithAccessToken parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject[@"data"]){
            [self addFriends:responseObject[@"data"]];
        }
        if(responseObject[@"pagination"]){
            if(responseObject[@"pagination"][@"next"]){
                [self loadMoreFriends:responseObject[@"pagination"][@"next"]];
            }
            else{
                NSLog(@"done with getting friends");
                
                
            }
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure error: %@", error);
    }];
    
    
    
    
}


-(void) shuffleFriends{
    
}

-(void) addFriends:(NSArray *)friendsData{
    for(int i=0; i<[friendsData count]; i++){
        VenonFriendObject *newFriend = [[VenonFriendObject alloc] init];
        newFriend.displayName = [friendsData objectAtIndex:i][@"display_name"];
        newFriend.friendID = [friendsData objectAtIndex:i][@"id"];
        [self.friendsList addObject:newFriend];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}



@end