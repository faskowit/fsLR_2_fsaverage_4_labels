# fsLR_2_fsaverage_4_labels
Go from fs_LR to freesurfer average space in one dandy function! 

This function takes in left and right `.label.gii` files and transforms them to fsaverage space, based on the method and provided data [here](https://wiki.humanconnectome.org/display/PublicData/HCP+Users+FAQ#HCPUsersFAQ-9.HowdoImapdatabetweenFreeSurferandHCP?). Based in part on the super useful script provided by Michael Harms [here](https://mail.nmr.mgh.harvard.edu/pipermail//freesurfer/2017-April/051554.html).

```
 Usage:
  main.sh [output dir] [output basename] [left label.gii] [right label.gii] [resolution of gii data]
```
