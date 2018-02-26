BEGIN { 
FS = ","; 
OFS = ",";

nlayer=0;
nkey=0;
layerline=0;
}
{
if (layerline>0) {
    name = LAYERNAMES[nlayer]
   if (layerline==6) {
        lefthalf[name][32]=$7;
        righthalf[name][32]=$12;
        layerline=0;
        }

   if (layerline==5) {
        lefthalf[name][28]=$6;
        lefthalf[name][29]=$7;
        lefthalf[name][30]=$8;
        lefthalf[name][31]=$9;

        righthalf[name][28]=$10;
        righthalf[name][29]=$11;
        righthalf[name][30]=$12;
        righthalf[name][31]=$13;
     
        layerline=6;
        }

   if (layerline==4) {
        lefthalf[name][21]=$1;
        lefthalf[name][22]=$2;
        lefthalf[name][23]=$3;
        lefthalf[name][24]=$4;
        lefthalf[name][25]=$5;
        lefthalf[name][26]=$6;
        lefthalf[name][27]=$7;                

        righthalf[name][21]=$12;
        righthalf[name][22]=$13;
        righthalf[name][23]=$14;
        righthalf[name][24]=$15;
        righthalf[name][25]=$16;
        righthalf[name][26]=$17;
        righthalf[name][27]=$18;
     
        layerline=5;
        }


   if (layerline==3) {
        lefthalf[name][15]=$1;
        lefthalf[name][16]=$2;
        lefthalf[name][17]=$3;
        lefthalf[name][18]=$4;
        lefthalf[name][19]=$5;
        lefthalf[name][20]=$6;        

        righthalf[name][15]=$13;
        righthalf[name][16]=$14;
        righthalf[name][17]=$15;
        righthalf[name][18]=$16;
        righthalf[name][19]=$17;
        righthalf[name][20]=$18;
     
        layerline=4;
        }

    
    if (layerline==2) {
        lefthalf[name][8]=$1;
        lefthalf[name][9]=$2;
        lefthalf[name][10]=$3;
        lefthalf[name][11]=$4;
        lefthalf[name][12]=$5;
        lefthalf[name][13]=$6;        
        lefthalf[name][14]=$7;

        righthalf[name][8]=$12;
        righthalf[name][9]=$13;
        righthalf[name][10]=$14;
        righthalf[name][11]=$15;
        righthalf[name][12]=$16;
        righthalf[name][13]=$17;
        righthalf[name][14]=$18;
        layerline=3;
        }

    if (layerline==1) {
        lefthalf[name][1]=$1;
        lefthalf[name][2]=$2;
        lefthalf[name][3]=$3;
        lefthalf[name][4]=$4;
        lefthalf[name][5]=$5;
        lefthalf[name][6]=$6;        
        lefthalf[name][7]=$7;

        righthalf[name][1]=$12;
        righthalf[name][2]=$13;
        righthalf[name][3]=$14;
        righthalf[name][4]=$15;
        righthalf[name][5]=$16;
        righthalf[name][6]=$17;
        righthalf[name][7]=$18;
        
        layerline=2;
        }
    }

if ($1 == "LAYER") {
    nlayer = nlayer + 1;
    LAYERNAMES[nlayer]=$2;    
    layerline=1;
    }

}
END {
laynames = LAYERNAMES[1];
for (k = 2; k <= nlayer; ++k) laynames=laynames OFS LAYERNAMES[k];

print "enum {"laynames"}; // layers"
print "const Key keymaps[][ROWS][COLS] PROGMEM = {"
for (k = 1; k <= nlayer; ++k) {
    name = LAYERNAMES[k];
    left = lefthalf[name][1];
    right= righthalf[name][1];
    for (i = 2; i <= 32; ++i) {
        left=left OFS lefthalf[name][i];
        right=right OFS righthalf[name][i];
        }    
    print "["name"] = KEYMAP_STACKED"
    if (k < nlayer) print "("left right"),";
    else print "("left OFS right")";
    }
print "};"


}
