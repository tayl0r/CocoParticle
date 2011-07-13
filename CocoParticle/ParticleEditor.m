#import "cocos2d.h"

#import "ParticleEditor.h"

@implementation ParticleEditor

-(id) initWithParticle:(CocosParticle *)cp
{
    if ((self == [super initWithStyle:UITableViewStyleGrouped])) {
        m_cp = [cp retain];
        
        // add all the editable components
        m_componentManager = [[ParticleEditorComponentManager alloc] init];
        
        ParticleEditorSection* base = [m_componentManager addSectionWithName:@"Base"];
        [base addComponentWithName:@"Name"];
        [base addComponentWithName:@"Particle Type"];
        ParticleEditorComponent* life = [base addComponentWithName:@"Life"];
        [life setSliderWithMin:0 andMax:100];
        [base addComponentWithName:@"Life Variance"];
        
        ParticleEditorSection* gravity = [m_componentManager addSectionWithName:@"Gravity Mode"];
        [gravity addComponentWithName:@"Gravity"];
        [gravity addComponentWithName:@"Direction"];
        [gravity addComponentWithName:@"Speed"];
        [gravity addComponentWithName:@"Speed Variance"];
        [gravity addComponentWithName:@"Tangential Acceleration"];
        [gravity addComponentWithName:@"Tangential Acceleration Variance"];
        [gravity addComponentWithName:@"Radial Acceleration"];
        [gravity addComponentWithName:@"Radial Acceleration Variance"];
        
        ParticleEditorSection* radius = [m_componentManager addSectionWithName:@"Radius Mode"];
        [radius addComponentWithName:@"Start Radius"];
        [radius addComponentWithName:@"Start Radius Variance"];
        [radius addComponentWithName:@"End Radius"];
        [radius addComponentWithName:@"End Radius Variance"];
        [radius addComponentWithName:@"Rotation"];
        [radius addComponentWithName:@"Rotation Variance"];
        
        //ParticleEditorSection* spin = [m_componentManager addSectionWithName:@"Spin"];
        //ParticleEditorSection* size = [m_componentManager addSectionWithName:@"Size"];
        //ParticleEditorSection* color = [m_componentManager addSectionWithName:@"Color"];
        //ParticleEditorSection* blendFunc = [m_componentManager addSectionWithName:@"Blending Function"];
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //CGRect bounds = self.parentViewController.view.bounds;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    return [m_componentManager getSectionCount];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    ParticleEditorSection* pSection = [m_componentManager getSection:section];
    return [pSection getComponentCount];
}

-(NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    ParticleEditorSection* pSection = [m_componentManager getSection:section];
    return pSection.m_name;
}

-(UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* myid = @"mydetail";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:myid];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myid] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;

    ParticleEditorSection* section = [m_componentManager getSection:indexPath.section];
    ParticleEditorComponent* component = [section getComponent:indexPath.row];
    cell.textLabel.text = component.m_name;
    UIView* widget = component.m_widget;
    if (widget) {
        widget.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        CGRect frame = cell.contentView.frame;
        frame.origin.x = 10;
        frame.size.width = frame.size.width - frame.origin.x*2;
        frame.origin.y = frame.size.height/2;
        widget.frame = frame;
        [cell.contentView addSubview:widget];
        component.m_height = frame.origin.y + frame.size.height;
    }
    else {
        component.m_height = cell.contentView.bounds.size.height;
    }
    return cell;
}

-(CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self tableView:tableView cellForRowAtIndexPath:indexPath];
    ParticleEditorSection* section = [m_componentManager getSection:indexPath.section];
    ParticleEditorComponent* component = [section getComponent:indexPath.row];
    return component.m_height;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void) dealloc
{
    [m_cp release];
    m_cp = nil;
    [m_componentManager release];
    m_componentManager = nil;
    [super dealloc];
}

@end
