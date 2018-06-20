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
   arrayObj[0]=new CHuman();
   CObjectCustom*obj=arrayObj[0];
   CHuman *human=obj;
  }
//+------------------------------------------------------------------+
