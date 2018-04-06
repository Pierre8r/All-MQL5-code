//+------------------------------------------------------------------+
//|                                                    sTestArea.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart(){

   //--- Bar generation option: 1 - no weekend bars, 2 - 4 bars at the end of Sunday, 3 - all weekend bars, 4 - Saturday bars but no Sunday bars
   int Variant=1;    

   //---

   ObjectsDeleteAll(0);
   color Colors[]={clrGreen,clrBlue,0,0,0,clrRed,clrMagenta};
   int ColorIndex=-1;
   datetime ta[];
   int size=0;
   int i;   
      switch(Variant){
         case 1:
            size=24*2;
            ArrayResize(ta,size);
               for(i=0;i<24;i++){
                  ta[i]=86400+i*3600;
               }
               for(i=24;i<size;i++){
                  ta[i]=86400*3+i*3600;
               }               
         break;
         case 2:
            size=24*2+4;
            ArrayResize(ta,size);
               for(i=0;i<24;i++){
                  ta[i]=86400+i*3600;
               }
            ta[24]=86400*4-4*3600;
            ta[25]=86400*4-3*3600;
            ta[26]=86400*4-2*3600;
            ta[27]=86400*4-1*3600;
               for(i=28;i<size;i++){
                  ta[i]=86400*4+(i-28)*3600;
               }                       
         break;
         case 3:
            size=24*4;
            ArrayResize(ta,size);
               for(i=0;i<size;i++){
                  ta[i]=86400+i*3600;
               }
         break;
         case 4:
            size=24*3;
            ArrayResize(ta,size);
               for(i=0;i<48;i++){
                  ta[i]=86400+i*3600;
               }
               for(i=48;i<size;i++){
                  ta[i]=86400*2+i*3600;
               }
         break;
      }
   MqlDateTime stm;      
      for(i=0;i<size;i++){
         TimeToStruct(ta[i],stm);
         Label("Label_Time_"+(string)i,8*i,100,TimeToString(ta[i],TIME_MINUTES),Colors[stm.day_of_week],90,"Arial",7);
      }
   LikeOnCalculate(size,ta);      
   ChartRedraw(0);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
// Main experimental function
//+------------------------------------------------------------------+
void LikeOnCalculate(const int rates_total,const datetime & time[]){
   for(int i=0;i<rates_total;i++){
      SetMarker(i,0,clrChocolate);
      SetMarker(i,1,clrLime);         
   }
}

//+------------------------------------------------------------------+
// Function for setting a marker                                     |
// Parameters: aBarIndex - bar index, aBufferIndex - marker row      |
// index, aColor - marker color                                      |
//+------------------------------------------------------------------+
void SetMarker(int aBarIndex,int aBufferIndex,color aColor){
   Label("Label_Marker_"+(string)aBufferIndex+"_"+(string)aBarIndex,8*aBarIndex+1,99+8*aBufferIndex,CharToString(110),aColor,0,"Wingdings",9);
}

//+------------------------------------------------------------------+
// Function for creating the OBJ_LABEL graphical object              |
//+------------------------------------------------------------------+
void Label(   
                  string   aObjName    =  "ObjLabel",
                  int      aX          =  30,
                  int      aY          =  30,
                  string   aText       =  "ObjLabel",
                  color    aColor      =  clrRed,
                  double   aAngle      =  0,
                  string   aFont       =  "Arial",
                  int      aSize       =  8
                  ){
   ObjectCreate(0,aObjName,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,aObjName,OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
   ObjectSetInteger(0,aObjName,OBJPROP_BACK,false);
   ObjectSetInteger(0,aObjName,OBJPROP_COLOR,aColor);
   ObjectSetInteger(0,aObjName,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,aObjName,OBJPROP_FONTSIZE,aSize);
   ObjectSetInteger(0,aObjName,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(0,aObjName,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,aObjName,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   ObjectSetInteger(0,aObjName,OBJPROP_XDISTANCE,aX);
   ObjectSetInteger(0,aObjName,OBJPROP_YDISTANCE,aY);
   ObjectSetString(0,aObjName,OBJPROP_TEXT,aText);
   ObjectSetString(0,aObjName,OBJPROP_FONT,aFont);
   ObjectSetDouble(0,aObjName,OBJPROP_ANGLE,aAngle);
}
