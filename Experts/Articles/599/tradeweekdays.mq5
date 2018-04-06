//+------------------------------------------------------------------+
//|                                                TradeWeekDays.mq5 |
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
#property indicator_label1  "TradeWeekDays"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrAqua
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- input parameters
input bool Sunday    =  false;   // Sunday
input bool Monday    =  false;   // Monday
input bool Tuesday   =  true;    // Tuesday   
input bool Wednesday =  true;    // Wednesday
input bool Thursday  =  true;    // Thursday
input bool Friday    =  false;   // Friday
input bool Saturday  =  false;   // Saturday

bool WeekDays[7];
//--- indicator buffers
double         SessionBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   WeekDays_Init();
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
      if(WeekDays_Check(time[i]))
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
void WeekDays_Init()
  {
   WeekDays[0]=Sunday;
   WeekDays[1]=Monday;
   WeekDays[2]=Tuesday;
   WeekDays[3]=Wednesday;
   WeekDays[4]=Thursday;
   WeekDays[5]=Friday;
   WeekDays[6]=Saturday;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WeekDays_Check(datetime aTime)
  {
   MqlDateTime stm;
   TimeToStruct(aTime,stm);
   return(WeekDays[stm.day_of_week]);
  }
//+------------------------------------------------------------------+
