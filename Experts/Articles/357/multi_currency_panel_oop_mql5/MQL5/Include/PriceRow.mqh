//+------------------------------------------------------------------+
//|                                                     PriceRow.mqh |
//|                                                 Marcin Konieczny |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Marcin Konieczny"

#include <Row.mqh>
//+------------------------------------------------------------------+
//| CPriceRow class                                                  |
//+------------------------------------------------------------------+
class CPriceRow : public CRow
  {
public:
   //--- overrides default GetValue(..) method from CRow
   virtual string    GetValue(string symbol,ENUM_TIMEFRAMES tf);

   //--- overrides default GetName() method from CRow
   virtual string    GetName();

  };
//+------------------------------------------------------------------+
//| Overrides default GetValue(..) method from CRow                  |
//+------------------------------------------------------------------+
string CPriceRow::GetValue(string symbol,ENUM_TIMEFRAMES tf)
  {
   MqlTick tick;

//--- gets current price
   if(!SymbolInfoTick(symbol,tick)) return("-");

   return(DoubleToString(tick.bid,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS)));
  }
//+------------------------------------------------------------------+
//| Overrides default GetName() method from CRow                     |
//+------------------------------------------------------------------+
string CPriceRow::GetName()
  {
   return("Price");
  }
//+------------------------------------------------------------------+
