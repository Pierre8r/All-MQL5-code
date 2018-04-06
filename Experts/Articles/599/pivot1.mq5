//+------------------------------------------------------------------+
//|                                                       Pivot1.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   1
//--- plot Pivot
#property indicator_label1  "Pivot1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDarkOrange
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- input parameters
input int      Variant=2;
//--- indicator buffers
double         PivotBuffer[];
double         HighBuffer[];
double         LowBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,PivotBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,HighBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(2,LowBuffer,INDICATOR_CALCULATIONS);
//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

   int start=1;
   if(prev_calculated==0)
     {
      start=1;
     }
   else
     {
      start=prev_calculated-1;
     }
   for(int i=start;i<rates_total;i++)
     {
      PivotBuffer[i]=PivotBuffer[i-1];
      HighBuffer[i]=HighBuffer[i-1];
      LowBuffer[i]=LowBuffer[i-1];
      if(NewDay(time[i],time[i-1],Variant))
        {
         PivotBuffer[i]=(HighBuffer[i]+LowBuffer[i]+close[i-1])/3;
         HighBuffer[i]=high[i];
         LowBuffer[i]=low[i];
        }
      HighBuffer[i]=MathMax(HighBuffer[i],high[i]);
      LowBuffer[i]=MathMin(LowBuffer[i],low[i]);

     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool NewDay(datetime aTimeCur,datetime aTimePre,int aVariant=1)
  {
   switch(aVariant)
     {
      case 1:
         return(NewDay1(aTimeCur,aTimePre));
         break;
      case 2:
         return(NewDay2(aTimeCur,aTimePre));
         break;
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool NewDay1(datetime aTimeCur,datetime aTimePre)
  {
   return((aTimeCur/86400)!=(aTimePre/86400));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool NewDay2(datetime aTimeCur,datetime aTimePre)
  {
   MqlDateTime stm;
//--- new day
   if(NewDay1(aTimeCur,aTimePre))
     {
      TimeToStruct(aTimeCur,stm);
      switch(stm.day_of_week)
        {
         case 6: // Saturday
            return(false);
            break;
         case 0: // Sunday
            return(true);
            break;
         case 1: // Monday
            TimeToStruct(aTimePre,stm);
            if(stm.day_of_week!=0)
              { // preceded by any day of the week other than Sunday
               return(true);
              }
            else
              {
               return(false);
              }
            break;
         default: // any other day of the week
            return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
