//+------------------------------------------------------------------+
//|                                                         Test.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "Dictionary.mqh"
CDictionary dictionary;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   CObject *obj=new CObject();
   dictionary.AddObject(124,  obj);
   dictionary.AddObject("simple object",  obj);
   dictionary.AddObject(PERIOD_D1,  obj);
  }
//+------------------------------------------------------------------+
