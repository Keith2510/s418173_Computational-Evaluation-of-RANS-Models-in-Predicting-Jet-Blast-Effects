# This Spaceclaim script was created to fulfill the thesis requirements of Keith Sequeira (Msc Computational Fluid Dynamics, IRP -2024), titled "Establishing Best Practices for Modelling Jet Blast."
# This script was made with assistance from ChatGPT and Bing AI

# Python Script, API Version = V232
# All measurements are in meters unless specified

################################ Clear All Solids and Enclosures ################################
def clear_structure_tree():
    for body in GetRootPart().Bodies:
        # Delete each body
        selection = BodySelection.Create(body)
        result = Delete.Execute(selection)

    for component in GetRootPart().Components:
        # Delete each component
        selection = ComponentSelection.Create(component)
        result = Delete.Execute(selection)

# Call the function to clear the structure tree
clear_structure_tree()

################################ Model Dimensions ################################

# Cylinder Parameters
CylinderRadius = 0.5
CylinderExtrudeLength = -30

# Enclosure Parameters
Solid_LR = 99.5
Solid_Ground = 0.5
Solid_Top = 198.5
Solid_Outlet = 470
Solid_FrontFace = 7.5
Pull = -7.5


# Set Sketch Plane
sectionPlane = Plane.PlaneZX
result = ViewHelper.SetSketchPlane(sectionPlane, Info1)
# EndBlock

# Set Sketch Plane
selection = Axis1
result = ViewHelper.SetSketchPlane(selection, Info2)
# EndBlock

# Sketch Circle
origin = Point2D.Create(M(0), M(0))
result = SketchCircle.Create(origin, M(0.5))

baseSel = SelectionPoint.Create(CurvePoint1)
targetSel = SelectionPoint.Create(DatumPoint1)

result = Constraint.CreateCoincident(baseSel, targetSel)
# EndBlock

# 
# Create Diameter Dimension
dimTarget = Curve1
result = Dimension.CreateDiameter(dimTarget)
# EndBlock

# Solidify Sketch
mode = InteractionMode.Solid
result = ViewHelper.SetViewMode(mode, Info3)
# EndBlock

# Extrude 1 Face
selection = Face1
options = ExtrudeFaceOptions()
options.ExtrudeType = ExtrudeType.Add
result = ExtrudeFaces.Execute(selection, M(30), options, Info4)
# EndBlock

# Create Enclosure
selection = Body1

options = EnclosureOptions()
options.EnclosureType = EnclosureType.Box

options.EnclosureCushion = BoxEnclosureCushion(M(Solid_FrontFace),M(Solid_Outlet),M(Solid_Ground),M(Solid_Top),M(Solid_LR),M(Solid_LR))
result = Enclosure.Create(selection, options)
# EndBlock

# Translate Along Z Handle
selection = Face2
direction = Move.GetDirection(selection)
options = MoveOptions()
result = Move.Translate(selection, direction, M(Pull), options, Info5)
# EndBlock

# Set Style
selection = Body1
ColorHelper.SetFillStyle(selection, FillStyle.Transparent)
# EndBlock

# Create Named Selection Group
primarySelection = Face2
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Create Named Selection Group
primarySelection = FaceSelection.Create(Face3, Face4, Face5)
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Create Named Selection Group
primarySelection = Face6
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Create Named Selection Group
primarySelection = Face7
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Rename Named Selection
result = NamedSelection.Rename("Group1", "Jet_Wall")
# EndBlock

# Rename Named Selection
result = NamedSelection.Rename("Group2", "Symmetry")
# EndBlock

# Rename Named Selection
result = NamedSelection.Rename("Group3", "Ground")
# EndBlock

# Rename Named Selection
result = NamedSelection.Rename("Group4", "Outlet")
# EndBlock

# Make Components
selection = Body1
result = ComponentHelper.MoveBodiesToComponent(selection, Info6)
# EndBlock

# Rename 'Component1' to 'Jet'
selection = Part1
result = RenameObject.Execute(selection,"Jet")
# EndBlock

# Exclude items from physics
selection = Component1
suppress = True
ViewHelper.SetSuppressForPhysics(selection, suppress)
# EndBlock



# Change Object Visibility
selection = Selection.CreateByGroups(SelectionType.Primary, "Symmetry")
visibility = VisibilityType.Hide
inSelectedView = False
faceLevel = True
ViewHelper.SetObjectVisibility(selection, visibility, inSelectedView, faceLevel)
# EndBlock

# Create Named Selection Group
primarySelection = Face8
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Rename Named Selection
result = NamedSelection.Rename("Group1", "Inlet")
# EndBlock

# Change Visibility in Selected View
selection = Selection.CreateByGroups(SelectionType.Primary, "Symmetry")
visibility = VisibilityType.AlwaysVisible
inSelectedView = True
faceLevel = True
ViewHelper.SetObjectVisibility(selection, visibility, inSelectedView, faceLevel)
# EndBlock

# Change Object Visibility
selection = Body2
visibility = VisibilityType.Hide
inSelectedView = False
faceLevel = False
ViewHelper.SetObjectVisibility(selection, visibility, inSelectedView, faceLevel)
# EndBlock

# Delete Objects
selection = Component2
result = Delete.Execute(selection)
# EndBlock

