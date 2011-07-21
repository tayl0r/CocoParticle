#import "cocos2d.h"

#import "ParticleConfig.h"
#import "ParticleList.h"
#import "ParticleEditor.h"

@implementation ParticleList

-(id) initWithStyle:(UITableViewStyle)style
{
    if ((self = [super initWithStyle:style])) {
        self.title = @"Particle List";
        m_particles = [[NSMutableArray alloc] init];
        
        NSArray* savedParticles = [[NSUserDefaults standardUserDefaults] objectForKey:@"particles"];
        if (savedParticles != nil) {
            for (NSDictionary* d in savedParticles) {
                ParticleEditor* pe = [[[ParticleEditor alloc] init] autorelease];
                [pe readValuesFromDict:d];
                [m_particles addObject:pe];
            }
        }
        
        if (!savedParticles || [savedParticles count] == 0) {
            NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
            for (NSString* filename in [NSArray arrayWithObjects:@"fireworks.plist", @"galaxy.plist", nil])
            {
                NSString* particlePath = [bundlePath stringByAppendingPathComponent:filename];
                NSDictionary* pData = [[[NSDictionary alloc] initWithContentsOfFile:particlePath] autorelease];
                ParticleEditor* pe = [[[ParticleEditor alloc] init] autorelease];
                [pe readValuesFromDict:pData];
                [m_particles addObject:pe];
            }
        }
        
        // left button
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRow)];

        // right button
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editRows)] autorelease];
        
        //self.navigationItem.leftBarButtonItem.enabled = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveParticlesToDisk) name:SAVE_PARTICLES_TO_DISK object:nil];
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[[NSNotificationCenter defaultCenter] postNotificationName:PARTICLE_LIST_VIEW_DID_APPEAR object:self];
    [self.tableView reloadData];
}

-(void) viewDidDisappear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:SAVE_PARTICLES_TO_DISK object:nil];
}

-(void) saveParticlesToDisk
{
    NSMutableArray* particles = [[[NSMutableArray alloc] initWithCapacity:[m_particles count]] autorelease];
    for (ParticleEditor* p in m_particles) {
        NSDictionary* pDict = [p toDict];
        [particles addObject:pDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:SAVE_PARTICLE_TO_CLOUD object:nil userInfo:pDict];
    }
    [[NSUserDefaults standardUserDefaults] setObject:particles forKey:@"particles"];
}

// open up the new view with the selected particle
-(void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.navigationController pushViewController:[m_particles objectAtIndex:indexPath.row] animated:YES];
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
    ParticleEditor* pe = [[[ParticleEditor alloc] init] autorelease];
    [m_particles insertObject:pe atIndex:0];
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
    [m_tabBar release];
    m_tabBar = nil;
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
        ParticleEditor* pe = [m_particles objectAtIndex:row];
        cell.textLabel.text = [pe getName];
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

// all view controllers that are part of the UISplitViewController must implement this
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
