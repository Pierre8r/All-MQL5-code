//+------------------------------------------------------------------+
//|                                                         Test.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "Dictionary.mqh"
CDictionary dict;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   if(dict.ContainsKey("Car"))
      printf("Car always exists.");
   else
      dict.AddObject("Car",new CCar());
  }
//+------------------------------------------------------------------+
