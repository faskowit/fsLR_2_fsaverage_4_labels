#!/bin/bash

# adapted from M. Harms script with following note:
## Script for converting Gordon333 dlabel to fsaverage .annot equivalent
## M.P. Harms
## March 11, 2016

# downloaded from here: https://mail.nmr.mgh.harvard.edu/pipermail//freesurfer/2017-April/051554.html

# dependencies = FREESURFER, connectome_wb

######################################################################################################
######################################################################################################

# get the dir where the main is, will need to read path to external data
wDir=$(dirname "$(readlink -f "$0")")/

if [[ -z ${FREESURFER_HOME} ]]
then 
	echo "need FREESURFER to be exported to script"
	exit 1
fi

if [[ -z ${WB_CONNECTOME_BIN_DIR} ]]
then
	echo "please specify WB_CONNECTOME_BIN_DIR to the dir where the wb_command is"
	exit 1
fi

######################################################################################################
######################################################################################################

if [ "$#" -lt 5 ]; then

	cat <<USAGE

	Usage:
	$(basename $0) [output dir] [output basename] [left label.gii] [right label.gii] [resolution]

USAGE

    exit 1
fi

# read in some user input
outDir=$1
outBaseName=$2

LH_gii=$3
RH_gii=$4

res=$5

if [[ ! "$res" =~ ^(32|59|164)$ ]]
then
	echo "res must be either 32, 59, or 164"
	exit 1
fi

# make output dir
mkdir -p $outDir

######################################################################################################
######################################################################################################

# the main command..
# wb_command -label-resample <label-in> <current-sphere> <new-sphere> ADAP_BARY_AREA <label-out> -area-metrics <current-area> <new-area>

for hemiGii in LH_gii RH_gii
do

    hemi=$(echo ${hemiGii:0:1})

    if [ "$hemi" == "L" ]
    then
		fshemi=lh
    else
		fshemi=rh
    fi
    echo $fshemi

   	currGii=${!hemiGii} 

   	currSphere="${wDir}/data/external/fs_LR-deformed_to-fsaverage.${hemi}.sphere.${res}k_fs_LR.surf.gii"
   	newSphere="${wDir}/data/external/fsaverage_std_sphere.${hemi}.164k_fsavg_${hemi}.surf.gii"

   	currArea="${wDir}/data/external/fs_LR.${hemi}.midthickness_va_avg.${res}k_fs_LR.shape.gii"
   	newArea="${wDir}/data/external/fsaverage.${hemi}.midthickness_va_avg.164k_fsavg_${hemi}.shape.gii"

   	outGii="${outDir}/${outBaseName}_${hemi}_${res}k.label.gii"

	##################################################################################################
	##################################################################################################

   	# run the magic
   	cmd="${WB_CONNECTOME_BIN_DIR}/wb_command \
   			-label-resample \
   			${currGii} \
   			${currSphere} ${newSphere} \
   			ADAP_BARY_AREA \
   			${outGii} \
   			-area-metrics \
   			${currArea} ${newArea} \
   		"
   	echo $cmd
   	eval $cmd

	##################################################################################################
	##################################################################################################

	outAnnot="${outDir}/${fshemi}.${outBaseName}_fsaverage.annot"

   	# convert that output to a freesurder annotation, use the white surfrace of fsaverage
   	cmd="${FREESURFER_HOME}/bin/mris_convert \
   			--annot ${outGii} \
   			${FREESURFER_HOME}/subjects/fsaverage/surf/${fshemi}.white \
   			${outAnnot}
   		"
   	echo $cmd
   	eval $cmd

done




