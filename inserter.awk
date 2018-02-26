BEGIN   {
        nf=0;            
        cmd = "awk -f keyboardio-mapper.awk keyboardiolayout.csv";
        while ((cmd |& getline line) > 0) {
              nf=nf+1;      
              temp[nf]=line;
              }       		
        close(cmd);            
        skipflag=0;
        
        }
{ 
   if($0 ~/layers/ && $0 ~/enum/) {
    for (i = 1; i <= nf; ++i)  print temp[i];
    skipflag=1;
    }
   else {
    if (skipflag==0) print $0;
    if ($0 ~/};/ && skipflag==1)skipflag=0;              
    } 
           
}

