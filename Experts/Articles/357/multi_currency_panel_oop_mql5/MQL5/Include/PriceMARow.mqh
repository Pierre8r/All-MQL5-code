//+------------------------------------------------------------------+
//|                                                   PriceMARow.mqh |
//|                                                 Marcin Konieczny |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Marcin Konieczny"

#include <Row.mqh>
//+------------------------------------------------------------------+
//| CPriceMARow class                                                |
//+------------------------------------------------------------------+
class CPriceMARow : public CRow
  {
private:
   int               maPeriod; // period of moving average
   int               maShift;  // shift of moving average
   ENUM_MA_METHOD    maType;   // SMA, EMA, SMMA or LWMA
   string            symbols[];        // symbols array
   ENUM_TIMEFRAMES   timeframes[];     // timeframes array
   int               handles[];        // array of MA handles

   //--- finds the indicator handle for a given symbol and timeframe
   int               GetHandle(string symbol,ENUM_TIMEFRAMES tf);

public:
   //--- constructor
                     CPriceMARow(ENUM_MA_METHOD type,int period,int shift);

   //--- overrides default GetValue(..) method of CRow
   virtual string    GetValue(string symbol,ENUM_TIMEFRAMES tf);

   // overrides default GetName() method CRow
   virtual string    GetName();

   //--- overrides default Init(..) method from CRow
   virtual void      Init(string &symb[],ENUM_TIMEFRAMES &tfs[]);
  };
//+------------------------------------------------------------------+
//| CPriceMARow class constructor                                    |
//+------------------------------------------------------------------+
CPriceMARow::CPriceMARow(ENUM_MA_METHOD type,int period,int shift)
  {
   maPeriod= period;
   maShift = shift;
   maType=type;
  }
//+------------------------------------------------------------------+
//| Overrides default Init(..) method from CRow                      |
//+------------------------------------------------------------------+
void CPriceMARow::Init(string &symb[],ENUM_TIMEFRAMES &tfs[])
  {
   int size=ArraySize(symb);
   
   ArrayResize(symbols,size);
   ArrayResize(timeframes,size);
   ArrayResize(handles,size);
   
//--- copies arrays contents into own arrays
   ArrayCopy(symbols,symb);
   ArrayCopy(timeframes,tfs);
  
//--- gets MA handles for all used symbols or timeframes
   for(int i=0; i<ArraySize(symbols); i++)
      handles[i]=iMA(symbols[i],timeframes[i],maPeriod,maShift,maType,PRICE_CLOSE);
  }
//+------------------------------------------------------------------+
//| Overrides default GetValue(..) method of CRow                    |
//+------------------------------------------------------------------+
string CPriceMARow::GetValue(string symbol,ENUM_TIMEFRAMES tf)
  {
   double value[1];
   MqlTick tick;

//--- obtains MA indicator handle
   int handle=GetHandle(symbol,tf);

   if(handle==INVALID_HANDLE) return("err");

//--- gets the last MA value
   if(CopyBuffer(handle,0,0,1,value)<0) return("-");
//--- gets the last price
   if(!SymbolInfoTick(symbol,tick)) return("-");

//--- checking the condition: price > MA
   if(tick.bid>value[0])
      return("Yes");
   else
      return("No");
  }
//+------------------------------------------------------------------+
//| Overrides default GetName() method of CRow                       |
//+------------------------------------------------------------------+
string CPriceMARow::GetName()
  {
   string name;

   switch(maType)
     {
      case MODE_SMA: name = "SMA"; break;
      case MODE_EMA: name = "EMA"; break;
      case MODE_SMMA: name = "SMMA"; break;
      case MODE_LWMA: name = "LWMA"; break;
     }

   return("Price>"+name+"("+IntegerToString(maPeriod)+")");
  }
//+------------------------------------------------------------------+
//| finds the indicator handle for a given symbol and timeframe      |
//+------------------------------------------------------------------+
int CPriceMARow::GetHandle(string symbol,ENUM_TIMEFRAMES tf)
  {
   for(int i=0; i<ArraySize(timeframes); i++)
      if(symbols[i]==symbol && timeframes[i]==tf)
         return(handles[i]);

   return(INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
