BEGIN { 
FS = ","; 
OFS = ",";

nlayer=0;
nkey=0;
ncmap=0;
layerline=0;
}
{
if (layerline>0) {
	name = LAYERNAMES[nlayer]
	
	if (color==1){ name = "cmap_"name}
   if (layerline==6) {
        keybarray[name][32]=$7;
        keybarray[name][64]=$12;A
        layerline=0;
			color=0;
        }

   if (layerline==5) {
        keybarray[name][28]=$6;
        keybarray[name][29]=$7;
        keybarray[name][30]=$8;
        keybarray[name][31]=$9;

        keybarray[name][60]=$10;
        keybarray[name][61]=$11;
        keybarray[name][62]=$12;
        keybarray[name][63]=$13;
     
        layerline=6;
        }

   if (layerline==4) {
        keybarray[name][21]=$1;
        keybarray[name][22]=$2;
        keybarray[name][23]=$3;
        keybarray[name][24]=$4;
        keybarray[name][25]=$5;
        keybarray[name][26]=$6;
        keybarray[name][27]=$7;                

        keybarray[name][53]=$12;
        keybarray[name][54]=$13;
        keybarray[name][55]=$14;
        keybarray[name][56]=$15;
        keybarray[name][57]=$16;
        keybarray[name][58]=$17;
        keybarray[name][59]=$18;
     
        layerline=5;
        }


   if (layerline==3) {
        keybarray[name][15]=$1;
        keybarray[name][16]=$2;
        keybarray[name][17]=$3;
        keybarray[name][18]=$4;
        keybarray[name][19]=$5;
        keybarray[name][20]=$6;        

        keybarray[name][47]=$13;
        keybarray[name][48]=$14;
        keybarray[name][49]=$15;
        keybarray[name][50]=$16;
        keybarray[name][51]=$17;
        keybarray[name][52]=$18;
     
        layerline=4;
        }

    
    if (layerline==2) {
        keybarray[name][8]=$1;
        keybarray[name][9]=$2;
        keybarray[name][10]=$3;
        keybarray[name][11]=$4;
        keybarray[name][12]=$5;
        keybarray[name][13]=$6;        
        keybarray[name][14]=$7;
        keybarray[name][40]=$12;
        keybarray[name][41]=$13;
        keybarray[name][42]=$14;
        keybarray[name][43]=$15;
        keybarray[name][44]=$16;
        keybarray[name][45]=$17;
        keybarray[name][46]=$18;
        layerline=3;
        }

    if (layerline==1) {
        keybarray[name][1]=$1;
        keybarray[name][2]=$2;
        keybarray[name][3]=$3;
        keybarray[name][4]=$4;
        keybarray[name][5]=$5;
        keybarray[name][6]=$6;        
        keybarray[name][7]=$7;

        keybarray[name][33]=$12;
        keybarray[name][34]=$13;
        keybarray[name][35]=$14;
        keybarray[name][36]=$15;
        keybarray[name][37]=$16;
        keybarray[name][38]=$17;
        keybarray[name][39]=$18;
        
        layerline=2;
        }
    }

if ($1 == "LAYER") {
    nlayer = nlayer + 1;
    LAYERNAMES[nlayer]=$2;    
    layerline=1;
    }
if ($1 == "COLORMAP") {
	ncmap = ncmap + 1;
	COLORMAP[ncmap]=$2;
	color=1;
	layerline=1;

	}

}
END {

for (k = 1; k <= ncmap; ++k) {
    name = COLORMAP[k];
	for (i in LAYERNAMES){if (name == LAYERNAMES[i]) break;} 
	print "COLORMAP,"name","i-1;  #create preamble with the name and position of the layer
    for (i = 2; i <= 64; ++i) {
	kleur = keybarray["cmap_"name][i];
	toets = keybarray[name][i];
	if (toets == "___" || toupper(toets) == "XXX") continue; #these keys are excluded
	if(kleur in test) {test[kleur]=test[kleur] " || "toets;}
	else {test[kleur]=toets;}
        }    
    
	for (i in test) {
		R= strtonum("0x"substr(i,1,2));#convert hex to decimal
		G= strtonum("0x"substr(i,3,2));#convert hex to decimal
		B= strtonum("0x"substr(i,5,2));#convert hex to decimal
		print "if("test[i]"){LEDControl.setCrgbAt(r, c, CRGB("R","G","B"));}"
		}
	print "ENDMAP"; #create postamble
	}
}
