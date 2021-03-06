//+------------------------------------------------------------------+
//|                                                        Agent.mq5 |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Strategy\StrategiesList.mqh>
#include <Strategy\Samples\ChannelSample.mqh>
#include <Strategy\Samples\MovingAverage.mqh>
CStrategyList Manager;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Configure and add to the list of strategies CMovingAverage
   CMovingAverage *ma=new CMovingAverage();
   ma.ExpertMagic(1215);
   ma.Timeframe(Period());
   ma.ExpertSymbol(Symbol());
   ma.ExpertName("Moving Average");
   ma.FastMA.MaPeriod(10);
   ma.SlowMA.MaPeriod(23);
   if(!Manager.AddStrategy(ma))
      delete ma;

//--- Configure and add to the list of strategies CChannel
   CChannel *channel=new CChannel();
   channel.ExpertMagic(1216);
   channel.Timeframe(Period());
   channel.ExpertSymbol(Symbol());
   channel.ExpertName("Bollinger Bands");
   channel.PeriodBands(50);
   channel.StdDev(2.0);
   if(!Manager.AddStrategy(channel))
      delete channel;

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   Manager.OnTick();
  }
//+------------------------------------------------------------------+
//| BookEvent function                                               |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol)
  {
   Manager.OnBookEvent(symbol);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   Manager.OnChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
