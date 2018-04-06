//+------------------------------------------------------------------+
//|                                                  TableSample.mq5 |
//|                                                 Marcin Konieczny |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Marcin Konieczny"
#property version   "1.00"
#property indicator_chart_window
#property indicator_plots 0

#include <Table.mqh>
#include <PriceRow.mqh>
#include <PriceChangeRow.mqh>
#include <RSIRow.mqh>
#include <PriceMARow.mqh>

CTable *table; // pointer to CTable object
//+------------------------------------------------------------------+
//| Indicator initialization function                                |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- timeframes used in table (in multi-timeframe mode)
   ENUM_TIMEFRAMES timeframes[4]={PERIOD_M1,PERIOD_H1,PERIOD_D1,PERIOD_W1};

//--- symbols used in table (in multi-currency mode)
   string symbols[4]={"EURUSD","GBPUSD","USDJPY","AUDCHF" };
//-- CTable object creation 
//   table = new CTable(timeframes); // multi-timeframe mode
   table=new CTable(symbols); // multi-currency mode

//--- adding rows to the table
   table.AddRow(new CPriceRow());                 // shows current price
   table.AddRow(new CPriceChangeRow(false));      // shows change of price in the last bar
   table.AddRow(new CPriceChangeRow(false,true)); // shows percent change of price in the last bar
   table.AddRow(new CPriceChangeRow(true));       // shows change of price as arrows
   table.AddRow(new CRSIRow(14));                 // shows RSI(14)
   table.AddRow(new CRSIRow(10));                 // shows RSI(10)
   table.AddRow(new CPriceMARow(MODE_SMA,20,0));  // shows if SMA(20) > current price

//--- setting table parameters
   table.SetFont("Arial",10,clrYellow);  // font, size, color
   table.SetCellSize(60, 20);           // width, height
   table.SetDistance(10, 10);           // distance from upper right chart corner

   table.Update(); // forces table to redraw

   return(0);
  }
//+------------------------------------------------------------------+
//| Indicator deinitialization function                              |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- calls table destructor and frees memory
   delete(table);
  }
//+------------------------------------------------------------------+
//| Indicator iteration function                                     |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
//--- update table: recalculate/repaint
   table.Update();
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| OnChartEvent handler                                             |
//| Handles CHARTEVENT_CUSTOM events sent by SpyAgent indicators     |
//| Nedeed only in multi-currency mode!                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   table.Update(); // update table: recalculate/repaint
  }
//+------------------------------------------------------------------+
