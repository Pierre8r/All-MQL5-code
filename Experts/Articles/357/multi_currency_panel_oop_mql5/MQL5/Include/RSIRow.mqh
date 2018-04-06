//+------------------------------------------------------------------+
//|                                                       RSIRow.mqh |
//|                                                 Marcin Konieczny |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Marcin Konieczny"

#include <Row.mqh>
//+------------------------------------------------------------------+
//| CRSIRow class                                                    |
//+------------------------------------------------------------------+
class CRSIRow : public CRow
  {
private:
   int               rsiPeriod;        // RSI period
   string            symbols[];        // symbols array
   ENUM_TIMEFRAMES   timeframes[];     // timeframes array
   int               handles[];        // array of RSI handles

   //--- finds the indicator handle for a given symbol and timeframe
   int               GetHandle(string symbol,ENUM_TIMEFRAMES tf);

public:
   //--- constructor
                     CRSIRow(int period);

   //--- overrides default GetValue(..) method from CRow
   virtual string    GetValue(string symbol,ENUM_TIMEFRAMES tf);

   //--- overrides default GetName() method from CRow
   virtual string    GetName();

   //--- overrides default Init(..) method from CRow
   virtual void      Init(string &symb[],ENUM_TIMEFRAMES &tfs[]);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CRSIRow::CRSIRow(int period)
  {
   rsiPeriod=period;
  }
//+------------------------------------------------------------------+
//| Overrides default Init(..) method from CRow                      |
//+------------------------------------------------------------------+
void CRSIRow::Init(string &symb[],ENUM_TIMEFRAMES &tfs[])
  {
   int size=ArraySize(symb);
   
   ArrayResize(symbols,size);
   ArrayResize(timeframes,size);
   ArrayResize(handles,size);
   
//--- copies arrays contents into own arrays
   ArrayCopy(symbols,symb);
   ArrayCopy(timeframes,tfs);
  
//--- gets RSI handles for all used symbols or timeframes
   for(int i=0; i<ArraySize(symbols); i++)
      handles[i]=iRSI(symbols[i],timeframes[i],rsiPeriod,PRICE_CLOSE);
  }
//+------------------------------------------------------------------+
//| Overrides default GetValue(..) method from CRow                  |
//+------------------------------------------------------------------+
string CRSIRow::GetValue(string symbol,ENUM_TIMEFRAMES tf)
  {
   double value[1];

//--- gets RSI indicator handle
   int handle=GetHandle(symbol,tf);

   if(handle==INVALID_HANDLE) return("err");

//--- gets current RSI value
   if(CopyBuffer(handle,0,0,1,value)<0) return("-");

   return(DoubleToString(value[0],2));
  }
//+------------------------------------------------------------------+
//| Overrides default GetName() method from CRow                     |
//+------------------------------------------------------------------+
string CRSIRow::GetName()
  {
   return("RSI("+IntegerToString(rsiPeriod)+")");
  }
//+------------------------------------------------------------------+
//| finds the indicator handle for a given symbol and timeframe      |
//+------------------------------------------------------------------+
int CRSIRow::GetHandle(string symbol,ENUM_TIMEFRAMES tf)
  {
   for(int i=0; i<ArraySize(timeframes); i++)
      if(symbols[i]==symbol && timeframes[i]==tf)
         return(handles[i]);

   return(INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
