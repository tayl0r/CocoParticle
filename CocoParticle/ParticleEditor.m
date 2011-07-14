#import "cocos2d.h"

#import "ParticleEditor.h"

@implementation ParticleEditor

-(id) initWithParticle:(CocosParticle *)cp
{
    if ((self == [super initWithStyle:UITableViewStyleGrouped])) {
        m_cp = [cp retain];
        
        // add all the editable components
        m_componentManager = [[ParticleEditorComponentManager alloc] init];
        
        // base section
        ParticleEditorSection* base = [m_componentManager addSectionWithName:@"Base"];
        
        ParticleEditorComponent* name = [base addComponentWithName:@"Name"];
        [name setTextInputWithDefault:cp.m_name];
        
        ParticleEditorComponent* type = [base addComponentWithName:@"Particle Type"];
        [type setSegmentedControlWithChoices:[NSArray arrayWithObjects:@"Gravity", @"Radius", nil]];
        
        ParticleEditorComponent* life = [base addComponentWithName:@"Life"];
        [life setSliderWithMin:0 andMax:50];
        ParticleEditorComponent* lifev = [base addComponentWithName:@"Life Variance"];
        [lifev setSliderWithMin:0 andMax:50];
        
        
        // gravity mode
        ParticleEditorSection* gravity = [m_componentManager addSectionWithName:@"Gravity Mode"];
        
        ParticleEditorComponent* gravX = [gravity addComponentWithName:@"Gravity X"];
        [gravX setSliderWithMin:-1000 andMax:1000];
        ParticleEditorComponent* gravY = [gravity addComponentWithName:@"Gravity Y"];
        [gravY setSliderWithMin:-1000 andMax:1000];
        
        ParticleEditorComponent* speed = [gravity addComponentWithName:@"Speed"];
        [speed setSliderWithMin:-1000 andMax:1000];
        ParticleEditorComponent* speedv = [gravity addComponentWithName:@"Speed Variance"];
        [speedv setSliderWithMin:-1000 andMax:1000];
        
        ParticleEditorComponent* tanga = [gravity addComponentWithName:@"Tangential Acceleration"];
        [tanga setSliderWithMin:-1000 andMax:1000];
        ParticleEditorComponent* tangav = [gravity addComponentWithName:@"Tangential Acceleration Variance"];
        [tangav setSliderWithMin:-1000 andMax:1000];
        
        ParticleEditorComponent* rada = [gravity addComponentWithName:@"Radial Acceleration"];
        [rada setSliderWithMin:-1000 andMax:1000];
        ParticleEditorComponent* radav = [gravity addComponentWithName:@"Radial Acceleration Variance"];
        [radav setSliderWithMin:-1000 andMax:1000];
        
        
        // radius mode
        ParticleEditorSection* radius = [m_componentManager addSectionWithName:@"Radius Mode"];
        
        ParticleEditorComponent* startradius = [radius addComponentWithName:@"Start Radius"];
        [startradius setSliderWithMin:0 andMax:1000];
        ParticleEditorComponent* startradiusv = [radius addComponentWithName:@"Start Radius Variance"];
        [startradiusv setSliderWithMin:0 andMax:1000];

        ParticleEditorComponent* endradius = [radius addComponentWithName:@"End Radius"];
        [endradius setSliderWithMin:0 andMax:1000];
        ParticleEditorComponent* endradiusv = [radius addComponentWithName:@"End Radius Variance"];
        [endradiusv setSliderWithMin:0 andMax:1000];

        ParticleEditorComponent* rps = [radius addComponentWithName:@"Rotation Per Second"];
        [rps setSliderWithMin:-360 andMax:360];
        ParticleEditorComponent* rpsv = [radius addComponentWithName:@"Rotation Per Second Variance"];
        [rpsv setSliderWithMin:-360 andMax:360];        
        
        
        // spin & angle
        ParticleEditorSection* spinangle = [m_componentManager addSectionWithName:@"Spin & Angle"];
        
        ParticleEditorComponent* angle = [spinangle addComponentWithName:@"Angle"];
        [angle setSliderWithMin:-360 andMax:360];
        ParticleEditorComponent* anglev = [spinangle addComponentWithName:@"Angle Variance"];
        [anglev setSliderWithMin:-360 andMax:360];
        
        ParticleEditorComponent* startspin = [spinangle addComponentWithName:@"Start Spin"];
        [startspin setSliderWithMin:-1000 andMax:1000];
        ParticleEditorComponent* startspinv = [spinangle addComponentWithName:@"Start Spin Variance"];
        [startspinv setSliderWithMin:-1000 andMax:1000];

        ParticleEditorComponent* endspin = [spinangle addComponentWithName:@"End Spin"];
        [endspin setSliderWithMin:-1000 andMax:1000];
        ParticleEditorComponent* endspinv = [spinangle addComponentWithName:@"End Spin Variance"];
        [endspinv setSliderWithMin:-1000 andMax:1000];

        
        // size
        ParticleEditorSection* size = [m_componentManager addSectionWithName:@"Size"];
        
        ParticleEditorComponent* startsize = [size addComponentWithName:@"Start Size"];
        [startsize setSliderWithMin:0 andMax:200];
        ParticleEditorComponent* startsizev = [size addComponentWithName:@"Start Size Variance"];
        [startsizev setSliderWithMin:0 andMax:200];
        
        ParticleEditorComponent* endsize = [size addComponentWithName:@"End Size"];
        [endsize setSliderWithMin:0 andMax:200];
        ParticleEditorComponent* endsizev = [size addComponentWithName:@"End Size Variance"];
        [endsizev setSliderWithMin:0 andMax:200];
        
        
        // start color
        ParticleEditorSection* startcolor = [m_componentManager addSectionWithName:@"Start Color"];
        
        ParticleEditorComponent* startred = [startcolor addComponentWithName:@"Red"];
        [startred setSliderWithMin:0 andMax:255];
        ParticleEditorComponent* startredv = [startcolor addComponentWithName:@"Red Variance"];
        [startredv setSliderWithMin:0 andMax:255];

        ParticleEditorComponent* startblue = [startcolor addComponentWithName:@"Blue"];
        [startblue setSliderWithMin:0 andMax:255];
        ParticleEditorComponent* startbluev = [startcolor addComponentWithName:@"Blue Variance"];
        [startbluev setSliderWithMin:0 andMax:255];
        
        ParticleEditorComponent* startgreen = [startcolor addComponentWithName:@"Green"];
        [startgreen setSliderWithMin:0 andMax:255];
        ParticleEditorComponent* startgreenv = [startcolor addComponentWithName:@"Green Variance"];
        [startgreenv setSliderWithMin:0 andMax:255];
        
        
        // end color
        ParticleEditorSection* endcolor = [m_componentManager addSectionWithName:@"End Color"];
        
        ParticleEditorComponent* endred = [endcolor addComponentWithName:@"Red"];
        [endred setSliderWithMin:0 andMax:255];
        ParticleEditorComponent* endredv = [endcolor addComponentWithName:@"Red Variance"];
        [endredv setSliderWithMin:0 andMax:255];
        
        ParticleEditorComponent* endblue = [endcolor addComponentWithName:@"Blue"];
        [endblue setSliderWithMin:0 andMax:255];
        ParticleEditorComponent* endbluev = [endcolor addComponentWithName:@"Blue Variance"];
        [endbluev setSliderWithMin:0 andMax:255];
        
        ParticleEditorComponent* endgreen = [endcolor addComponentWithName:@"Green"];
        [endgreen setSliderWithMin:0 andMax:255];
        ParticleEditorComponent* endgreenv = [endcolor addComponentWithName:@"Green Variance"];
        [endgreenv setSliderWithMin:0 andMax:255];

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

#define MAINLABEL_TAG 1
#define MAINWIDGET_TAG 2
#define MAINVALUE_TAG 3

-(UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ParticleEditorSection* section = [m_componentManager getSection:indexPath.section];
    ParticleEditorComponent* component = [section getComponent:indexPath.row];

    //UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:component.m_componentType];
    UITableViewCell* cell = component.m_cell;
    if (cell) {
        return cell;
    }
    
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blah"] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = component.m_name;

    UIView* widget = component.m_widget;
    if (widget) {
        // textLabel
        UILabel* name = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5.0, cell.frame.size.width - 40, 25.0)] autorelease];
        name.tag = MAINLABEL_TAG;
        name.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        name.textColor = [UIColor blackColor];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont boldSystemFontOfSize:16.0];
        name.textAlignment = UITextAlignmentLeft;
        name.text = cell.textLabel.text;
        cell.textLabel.text = nil;
        [cell.contentView addSubview:name];

        CGFloat sizeMod = 0;

        // main widget
        widget.tag = MAINWIDGET_TAG;
        widget.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        CGRect frame = cell.contentView.frame;
        frame.origin.x = 10;
        frame.size.width = frame.size.width - frame.origin.x*2 - 80;
        frame.size.height = 35;
        frame.origin.y = name.frame.size.height + name.frame.origin.y - 5;
        if ([widget isMemberOfClass:[UITextField class]]) {
            frame.origin.y += 7;
        }
        else if ([widget isMemberOfClass:[UISegmentedControl class]]) {
            frame.origin.y += 10;
            sizeMod += 15;
        }
        widget.frame = frame;
        [cell.contentView addSubview:widget];
        
        // slide value widget
        UITextField* widgetValue = component.m_widgetValue;
        widgetValue.tag = MAINVALUE_TAG;
        widgetValue.frame = CGRectMake(frame.size.width + frame.origin.x*1.5, widget.frame.origin.y + 7, 80, frame.size.height);
        widgetValue.keyboardType = UIKeyboardTypeNumberPad;
        widgetValue.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        widgetValue.textAlignment = UITextAlignmentRight;
        widgetValue.textColor = [UIColor blackColor];
        widgetValue.backgroundColor = [UIColor clearColor];
        widgetValue.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:widgetValue];
        
        component.m_height = widget.frame.size.height + name.frame.size.height + sizeMod;
        
        CCLOG(@"configured view for %@", component.m_name);
    }
    else {
        component.m_height = cell.contentView.bounds.size.height;
    }
    component.m_cell = cell;
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
