//+------------------------------------------------------------------+
//|                                                  TradeDetect.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#include <Dictionary.mqh>
//+------------------------------------------------------------------+
//| Pending order.                                                   |
//+------------------------------------------------------------------+
class CPendingOrder : public CObject
  {
public:
                     CPendingOrder(void) : Price(0.0){;}
   double            Price;        // Trigger price
  };
//+------------------------------------------------------------------+
//| Trade environment module. Detects its change                     |
//| (number of historic/active orders and trades). Based on the      |
//| change in the trade environment, CStrategy defines the status of |
//| its trading operations. The class allows avoiding calls of       |
//| ambiguous OnTrade and OnTradeTransaction.                        |
//+------------------------------------------------------------------+
class CTradeEnvironment
  {
private:

   CDictionary       m_pending_orders;
   int               m_last_deals_count;           // Last remembered number of trades
   int               m_last_pending_orders;        // Last remembered number of pending orders
   int               m_last_historders_count;      // Last remembered number of historic orders
   bool              m_changed;                    // The flag indicates a change in the trading environment
   ulong             m_last_change_time;           // The time of the last change of the trading environment
   uint              m_last_access;                // The time of the last access to the history of trades.
   ulong             m_last_microseconds;          // The time of the last history change in microseconds since program start.
   bool              DetectPendingChanges();
   datetime          StartTimeTerminal(void);
public:
                     CTradeEnvironment(void);
   bool              ChangeEnvironment(void);
   void              RememberEnvironment(void);
   ulong             LastMicrosecondsState(void);
  };
//+------------------------------------------------------------------+
//| Default constructor.                                             |
//+------------------------------------------------------------------+
CTradeEnvironment::CTradeEnvironment(void) : m_changed(true)
  {
  }
//+------------------------------------------------------------------+
//| Returns true if the trading environment has changed              |
//+------------------------------------------------------------------+
bool CTradeEnvironment::ChangeEnvironment(void)
  {
   if(m_changed)return true;
   datetime dt=D'2115.01.01';
   HistorySelect(0,dt);
   if(HistoryDealsTotal()!=m_last_deals_count)
     {
      m_changed=true;
     }
   return m_changed;
  }
//+------------------------------------------------------------------+
//| Saves the current trading state                                  |
//+------------------------------------------------------------------+
void CTradeEnvironment::RememberEnvironment(void)
  {
   HistorySelect(0,D'2115.01.01');
   m_last_deals_count=HistoryDealsTotal();
   m_changed=false;
   m_last_microseconds=GetMicrosecondCount();
  }
//+------------------------------------------------------------------+
//| Returns the terminal start time.                                 |
//+------------------------------------------------------------------+
datetime CTradeEnvironment::StartTimeTerminal(void)
  {
   uint start_seconds=(uint)MathRound(GetMicrosecondCount()/1000000.0)+1;
   datetime time_begin=TimeCurrent()-start_seconds;
   return time_begin;
  }
//+------------------------------------------------------------------+
//| Returns the time of the last change of the trading state         |
//| in microseconds since program start.                             |
//+------------------------------------------------------------------+
ulong CTradeEnvironment::LastMicrosecondsState(void)
  {
   return m_last_microseconds;
  }
//+------------------------------------------------------------------+
