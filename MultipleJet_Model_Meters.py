# This Spaceclaim script was created to fulfill the thesis requirements of Keith Sequeira (Msc Computational Fluid Dynamics, IRP -2024), titled "Establishing Best Practices for Modeling Jet Blast."
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

        
################################ Parameters ################################
# Cylinder Parameters
CylinderRadius = 0.5
CylinderExtrudeLength = -30
num_cylinders = 6
spacing = 8


# Enclosure Parameters
Solid_LR = 81.5
Solid_Ground = 0.5
Solid_Top = 198.5
Solid_Outlet = 470
Solid_FrontFace = 7.5
Pull = -7.5

################################ Cylinder Modelling ################################
# Set Sketch Plane
sectionPlane = Plane.PlaneXY
result = ViewHelper.SetSketchPlane(sectionPlane, None)

# Function to create circles based on the number of cylinders and spacing
def create_circles(num_cylinders, spacing, radius):
    for i in range(num_cylinders):
        origin = Point2D.Create(M(i * spacing), M(0))
        result = SketchCircle.Create(origin, M(radius))
        
        if i == 0:
            # Create Coincident Constraint for the first circle
            baseSel = SelectionPoint.Create(GetRootPart().DatumPlanes[0].Curves[0].GetChildren[ICurvePoint]()[0])
            targetSel = SelectionPoint.Create(GetRootPart().DatumPlanes[0].GetChildren[IDatumPoint]()[0])
            result = Constraint.CreateCoincident(baseSel, targetSel)
        else:
            # Create Coincident Constraint for subsequent circles
            baseSel = SelectionPoint.Create(GetRootPart().DatumPlanes[0].Curves[i].GetChildren[ICurvePoint]()[0])
            targetSel = SelectionPoint.Create(GetRootPart().DatumPlanes[0].GetChildren[IDatumLine]()[0])
            result = Constraint.CreateCoincident(baseSel, targetSel)

            # Create Equal Radius Constraint
            baseSel = Selection.Create(GetRootPart().DatumPlanes[0].Curves[i])
            targetSel = Selection.Create(GetRootPart().DatumPlanes[0].Curves[i - 1])  # Adjusted index here
            result = Constraint.CreateEqualRadius(baseSel, targetSel)

            # Create Distance Dimension
            if i > 0:  # Only create dimension from the second circle onwards
                dimTarget1 = Selection.Create(GetRootPart().DatumPlanes[0].Curves[i - 1].GetChildren[ICurvePoint]()[0])
                dimTarget2 = Selection.Create(GetRootPart().DatumPlanes[0].Curves[i].GetChildren[ICurvePoint]()[0])
                alignment = DimensionAlignment.Horizontal
                span = DimensionSpan.MinMin
                result = Dimension.CreateDistance(dimTarget1, dimTarget2, alignment, span)

                # Edit dimension
                selDimension = Selection.Create(GetRootPart().DatumPlanes[0].GetChildren[IDimension]()[i - 1])
                result = Dimension.Modify(selDimension, M(spacing))

create_circles(num_cylinders, spacing, CylinderRadius)

# Solidify Sketch
mode = InteractionMode.Solid
result = ViewHelper.SetViewMode(mode, None)

# Function to extrude all faces with a given length and extrude type
def extrude_all_faces(length, extrude_type):
    for body in GetRootPart().Bodies:
        for face in body.Faces:
            selection = FaceSelection.Create(face)
            options = ExtrudeFaceOptions()
            options.ExtrudeType = extrude_type
            result = ExtrudeFaces.Execute(selection, M(length), options)

# Call the function with the desired extrude length and type
extrude_all_faces(CylinderExtrudeLength, ExtrudeType.Cut)

# Make Components
selection = BodySelection.Create([GetRootPart().Bodies[i] for i in range(num_cylinders)])
result = ComponentHelper.MoveBodiesToComponent(selection, None)

# Rename 'Component1' to 'Jet'
selection = PartSelection.Create(GetRootPart().Components[0].Content)
result = RenameObject.Execute(selection, "Jet")


################################ Enclosure Modelling ################################
# Create Enclosure around all cylinders
cylinder_bodies = [GetRootPart().Components[0].Content.Bodies[i] for i in range(num_cylinders)]

# Extend the selection to include all cylinder bodies
enclosure_selection = BodySelection.Create(cylinder_bodies)

options = EnclosureOptions()
options.EnclosureType = EnclosureType.Box
options.EnclosureCushion = BoxEnclosureCushion(M(Solid_LR), M(Solid_LR), M(Solid_Ground), M(Solid_Top), M(Solid_Outlet), M(Solid_FrontFace))
result = Enclosure.Create(enclosure_selection, options)
# EndBlock

# Extrude 1 Face
selection = FaceSelection.Create(GetRootPart().Components[1].Content.Bodies[0].Faces[4])
options = ExtrudeFaceOptions()
options.ExtrudeType = ExtrudeType.Cut
result = ExtrudeFaces.Execute(selection, M(Pull), options)
# EndBlock

# Change Object Visibility
selection = BodySelection.Create(GetRootPart().Components[1].Content.Bodies[0])
visibility = VisibilityType.Hide
inSelectedView = False
faceLevel = False
ViewHelper.SetObjectVisibility(selection, visibility, inSelectedView, faceLevel)
# EndBlock

# Set Style
selection = FaceSelection.Create([GetRootPart().Components[0].Content.Bodies[1].Faces[0],
    GetRootPart().Components[0].Content.Bodies[0].Faces[0]])
ColorHelper.SetFillStyle(selection, FillStyle.Transparent)
# EndBlock

# Change Object Visibility for cylinders
for i in range(num_cylinders):
    selection = FaceSelection.Create([GetRootPart().Components[0].Content.Bodies[i].Faces[j] for j in range(len(GetRootPart().Components[0].Content.Bodies[i].Faces))])
    ColorHelper.SetFillStyle(selection, FillStyle.Transparent)
# EndBlock

# Show Enclosure
selection = BodySelection.Create(GetRootPart().Components[1].Content.Bodies[0])
visibility = VisibilityType.Show
inSelectedView = False
faceLevel = False
ViewHelper.SetObjectVisibility(selection, visibility, inSelectedView, faceLevel)
# EndBlock


# Create Named Selection Group
primarySelection = FaceSelection.Create(GetRootPart().Components[1].Content.Bodies[0].Faces[4])
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Create Named Selection Group
primarySelection = FaceSelection.Create([GetRootPart().Components[1].Content.Bodies[0].Faces[1],
    GetRootPart().Components[1].Content.Bodies[0].Faces[0],
    GetRootPart().Components[1].Content.Bodies[0].Faces[3]])
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Create Named Selection Group
primarySelection = FaceSelection.Create(GetRootPart().Components[1].Content.Bodies[0].Faces[2])
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Create Named Selection Group
primarySelection = FaceSelection.Create(GetRootPart().Components[1].Content.Bodies[0].Faces[5])
secondarySelection = Selection.Empty()
result = NamedSelection.Create(primarySelection, secondarySelection)
# EndBlock

# Rename Named Selection
result = NamedSelection.Rename("Group1", "JetWall")
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
