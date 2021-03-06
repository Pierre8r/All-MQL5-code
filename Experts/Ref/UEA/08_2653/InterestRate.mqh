//+------------------------------------------------------------------+
//|                                                EventListener.mqh |
//|           Copyright 2017, Vasiliy Sokolov, St-Petersburg, Russia |
//|                                https://www.mql5.com/en/users/c-4 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Vasiliy Sokolov."
#property link      "https://www.mql5.com/en/users/c-4"
#include <Strategy\Strategy.mqh>
#include <Arrays\ArrayObj.mqh>
#include "Panel.mqh"

//+------------------------------------------------------------------+
//| Interest rate profile                                            |
//+------------------------------------------------------------------+
class CIntRate : public CStrategy
  {
   CArrayObj         Symbols;    // The list of symbols
   CPercentPanel     Panel;      // Panel for displaying the interest rate
   double            BaseRate(CSymbol* fut);
public:
   virtual void      OnEvent(const MarketEvent& event);
   virtual bool      OnInit();
  };
//+-------------------------------------------------------------------+
//| Adds required futures to calculate the interest rate profile      |
//+-------------------------------------------------------------------+
bool CIntRate::OnInit(void)
  {
   string basis = WS.NameBasisSymbol();
   for(int i = 0; i < SymbolsTotal(false); i++)
   {
      string name = SymbolName(i, false);
      int index = StringFind(name, basis, 0);
      if(index != 0)
         continue;
      CSymbol* Fut = new CSymbol(name, Timeframe());
      if(Fut.ExpirationDate() == 0 || Fut.ExpirationDate() < TimeCurrent())
      {
         delete Fut;
         continue;
      }
      string text = "Add new symbol " + Fut.Name() + " in symbols list";
      CMessage* msg = new CMessage(MESSAGE_INFO, __FUNCTION__, text);
      Log.AddMessage(msg);
      Symbols.Add(Fut);
   }
   string text = "Total add symbols " + (string)Symbols.Total();
   CMessage* msg = new CMessage(MESSAGE_INFO, __FUNCTION__, text);
   Log.AddMessage(msg);
   if(Symbols.Total() > 0)
   {
      Panel.Show();
   }
   return true;
  }

//+------------------------------------------------------------------+
//| Calculates the profile and displays it in a table                |
//+------------------------------------------------------------------+
void CIntRate::OnEvent(const MarketEvent &event)
  {
   double sec_one_day = 60*60*24;   //86 400
   for(int i = 0; i < Symbols.Total(); i++)
   {
      CSymbol* Fut = Symbols.At(i);
      double brate = BaseRate(Fut);
      double days = (Fut.ExpirationDate()-TimeCurrent())/sec_one_day;
      if(Fut.Last() == 0.0)
         continue;
      double per = (Fut.Last() - brate)/brate*100.0;
      double per_in_year = per/days*365;
      Panel.SetLine(i, Fut.Name() + " " + DoubleToString(days, 0) + " Days:", DoubleToString(per_in_year, 2)+"%");
   }
  }
//+------------------------------------------------------------------+
//| Returns the spot quote of the futures                            |
//+------------------------------------------------------------------+
double CIntRate::BaseRate(CSymbol* fut)
{
   string name = fut.NameBasisSymbol();
   if(StringFind(name, "Si", 0) == 0)
      return SymbolInfoDouble("USDRUB_TOD", SYMBOL_LAST)*fut.ContractSize();
   return SymbolInfoDouble(name, SYMBOL_LAST)*fut.ContractSize();
}
//+------------------------------------------------------------------+
