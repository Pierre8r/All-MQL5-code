//+------------------------------------------------------------------+
//|                                                        uLong.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
struct DoubleValue{ double value;} dValue;
struct ULongValue { ulong value; } lValue;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   dValue.value=3.14159;
   lValue=(ULongValue)dValue;
   printf((string)lValue.value);
   dValue.value=3.14160;
   lValue=(ULongValue)dValue;
   printf((string)lValue.value);
  }
//+------------------------------------------------------------------+
