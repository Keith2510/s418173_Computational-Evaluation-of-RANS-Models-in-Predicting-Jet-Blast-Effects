# This Spaceclaim script was created to fulfill the thesis requirements of Keith Sequeira (Msc Computational Fluid Dynamics, IRP -2024), titled "Establishing Best Practices for Modeling Jet Blast."
# This script was made with assistance from ChatGPT and Bing AI

# Python Script, API Version = V232
# All measurements are in millimeters unless specified

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
CylinderExtrudeLength = 30

# Enclosure Parameters
Solid_LR = 99.5
Solid_Ground = 0.5
Solid_Top = 198.5
Solid_Outlet = 470
Solid_FrontFace = 7.5
Pull = -7.5

# Set Sketch Plane
selection = Axis1
result = ViewHelper.SetSketchPlane(selection, Info1)
# EndBlock

# Sketch Circle
origin = Point2D.Create(MM(0), MM(0))
result = SketchCircle.Create(origin, MM(CylinderRadius))

baseSel = SelectionPoint.Create(CurvePoint1)
targetSel = SelectionPoint.Create(DatumLine1)

result = Constraint.CreateCoincident(baseSel, targetSel)

baseSel = SelectionPoint.Create(CurvePoint1)
targetSel = SelectionPoint.Create(DatumLine2)

result = Constraint.CreateCoincident(baseSel, targetSel)

baseSel = SelectionPoint.Create(CurvePoint1)
targetSel = SelectionPoint.Create(DatumPoint1)

result = Constraint.CreateCoincident(baseSel, targetSel)
# EndBlock

# Solidify Sketch
mode = InteractionMode.Solid
result = ViewHelper.SetViewMode(mode, Info2)
# EndBlock

# Extrude 1 Face
selection = Face1
options = ExtrudeFaceOptions()
options.ExtrudeType = ExtrudeType.Add
result = ExtrudeFaces.Execute(selection, MM(CylinderExtrudeLength), options, Info3)
# EndBlock

# Create Enclosure
selection = Body1

options = EnclosureOptions()
options.EnclosureType = EnclosureType.Box
options.EnclosureCushion = BoxEnclosureCushion(MM(Solid_FrontFace),MM(Solid_Outlet),MM(Solid_Ground),MM(Solid_Top),MM(Solid_LR),MM(Solid_LR))
result = Enclosure.Create(selection, options)
# EndBlock

# Extrude 1 Face
selection = Face2
options = ExtrudeFaceOptions()
options.ExtrudeType = ExtrudeType.Cut
result = ExtrudeFaces.Execute(selection, MM(Pull), options, Info4)
# EndBlock

# Create Named Selection Group
primarySelection = Face2
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Rename Named Selection
result = NamedSelection.Rename("Group1", "JetWall")
# EndBlock

# Create Named Selection Group
primarySelection = FaceSelection.Create(Face3, Face4, Face5)
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Rename Named Selection
result = NamedSelection.Rename("Group1", "Symmetry")
# EndBlock

# Create Named Selection Group
primarySelection = Face6
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Rename Named Selection
result = NamedSelection.Rename("Group1", "Ground")
# EndBlock

# Create Named Selection Group
primarySelection = Face7
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Rename Named Selection
result = NamedSelection.Rename("Group1", "Outlet")
# EndBlock

# Change Object Visibility
selection = Selection.CreateByGroups(SelectionType.Primary, "Symmetry")
visibility = VisibilityType.Hide
inSelectedView = False
faceLevel = True
ViewHelper.SetObjectVisibility(selection, visibility, inSelectedView, faceLevel)
# EndBlock

# Rename 'Solid' to 'Jet'
selection = Body1
result = RenameObject.Execute(selection,"Jet")
# EndBlock

# Exclude items from physics
selection = Body1
suppress = True
ViewHelper.SetSuppressForPhysics(selection, suppress)
# EndBlock

# Delete Objects
selection = Body1
result = Delete.Execute(selection)
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