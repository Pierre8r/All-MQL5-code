//+------------------------------------------------------------------+
//|                                                         Test.mq5 |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, Vasiliy Sokolov."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "ObjectsCustom.mqh"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   CObjectCustom *arrayObj[8];
   arrayObj[0] = new CHuman();
   arrayObj[1] = new CWeather();
   arrayObj[2] = new CExpert();
   arrayObj[3] = new CCar();
   arrayObj[4] = new CNumber();
   arrayObj[5] = new CBar();
   arrayObj[6] = new CMetaQuotes();
   arrayObj[7] = new CShip();
  }
//+------------------------------------------------------------------+
