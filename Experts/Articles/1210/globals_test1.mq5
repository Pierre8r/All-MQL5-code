//+------------------------------------------------------------------+
//|                                                Globals_test1.mq5 |
//|                                           Copyright 2014, denkir |
//|                           https://login.mql5.com/ru/users/denkir |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, denkir"
#property link      "https://login.mql5.com/ru/users/denkir"
#property version   "1.00"
//---
#include "CGlobalVar.mqh"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   CGlobalVar gVar1;
//--- create a temporary global var
   if(gVar1.Create("Gvar1",3.123456789101235,true))
     {
      Print("\n---=== A new global var ===---");
      PrintFormat("Name: \"%s\"",gVar1.Name());
      PrintFormat("Is temporary: %d",gVar1.IsTemporary());

      //--- Get the value 
      //--- double type
      double d=0.0;
      double dRes=gVar1.GetValue(d);
      PrintFormat("Double value: %0.15f",dRes);
      //--- float type
      float f=0.0;
      float fRes=gVar1.GetValue(f);
      PrintFormat("Float value: %0.7f",fRes);
      //--- string type
      string s=NULL;
      string sRes=gVar1.GetValue(s);
      PrintFormat("String value: %s",sRes);

      //--- Set a new value 
      double new_val=3.191;
      if(gVar1.Value(new_val))
         PrintFormat("New value is set: %f",new_val);

      //--- Set a new value on condition
      new_val=3.18;
      if(gVar1.ValueOnCondition(3.18,3.191))
         PrintFormat("New value on conditionis set: %f",new_val);
     }
  }
//+------------------------------------------------------------------+
