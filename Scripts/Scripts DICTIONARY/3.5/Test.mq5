//+------------------------------------------------------------------+
//|                                                         Test.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "Dictionary.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStringValue : public CObject
  {
public:
   string            Value;
                     CStringValue();
                     CStringValue(string value){Value=value;}
  };
CDictionary dict;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   dict.AddObject("CNumber", new CStringValue("CNumber"));
   dict.AddObject("CShip", new CStringValue("CShip"));
   dict.AddObject("CWeather", new CStringValue("CWeather"));
   dict.AddObject("CHuman", new CStringValue("CHuman"));
   dict.AddObject("CExpert", new CStringValue("CExpert"));
   dict.AddObject("CCar", new CStringValue("CCar"));
   CStringValue *currString=dict.GetFirstNode();
   for(int i=1; currString!=NULL; i++)
     {
      printf((string)i+":\t"+currString.Value);
      currString=dict.GetNextNode();
     }
  }
//+------------------------------------------------------------------+
