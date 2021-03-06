//+------------------------------------------------------------------+
//|                                              ComplexPosition.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include <Object.mqh>
#include <Arrays\ArrayObj.mqh>
#include <Strategy\TradeControl.mqh>
#include <Strategy\Logs.mqh>
#include <Strategy\Message.mqh>
#include <Strategy\Position.mqh>
#include <Strategy\Target.mqh>
//+------------------------------------------------------------------+
//| Complex position for working with the statistical arbitrage.     |
//+------------------------------------------------------------------+
class CComplexPosition : public CObject
{
private:
   CArrayObj      m_targets;        // The list of tasks
   CArrayObj      m_positions;      // The list of open positions for the active position
   uint           m_magic;          // The EA magic number
   bool           m_correct;        // An indication of a correctly formed position.
   CTradeControl* m_trade;          // Trading module.
   datetime       m_time;           // Execution time
   CLog*          Log;              // Logging
   bool CheckSymbol(string symbol);
   bool CheckValid(void);
   bool Execute(string symbol, double volume, string ts);
   double Price(string symbol, double volume);
   string GetHash(void);
public:
   CComplexPosition(void);
   uint ExpertMagic(void);
   void ExpertMagic(uint magic);
   bool Execute(void);
   datetime ExecuteTime(void);
   bool AddTarget(string symbol, double volume);
   void Clear(void);
   double Price(void);
   bool IsActive(void);
   string EntryComment(void);
   bool AddPosition(CPosition* pos);
   CComplexPosition* Clone();
   bool EqualTargets(CComplexPosition* cp);
   bool IsCorrect(void);
   bool CloseAtMarket(void);
   double Profit(void);
   int PositionsTotal();
   CPosition* PositionAt(int);
};
//+------------------------------------------------------------------+
//| Creates a copy of current complex position containing a similar  |
//| set of targets. Active positions are not copied, because         |
//| there should be only one instance of them.                       |
//| I.e. a complex position returned by the method not always returns|
//| false when calling the IsActive method                           |
//+------------------------------------------------------------------+
CComplexPosition* CComplexPosition::Clone(void)
{
   CComplexPosition* cp = new CComplexPosition();
   for(int i = 0; i < m_targets.Total(); i++)
   {
      CTarget* ct = m_targets.At(i);
      cp.m_targets.Add(new CTarget(ct.Symbol(), ct.Volume()));
   }
   cp.m_magic = m_magic;
   cp.m_correct = m_correct;
   return cp;
}
//+------------------------------------------------------------------+
//| Default constructor.                                             |
//+------------------------------------------------------------------+
CComplexPosition::CComplexPosition(void) : m_magic(0),
                                           m_correct(true)
{
   Log = CLog::GetLog();
   m_trade.SetAsyncMode(true);
}
//+------------------------------------------------------------------+
//| Returns the unique ID of the Expert Advisor                      |
//| the current complex position belongs to.                         |
//+------------------------------------------------------------------+
uint CComplexPosition::ExpertMagic(void)
{
   return m_magic;
}
//+------------------------------------------------------------------+
//| Sets the unique ID of the Expert Advisor                         |
//| the current complex position belongs to.                         |
//+------------------------------------------------------------------+
void CComplexPosition::ExpertMagic(uint magic)
{
   m_magic = magic;
   m_trade.SetExpertMagicNumber(magic);
}
//+------------------------------------------------------------------+
//| Adds a new target to the scenario.                               |
//+------------------------------------------------------------------+
bool CComplexPosition::AddTarget(string symbol,double volume)
{
   if(m_correct == false)
   {
      string text = "With the formation of an integrated position error. Adding new characters is not possible." +
                    "Clean the position of its formation and try again.";
      CMessage* msg = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg);
      return m_correct;
   }
   if(!CheckSymbol(symbol))
   {
      string text = "Symbol " + symbol + " unavailable. Check correct symbol";
      CMessage* msg = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg);
      return m_correct = false;
   }
   m_correct = m_targets.Add(new CTarget(symbol, volume));
   return m_correct;
}
//+------------------------------------------------------------------+
//| Checks the correctness of the offered symbol.                    |
//+------------------------------------------------------------------+
bool CComplexPosition::CheckSymbol(string symbol)
{
   datetime times[];
   if(CopyTime(symbol, PERIOD_CURRENT, 0, 1, times) < 1)
      return false;
   return true;
}
//+------------------------------------------------------------------+
//| Clears position scenario.                                        |
//+------------------------------------------------------------------+
void CComplexPosition::Clear(void)
{
   if(IsActive())return;
   m_correct = true;
   m_time = 0;
   m_magic = 0;
   m_targets.Clear();
}
//+------------------------------------------------------------------+
//| Returns true if the scenario for the current position is         |
//|correct or false otherwise.                                       |
//+------------------------------------------------------------------+
bool CComplexPosition::IsCorrect(void)
{
   return m_correct;
}
//+------------------------------------------------------------------+
//| Asynchronously executes complex position.                        |
//+------------------------------------------------------------------+
bool CComplexPosition::Execute(void)
{
   if(!CheckValid())return false;
   m_trade.SetExpertMagicNumber(m_magic);
   m_trade.SetAsyncMode(true);
   string hash = GetHash();
   bool res = true;
   int total = m_targets.Total();
   for(int i = 0; i < total; i++)
   {
      CTarget* target = m_targets.At(i);
      if(!Execute(target.Symbol(), target.Volume(), hash))
         res = false;
   }
   m_time = TimeCurrent();
   return res;
}
//+------------------------------------------------------------------+
//| Asynchronously executes given volume of specified symbol.        |
//| Negative volume means Sell, positive volume means Buy            |
//+------------------------------------------------------------------+
bool CComplexPosition::Execute(string symbol, double volume, string ts)
{
   bool res = false;
   string op = volume > 0.0 ? "Buy" : "Sell";
   if(volume > 0.0)
      res = m_trade.Buy(volume, symbol, ts);
   else
      res = m_trade.Sell(MathAbs(volume), symbol, ts);
   if(!res)
   {
      string vol = DoubleToString(MathAbs(volume), 2);
      string text = op + " " + vol + " failed. Reason " + m_trade.ResultRetcodeDescription() + " (" + (string)m_trade.ResultRetcode()+ ")";
      CMessage* msg = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      msg.Retcode(m_trade.ResultRetcode());
      Log.AddMessage(msg);
   }
   return res;
}
//+------------------------------------------------------------------+
//| Checks the correctness of generated position before execution.   |
//+------------------------------------------------------------------+
bool CComplexPosition::CheckValid(void)
{
   bool res = true;
   if(m_magic == 0)
   {
      string text = "Magic number of complex position not set. Set magic and try again";
      CMessage* msg = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg);
      res = false;
   }
   if(!m_correct)
   {
      string text = "Position is not formed correctly. Execution is not possible";
      CMessage* msg = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg);
      res = false;
   }
   if(m_targets.Total() == 0)
   {
      string text = "Position has no targets. Add at least one target";
      CMessage* msg = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg);
      res = false;
   }
   return res;
}
//+------------------------------------------------------------------+
//| Forms a unique hash for the complex position.                    |
//+------------------------------------------------------------------+
string CComplexPosition::GetHash(void)
{
   uint time = (uint)TimeCurrent();
   uint msc = GetTickCount()%1000;
   string hash = "CP[" + (string)ExpertMagic() + ":" + (string)time + ":" + (string)msc + "]";
   return hash;
}
//+------------------------------------------------------------------+
//| Returns current price of the market neutral position Unlike      |
//| the usual position, the price of a market-neutral position can   |
//| be negative                                                      |
//+------------------------------------------------------------------+
double CComplexPosition::Price(void)
{
   double price = 0.0;
   for(int i = 0; i < m_targets.Total(); i++)
   {
      CTarget* target = m_targets.At(i);
      price += Price(target.Symbol(), target.Volume());
   }
   return price;
}
//+------------------------------------------------------------------+
//| Returns the weighted average price for the specified             |
//| symbol.                                                          |
//+------------------------------------------------------------------+
double CComplexPosition::Price(string symbol,double volume)
{
   double close[];
   double price = 0.0;
   if(volume > 0)
      price = SymbolInfoDouble(symbol, SYMBOL_ASK);
   else
      price = SymbolInfoDouble(symbol, SYMBOL_BID);
   price *= volume;
   return price;
}
//+------------------------------------------------------------------+
//| Returns true if the position is active.                          |
//| Otherwise it returns false.                                      |
//+------------------------------------------------------------------+
bool CComplexPosition::IsActive(void)
{
   return m_positions.Total() > 0;
}
//+------------------------------------------------------------------+
//| Returns the incoming hash comment of complex position.           |
//| Returns an empty string if the complex position is not active    |
//+------------------------------------------------------------------+
string CComplexPosition::EntryComment(void)
{
   if(m_positions.Total() == 0)
      return "";
   CPosition* pos = m_positions.At(0);
   return pos.EntryComment();
}
//+------------------------------------------------------------------+
//| Adds a new active position to the current complex position.      |
//+------------------------------------------------------------------+
bool CComplexPosition::AddPosition(CPosition *pos)
{
   if(m_positions.Total() > 0)
   {
      if(EntryComment() != pos.EntryComment())
      {
         string text = "The added position #" + (string)pos.ID() +
                       " is not compatible with the current comment complex position. Adding impossible.";
         CMessage* msg = new CMessage(MESSAGE_WARNING, __FUNCTION__, text);
         Log.AddMessage(msg);
         return false;
      }
      if(ExpertMagic() != pos.ExpertMagic())
      {
         string text = "The added position #" + (string)pos.ID() +
                       " is not compatible with the current expert number complex position. Adding impossible.";
         CMessage* msg = new CMessage(MESSAGE_WARNING, __FUNCTION__, text);
         Log.AddMessage(msg);
         return false;
      }
   }
   m_magic = pos.ExpertMagic();
   m_positions.Add(pos);
   double vol = pos.Volume();
   if(pos.Direction() == POSITION_TYPE_SELL)
      vol *= (-1);
   return m_targets.Add(new CTarget(pos.Symbol(), vol));
}
//+------------------------------------------------------------------+
//| Returns true if the scenario of the passed position is equal     |
//| current position scenario                                        |
//+------------------------------------------------------------------+
bool CComplexPosition::EqualTargets(CComplexPosition *cp)
{
   if(cp.m_targets.Total() != m_targets.Total())return false;
   for(int i = 0; i < m_targets.Total(); i++)
   {
      CTarget* me = m_targets.At(i);
      CTarget* tg = cp.m_targets.At(i);
      if(me != tg)return false;
   }
   return true;
}
//+------------------------------------------------------------------+
//| Returns the complex position execution time. If the position     |
//| is active, returns the time of the last executed                 |
//| position included in complex position.  If a position is         |
//| pending, but its execution started, returns saved time during    |
//| execution. If   position has not been executed yet, returns zero |
//+------------------------------------------------------------------+
datetime CComplexPosition::ExecuteTime(void)
{
   if(m_time == 0 && m_positions.Total() > 0)
   {
      CPosition* pos = m_positions.At(m_positions.Total()-1);
      return pos.TimeOpen();
   }
   return m_time;
}
//+------------------------------------------------------------------+
//| Closes the complex position by market.  Closure is performed     |
//| in asynchronous mode.                                            |
//+------------------------------------------------------------------+
bool CComplexPosition::CloseAtMarket(void)
{
   bool res = true;
   for(int i = 0; i < m_positions.Total(); i++)
   {
      CPosition* pos = m_positions.At(i);
      if(!pos.CloseAtMarket(pos.Volume(), 0, "exit from cp", true))
         res = false;
   }
   m_time = TimeCurrent();
   return res;
}
//+------------------------------------------------------------------+
//| Returns profit of the current complex position                   |
//+------------------------------------------------------------------+
double CComplexPosition::Profit(void)
{
   double profit = 0;
   for(int i = 0; i < m_positions.Total(); i++)
   {
      CPosition* pos = m_positions.At(i);
      profit += pos.Profit();
   }
   return profit;
}