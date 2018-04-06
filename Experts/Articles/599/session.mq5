//+------------------------------------------------------------------+
//|                                                      Session.mq5 |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 2
#property indicator_buffers 1
#property indicator_plots   1
//--- plot Session
#property indicator_label1  "Session"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrLime
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- input parameters
input int      StartHour=10;
input int      StartMinute=0;
input int      StopHour=14;
input int      StopMinute=0;
//--- indicator buffers
double         SessionBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,SessionBuffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,159);
//---
   IndicatorSetInteger(INDICATOR_DIGITS,0);
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
   int start=0;
   if(prev_calculated==0)
     {
      start=0;
     }
   else
     {
      start=prev_calculated-1;
     }
   for(int i=start;i<rates_total;i++)
     {
      if(TimeSession(StartHour,StartMinute,StopHour,StopMinute,time[i]))
        {
         SessionBuffer[i]=1;
        }
      else
        {
         SessionBuffer[i]=EMPTY_VALUE;
        }
     }

   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TimeSession(int aStartHour,int aStartMinute,int aStopHour,int aStopMinute,datetime aTimeCur)
  {
//--- session start time
   int StartTime=3600*aStartHour+60*aStartMinute;
//--- session end time
   int StopTime=3600*aStopHour+60*aStopMinute;
//--- current time in seconds since the day start
   aTimeCur=aTimeCur%86400;
   if(StopTime<StartTime)
     {
      //--- going past midnight
      if(aTimeCur>=StartTime || aTimeCur<StopTime)
        {
         return(true);
        }
     }
   else
     {
      //--- within one day
      if(aTimeCur>=StartTime && aTimeCur<StopTime)
        {
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
