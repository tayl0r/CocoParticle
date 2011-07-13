#import "cocos2d.h"

#import "ParticleList.h"
#import "CocosParticle.h"
#import "ParticleEditor.h"

@implementation ParticleList

-(id) initWithStyle:(UITableViewStyle)style
{
    if ((self = [super initWithStyle:style])) {
        m_particles = [[NSMutableArray alloc] init];
        
        // left button
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRow)];

        // right button
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editRows)] autorelease];
        
        //self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    return self;
}

// how else can we get the bounds of this view?
/*-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect b = self.parentViewController.view.bounds;
    CCLOG(@"%f %f %f %f", b.size.width, b.size.height, b.origin.x, b.origin.y);
}*/

// open up the new view with the selected particle
-(void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    ParticleEditor* newVC = [[[ParticleEditor alloc] initWithParticle:[m_particles objectAtIndex:indexPath.row]] autorelease];
    [self.navigationController pushViewController:newVC animated:YES];
}

// add a new particle to the end of the list
// for some reason apple really doesn't want you to add it to the beginning of the list
-(void) addRow
{
    [self addRowAtPath:[NSIndexPath indexPathForRow:[m_particles count] inSection:0]];
}

-(void) addRowAtPath:(NSIndexPath*)path
{
    NSArray* paths = [NSArray arrayWithObject:path];
    CocosParticle* cp = [[[CocosParticle alloc] init] autorelease];
    [m_particles insertObject:cp atIndex:0];
    [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
}

// toggle editing of rows (enables deletion & in-list add particle buttons)
-(void) editRows
{
    [self setEditing:!self.editing animated:YES];
    //self.navigationItem.leftBarButtonItem.enabled = self.editing;
    NSArray* paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[m_particles count] inSection:0]];
    if (self.editing) {
        // add a dummy particle to the end, this will have the + add button on it
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
    }
    else {
        // remove the dummy particle at the end
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
    // if we're in edit mode, we have the dummy particle at the end of the list
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSUInteger row = indexPath.row;
    if (row == [m_particles count]) {
        // if we're in edit mode, we have +1 particles and it needs a dummy name
        cell.textLabel.text = @"Create New Particle";
    }
    else {
        // else use the real name
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
    return NO;
}

-(UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == [m_particles count]) {
        // if we're in edit mode, this will be the dummy particle at the bottom of the list
        return UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

-(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        // the dummy particle was clicked, so add a real particle
        [self addRowAtPath:indexPath];
    }
    else {
        // a real particle's delete button was clicked
        [m_particles removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// both view controllers that are part of the UISplitViewController must implement this
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
