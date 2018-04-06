//+------------------------------------------------------------------+
//|                                                          SMA.mq5 |
//|                        Copyright 2009, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//---- the indicator will be plotted in the main window
#property indicator_chart_window
//---- one buffer will be used for the calculations and plot of the indicator
#property indicator_buffers 1
//---- only one graphic plot is used 
#property indicator_plots   1
//---- the indicator should be plotted as a line
#property indicator_type1   DRAW_LINE
//---- the color of the indicator's line is red 
#property indicator_color1  Red 

//---- indicator input parameters
input int MAPeriod = 13; //Averaging period
input int MAShift = 0; //Horizontal shift (in bars)

//---- the declaration of the dynamic array
//that will be used further as an indicator's buffer
double ExtLineBuffer[]; 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+  
void OnInit()
  {
//----+
//---- assign the dynamic array ExtLineBuffer with 0th indicator's buffer
   SetIndexBuffer(0,ExtLineBuffer,INDICATOR_DATA);
//---- set plot shift along the horizontal axis by MAShift bars
   PlotIndexSetInteger(0,PLOT_SHIFT,MAShift);
//---- set plot begin from the bar with number MAPeriod
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,MAPeriod);  
//----+
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(
                const int rates_total,    // number of available bars in history at the current tick
                const int prev_calculated,// number of bars, calculated at previous tick
                const int begin,          // index of the first bar
                const double &price[]     // price array for the calculation
                )
  {
//----+   
   //---- check for the presence of bars, sufficient for the calculation
   if (rates_total < MAPeriod - 1 + begin)
    return(0);
   
   //---- declaration of local variables 
   int first, bar, iii;
   double Sum, SMA;
   
   //---- calculation of starting index first of the main loop
   if(prev_calculated==0) // check for the first start of the indicator
      first=MAPeriod-1+begin; // start index for all the bars
   else first=prev_calculated-1; // start index for the new bars

   //---- main loop of the calculation
   for(bar = first; bar < rates_total; bar++)
    {    
      Sum=0.0;
      //---- summation loop for the current bar averaging
      for(iii=0;iii<MAPeriod;iii++)
         Sum+=price[bar-iii]; // It's equal to: Sum = Sum + price[bar - iii];
         
      //---- calculate averaged value
      SMA=Sum/MAPeriod;

      //---- set the element of the indicator buffer with the value of SMA we have calculated
      ExtLineBuffer[bar]=SMA;
    }
//----+     
   return(rates_total);
  }
//+------------------------------------------------------------------+