//+------------------------------------------------------------------+
//|                                                       Pivot2.mq5 |
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
#property indicator_label1  "Pivot2"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDarkOrange
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- input parameters
input int      Hour=14;
input int      Minute=0;
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
      if(NewCustomDay(Hour,Minute,time[i],time[i-1]))
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
bool NewCustomDay(int aHour,int aMinute,datetime aTimeCur,datetime aTimePre)
  {
   MqlDateTime stm;
   if(TimeCross(aHour,aMinute,aTimeCur,aTimePre))
     {
      TimeToStruct(aTimeCur,stm);
      if(stm.day_of_week==0 || stm.day_of_week==6)
        {
         return(false);
        }
      else
        {
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TimeCross(int aHour,int aMinute,datetime aTimeCur,datetime aTimePre)
  {
//--- specified time since the day start
   datetime PointTime=aHour*3600+aMinute*60;
//--- current time since the day start
   aTimeCur=aTimeCur%86400;
//--- previous time since the day start
   aTimePre=aTimePre%86400;
   if(aTimeCur<aTimePre)
     {
      //--- going past midnight
      if(aTimeCur>=PointTime || aTimePre<PointTime)
        {
         return(true);
        }
     }
   else
     {
      if(aTimeCur>=PointTime && aTimePre<PointTime)
        {
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
