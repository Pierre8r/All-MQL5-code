//+------------------------------------------------------------------+
//|                                                    TimePoint.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot TimePoint
#property indicator_label1  "TimePoint"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- input parameters
input int      Hour=14;
input int      Minute=0;
//--- indicator buffers
double         TimePointBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,TimePointBuffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,169);
   PlotIndexSetInteger(0,PLOT_ARROW_SHIFT,10);
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
      if(TimeCross(Hour,Minute,time[i],time[i-1]))
        {
         TimePointBuffer[i]=low[i];
        }
      else
        {
         TimePointBuffer[i]=EMPTY_VALUE;
        }
     }
   return(rates_total);
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
