//+------------------------------------------------------------------+
//|                                                  SessionWeek.mq5 |
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
#property indicator_label1  "SessionWeek"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrGray
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum EWeekDay
  {
   Sunday    =  0,
   Monday    =  1,
   Tuesday   =  2,
   Wednesday =  3,
   Thursday  =  4,
   Friday    =  5,
   Saturday  =  6
  };

//--- input parameters

input EWeekDay StartDay    =  Monday;
input int      StartHour   =  3;
input int      StartMinute =  0;
input EWeekDay StopDay     =  Friday;
input int      StopHour    =  18;
input int      StopMinute  =  0;

bool WeekDays[7];
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
      if(WeekSession(StartDay,StartHour,StartMinute,StopDay,StopHour,StopMinute,time[i]))
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
bool WeekSession(int aStartDay,int aStartHour,int aStartMinute,int aStopDay,int aStopHour,int aStopMinute,datetime aTimeCur)
  {
//--- session start time since the week start
   int StartTime=aStartDay*86400+3600*aStartHour+60*aStartMinute;
//--- session end time since the week start
   int StopTime=aStopDay*86400+3600*aStopHour+60*aStopMinute;
//--- current time in seconds since the week start
   long TimeCur=SecondsFromWeekStart(aTimeCur,false);
   if(StopTime<StartTime)
     {
      //--- passing the turn of the week
      if(TimeCur>=StartTime || TimeCur<StopTime)
        {
         return(true);
        }
     }
   else
     {
      //--- within one week
      if(TimeCur>=StartTime && TimeCur<StopTime)
        {
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long SecondsFromWeekStart(datetime aTime,bool aStartsOnMonday=false)
  {
   return(aTime-WeekStartTime(aTime,aStartsOnMonday));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long WeekStartTime(datetime aTime,bool aStartsOnMonday=false)
  {
   long tmp=aTime;
   long Corrector;
   if(aStartsOnMonday)
     {
      Corrector=259200; // duration of three days (86400*3)
     }
   else
     {
      Corrector=345600; // duration of four days (86400*4)
     }
   tmp+=Corrector;
   tmp=(tmp/604800)*604800;
   tmp-=Corrector;
   return(tmp);
  } 
//+------------------------------------------------------------------+
