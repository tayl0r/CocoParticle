#import "ParticleList.h"
#import "CocosParticle.h"
#import "cocos2d.h"

@implementation ParticleList

-(id) initWithStyle:(UITableViewStyle)style
{
    if ((self = [super initWithStyle:style])) {
        m_particles = [[NSMutableArray alloc] init];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editRows)] autorelease];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRow)];
        //self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    return self;
}

-(void) addRow
{
    NSArray* paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[m_particles count] inSection:0]];
    CocosParticle* cp = [[[CocosParticle alloc] init] autorelease];
    cp.m_name = @"My New Particle";
    [m_particles insertObject:cp atIndex:0];
    [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
}

-(void) editRows
{
    [self setEditing:!self.editing animated:YES];
    //self.navigationItem.leftBarButtonItem.enabled = self.editing;
    NSArray* paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[m_particles count] inSection:0]];
    if (self.editing) {
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
    }
    else {
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void) dealloc
{
    [self.view release];
    [m_particles release];
    [super dealloc];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.editing) {
        return [m_particles count] + 1;
    }
    else {
        return [m_particles count];
    }
}

-(NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Particles";
}

-(UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* myid = @"myid";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:myid];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myid] autorelease];
    }
    NSUInteger row = indexPath.row;
    if (row == [m_particles count]) {
        cell.textLabel.text = @"Create New Particle";
    }
    else {
        CocosParticle* cp = [m_particles objectAtIndex:row];
        cell.textLabel.text = cp.m_name;
    }
    return cell;
}

-(BOOL) tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

-(BOOL) tableView:(UITableView*)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == [m_particles count]) {
        return UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

-(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        CocosParticle* cp = [[[CocosParticle alloc] init] autorelease];
        cp.m_name = @"My New Particle";
        [m_particles insertObject:cp atIndex:0];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else {
        [m_particles removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
