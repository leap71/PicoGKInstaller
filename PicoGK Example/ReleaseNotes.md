# Release Notes

## PicoGK v1.5.0

PicoGK v1.5.0 is a major update. The focus of this release is the introduction of field data types for scalar fields and vector fields. Using these types, you can interface with simulation packages, and read the results back to build feedback loops in your software.

- **NEW**: New data types for scalar fields and vector fields.
- **NEW**: Support for reading/writing scalar fields and vector fields to OpenVDB
- **NEW**: Access to OpenVDB field metadata in Voxels, ScalarField, VectorField
- **NEW:** Library info, voxel size, PicoGK classes etc. all saved to OpenVDB metadata
- **NEW**: Added example to show usage of fields
- **NEW**: Added example to show how to exchange simulation setup information using OpenVDB and multiple field types
- **NEW**: Added LEAP 71 QuasiCrystal library to examples, which allows you to build aperiodic 2D and 3D structures (Penrose Tiles and Quasicrystals)
- **NEW:** Viewer now supports adding arrow heads to polylines
- **NEW:** Viewer now supports adding a cross at the end of a polyline
- **NEW**: VoxelUtils class has functions to count active voxels, extract surface normals.
- **NEW**: Voxel slices can be output as grayscale and black and white
- **NEW**: Grayscale image now has a function to determine whether it contains any active pixels
- **NEW**: Added HLS and HSV color types (allows you to easily desaturate etc. colors)
- **NEW**: Example to show how to load an STL file and prepare it for printing
- **NEW**: Added function to find project source path
- **NEW**: Added experimental Voxels.Gaussian(), Voxels.Median(), and Voxels.Mean() functions to average/blur a voxel field. These are to be considered experimental at this point, as we are not sure if the results are robust enough across multiple voxel sizes, to be useful for engineering.
- **FIX**: Voxel insertion/removal into the viewer was not thread-safe
- **CHANGE**: Added asserts to make sure NaN values inserted into a bounding box throw an alert



## PicoGK v1.2.0

**PicoGK v1.2** adds **support for reading and writing OpenVDB .vdb files**. At this time, the openvdb::GRID_LEVEL_SET data type, which is what we use to represent our Voxels object is supported.

PicoGK v1.2 requires the updated 1.2 runtime, which is automatically installed when using the installers.

The following changes were made:

- **NEW**: Added example on how to create a simple lattice and how to extract slices from it (run **PicoGKExamples. SimpleLatticeAndSliceExtract.Task**)
- **FIX**: Including an empty bounding box to an empty bounding box, made bounding box infinitely large.
- **FIX**: Made ASCII vs. Binary detection of STLs more robust
- **FIX**: Loading ASCII STL now correctly throws a "not implemented" exception.
- **CHANGE**: If loading an STL results in an empty mesh, an exception is thrown
- **CHANGE**: If bounding box of viewer objects is empty, matrix calculations are skipped, to avoid invalid math operations.
- **NEW**: Added function to append one mesh to another (no intelligence, just adds the triangles, regardless of the mesh topology). Useful for helper meshes in the GUI, for example.
- **NEW**: Added way to create mesh from BBox3
- **FIX**: Removed unimplemented Voxels.BoolAddSmooth function, which was throwing an error.
- **NEW**: Added TempFolder class to hold a temp folder that is automatically created and deleted when no longer used.
- **FIX**: Width/Height were flipped in GetVoxelSlice, if you worked around by flipping x/y, you need to undo that change. Now works correctly: Width is X, Height is Y
- **FIX:** Fixed NaN values at the center of flat cap beams of lattices. Flat cap beam lattices now no longer have a tiny hole in their middle
- **FIX**: Memory of meshes was never freed in the PicoGK Runtime
- **NEW**: Added a function to wait for the creation of a file
- **NEW**: Support for reading and writing OpenVDB .VDB files. (For details, run **PicoGKExamples. OpenVdbExample.Task**)
- **CHANGE**: PicoGK Example, which is installed by the installers incorporates the latest LEAP 71 Libraries (Shape Kernel, Lattice Library).
