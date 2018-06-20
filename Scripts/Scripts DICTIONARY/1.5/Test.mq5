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
   CObjectCustom *arrayObj[3];
   arrayObj[0] = new CHuman();
   arrayObj[1] = new CWeather();
   arrayObj[2] = new CBar();
   for(int i=0; i<ArraySize(arrayObj); i++)
     {
      CObjectCustom *obj=arrayObj[i];
      switch(obj.Type())
        {
         case TYPE_HUMAN:
           {
            CHuman *human=obj;
            human.Run();
            break;
           }
         case TYPE_WEATHER:
           {
            CWeather *weather=obj;
            printf(DoubleToString(weather.Temp(),1));
            break;
           }
         default:
            printf("unknown type.");
        }
     }
  }
//+------------------------------------------------------------------+
