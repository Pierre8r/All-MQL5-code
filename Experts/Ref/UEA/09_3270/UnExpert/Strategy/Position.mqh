//+------------------------------------------------------------------+
//|                                                     Position.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include <Object.mqh>
#include "Message.mqh"
#include "Logs.mqh"
#include "Trailings\Trailing.mqh"
//+------------------------------------------------------------------+
//| Active position class for classical strategies                   |
//+------------------------------------------------------------------+
class CPosition : public CObject
{
private:
   ulong                m_id;                // Unique position identifier
   uint                 m_magic;             // Unique ID of the EA the position belongs to.
   ENUM_POSITION_TYPE   m_direction;         // Position direction
   double               m_entry_price;       // Position entry price
   string               m_symbol;            // The symbol the position is open for
   datetime             m_time_open;         // Open time
   string               m_entry_comment;     // Incoming comment
   bool                 m_is_closed;         // True if the position has been closed
   CLog*                Log;                 // Logging
public:
                        CPosition(void);
   bool                 IsActive();
   uint                 ExpertMagic(void);
   ulong                ID(void);
   ENUM_POSITION_TYPE   Direction(void);
   double               EntryPrice(void);
   string               EntryComment(void);
   double               Profit(void);
   double               ProfitInPips(void);
   double               Volume(void);
   string               Symbol(void);
   datetime             TimeOpen(void);
   bool                 CloseAtMarket(string comment="");
   bool                 CloseAtMarket(double volume, ulong deviation, string comment);
   bool                 CloseAtMarket(double volume, ulong deviation, string comment, bool asynch = false);
   double               StopLossValue(void);
   bool                 StopLossValue(double sl);
   double               StopLossPercent(void);
   bool                 StopLossPercent(double sl);
   double               TakeProfitValue(void);
   bool                 TakeProfitValue(double tp);
   double               TakeProfitPercent(void);
   bool                 TakeProfitPercent(double tp);
   bool                 IsComplex(void);
   bool                 CheckStopLevel(double stoplevel);
   CTrailing*           Trailing;
   CObject*             ExpertData;
};
      
CPosition::CPosition(void) : m_id(0),
                             m_entry_price(0.0),
                             m_symbol(""),
                             m_time_open(0)
{
   Log = CLog::GetLog();
#ifdef __MQL5__
   #ifdef __HT__
      m_id = HedgePositionGetInteger(HEDGE_POSITION_ID);
      m_magic = (uint)HedgePositionGetInteger(HEDGE_POSITION_MAGIC);
      ENUM_DIRECTION_TYPE type = (ENUM_DIRECTION_TYPE)HedgePositionGetInteger(HEDGE_POSITION_DIRECTION);
      m_direction = type == DIRECTION_LONG ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
      m_entry_price = HedgePositionGetDouble(HEDGE_POSITION_PRICE_OPEN);
      m_symbol = HedgePositionGetString(HEDGE_POSITION_SYMBOL);
      m_time_open = (datetime)HedgePositionGetInteger(HEDGE_POSITION_ENTRY_TIME_EXECUTED_MSC)/1000;
      m_entry_comment = HedgePositionGetString(HEDGE_POSITION_ENTRY_COMMENT);
   #else
      m_id = PositionGetInteger(POSITION_IDENTIFIER);
      m_maigic = (uint)PositionGetInteger(POSITION_MAGIC);
      m_direction = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      m_entry_price = PositionGetDouble(POSITION_PRICE_OPEN);
      m_symbol = PositionGetString(POSITION_SYMBOL);
      m_time_open = (datetime)PositionGetInteger(POSITION_TIME);
      m_entry_comment = PositionGetString(POSITION_COMMENT);
   #endif
#else
   #ifdef __MQL4__
      m_id = OrderTicket();
      m_magic = OrderMagic();
      if(OrderType() == ORDER_TYPE_BUY)
         m_direction = POSITION_TYPE_BUY;
      else
         m_direction = POSITION_TYPE_SELL;
      m_entry_price = OrderOpenPrice();
      m_profit = OrderProfit();
      m_volume = OrderLots();
      m_symbol = OrderSymbol();
      m_time_open = OrderOpenTime();
      m_sl = OrderStopLoss();
      m_tp = OrderTakeProfit();
      m_entry_comment = OrderComment();
   #endif
#endif
}
//+------------------------------------------------------------------+
//| Returns true if the position is active.          Returns false   |
//| if otherwise.                                                    |
//+------------------------------------------------------------------+
bool CPosition::IsActive(void)
{
   return m_time_open > 0 && !m_is_closed;
}

//+------------------------------------------------------------------+
//| Returns position direction.                                      |
//+------------------------------------------------------------------+
ENUM_POSITION_TYPE CPosition::Direction(void)
{
   return m_direction;
}
//+------------------------------------------------------------------+
//| Returns the unique ID of the Expert Advisor                      |
//| the position belongs to.                                     |
//+------------------------------------------------------------------+
uint CPosition::ExpertMagic(void)
{
   return m_magic;
}
//+------------------------------------------------------------------+
//| Returns the unique position identifier.                          |
//+------------------------------------------------------------------+
ulong CPosition::ID(void)
{
   return m_id;
}
//+------------------------------------------------------------------+
//| Returns position entry price.                                    |
//+------------------------------------------------------------------+
double CPosition::EntryPrice(void)
{
   return m_entry_price;
}
//+------------------------------------------------------------------+
//| Returns incoming comment of the active position.                 |
//+------------------------------------------------------------------+
string CPosition::EntryComment(void)
{
   return m_entry_comment;
}
//+------------------------------------------------------------------+
//| Returns the name of the symbol for which there is currently open |
//| position                                                         |
//+------------------------------------------------------------------+
string CPosition::Symbol(void)
{
   return m_symbol;
}
//+------------------------------------------------------------------+
//| Returns position open time.                                      |
//+------------------------------------------------------------------+
datetime CPosition::TimeOpen(void)
{
   return m_time_open;
}
//+------------------------------------------------------------------+
//| Returns true if the current position is a part of the            |
//| complex, market-neutral position. It returns                     |
//| false otherwise .                                                |
//+------------------------------------------------------------------+
bool CPosition::IsComplex(void)
{
   string comm = EntryComment();
   string cp = StringSubstr(comm, 0, 3);
   if(cp != "CP[")return false;
   cp = StringSubstr(comm, StringLen(comm)-1, 1);
   if(cp != "]")return false;
   return true;
}
//+------------------------------------------------------------------+
//| Returns an absolute Stop Loss level for the current position.    |
//| If the Stop Loss level is not set, returns 0.0                   |
//+------------------------------------------------------------------+
double CPosition::StopLossValue(void)
{
   double value = 0.0;
   ulong id = ID();
   #ifdef __HT__
   if(!TransactionSelect(ID(), SELECT_BY_TICKET, MODE_TRADES))
   {
      string text = "Position #" + (string)ID() + " not find. Get StopLoss failed.";
      CMessage* msg_err = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg_err);
   }
   value = HedgePositionGetDouble(HEDGE_POSITION_SL);
   #endif
   return value;
}
//+------------------------------------------------------------------+
//| Sets an absolute stop loss level                                 |
//+------------------------------------------------------------------+
bool CPosition::StopLossValue(double sl)
{
   #ifdef __HT__
   if(!TransactionSelect(ID(), SELECT_BY_TICKET, MODE_TRADES))
   {
      string text = "Position #" + (string)ID() + " not find. Set StopLoss failed.";
      CMessage* msg_err = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg_err);
      return false;
   }
   double tp = HedgePositionGetDouble(HEDGE_POSITION_TP);
   HedgeTradeRequest request;
   request.action = REQUEST_MODIFY_SLTP;
   request.sl = sl;
   request.tp = tp;
   bool res = SendTradeRequest(request);
   if(res)
   {
      string text = "Position #" + (string)ID() + ": Set new S/L successfully at " + DoubleToString(sl);
      CMessage* msg_info = new CMessage(MESSAGE_INFO, __FUNCTION__, text);
      Log.AddMessage(msg_info);
   }
   else
   {
      string err = EnumToString(GetHedgeError());
      string text = "Position #" + (string)ID() + ": Set new S/L failed. Reason: " + err;
      CMessage* msg_err = new CMessage(MESSAGE_INFO, __FUNCTION__, text);
      Log.AddMessage(msg_err);
   }
   return res;
   #endif
}
//+------------------------------------------------------------------+
//| Returns an absolute Take Profit level for the current position.  |
//| If the Take Profit level is not set, returns 0.0                 |
//+------------------------------------------------------------------+
double CPosition::TakeProfitValue(void)
{
   double value = 0.0;
   #ifdef __HT__
   if(!TransactionSelect(ID(), SELECT_BY_TICKET, MODE_TRADES))
   {
      string text = "Position #" + (string)ID() + " not find. Get TakeProfit failed.";
      CMessage* msg_err = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg_err);
   }
   value = HedgePositionGetDouble(HEDGE_POSITION_TP);
   #endif
   return value;
}
//+------------------------------------------------------------------+
//| Sets an absolute take profit level                               |
//+------------------------------------------------------------------+
bool CPosition::TakeProfitValue(double tp)
{
   #ifdef __HT__
   if(!TransactionSelect(ID(), SELECT_BY_TICKET, MODE_TRADES))
   {
      string text = "Position #" + (string)ID() + " not find. Set TakeProfit failed.";
      CMessage* msg_err = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg_err);
      return false;
   }
   double sl = HedgePositionGetDouble(HEDGE_POSITION_SL);
   HedgeTradeRequest request;
   request.action = REQUEST_MODIFY_SLTP;
   request.sl = sl;
   request.tp = tp;
   bool res = SendTradeRequest(request);
   if(res)
   {
      string text = "Position #" + (string)ID() + ": Set new T/P successfully at " + DoubleToString(tp);
      CMessage* msg_info = new CMessage(MESSAGE_INFO, __FUNCTION__, text);
      Log.AddMessage(msg_info);
   }
   else
   {
      string err = EnumToString(GetHedgeError());
      string text = "Position #" + (string)ID() + ": Set new T/P failed. Reason: " + err;
      CMessage* msg_err = new CMessage(MESSAGE_INFO, __FUNCTION__, text);
      Log.AddMessage(msg_err);
   }
   return res;
   #endif
}
//+------------------------------------------------------------------+
//| Sets stop loss as a percentage of the current price.             |
//| PARAMETERS:                                                      |
//|     sl_percent - level as percent from position entry price,     |
//|                  e.g. sl_percent=3.2 = 3,2% from entry price.    |
//+------------------------------------------------------------------+
bool CPosition::StopLossPercent(double sl_percent)
{
   if(sl_percent < 0.0 || sl_percent > 100.0)
   {
      string text = "Position #" + (string)ID() + ": Set S/L must be greater than 0.0 and less than 100 %";
      CMessage* msg = new CMessage(MESSAGE_WARNING, __FUNCTION__, text);
      Log.AddMessage(msg);
      return false;
   }
   double delta = EntryPrice()*sl_percent/100.0;
   double sl = 0.0;
   if(Direction() == POSITION_TYPE_BUY)
      sl = EntryPrice() - delta;
   else
      sl = EntryPrice() + delta;
   return StopLossValue(sl);
}
//+------------------------------------------------------------------+
//| Sets take profit as a percentage of the current price.           |
//| PARAMETERS:                                                      |
//|     tp_percent - level as percent from position entry price,     |
//|                  e.g. tp_percent=3.2 = 3,2% from entry price.    |
//+------------------------------------------------------------------+
bool CPosition::TakeProfitPercent(double tp_percent)
{
   if(tp_percent < 0.0 || tp_percent > 100.0)
   {
      string text = "Position #" + (string)ID() + ": Set T/P must be greater than 0.0 and less than 100 %";
      CMessage* msg = new CMessage(MESSAGE_WARNING, __FUNCTION__, text);
      Log.AddMessage(msg);
      return false;
   }
   double delta = EntryPrice()*tp_percent/100.0;
   double tp = 0.0;
   if(Direction() == POSITION_TYPE_BUY)
      tp = EntryPrice() + delta;
   else
      tp = EntryPrice() - delta;
   return TakeProfitValue(tp);
}
//+------------------------------------------------------------------+
//| Closes the current position by market and sets a closing         |
//| comment equal to 'comment'                                       |
//+------------------------------------------------------------------+
bool CPosition::CloseAtMarket(string comment = "")
{
   return CloseAtMarket(Volume(), 0, comment, false);
}
//+------------------------------------------------------------------+
//| Closes the current position by market and sets a closing         |
//| comment, volume and maximum price deviation.                     |
//+------------------------------------------------------------------+
bool CPosition::CloseAtMarket(double volume, ulong deviation, string comment="")
{
   return CloseAtMarket(Volume(), 0, comment, false);
}
//+------------------------------------------------------------------+
//| Closes current position by market.                               |
//| Parameters:                                                      |
//| volume - the volume that should be closed. Can be equal to or    |
//|       less than current position volume.                         |
//| deviation - max price deviation in price steps.                  |
//| comment - closing comment.                                       |
//| Return value: True of position is closed successfully            |
//| false if otherwise.                                              |
//+------------------------------------------------------------------+
bool CPosition::CloseAtMarket(double volume, ulong deviation, string comment="", bool asynch=false)
{
   #ifdef __HT__
   if(!TransactionSelect(ID(), SELECT_BY_TICKET, MODE_TRADES))
   {
      string text = "Position #" + (string)ID()+ "(ExpertMagic = "+ (string)ExpertMagic() + ") not find. Close at market failed.";
      CMessage* msg_err = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg_err);
      return false;
   }
   HedgeTradeRequest request;
   request.action = REQUEST_CLOSE_POSITION;
   request.volume = volume;
   request.exit_comment = comment;
   request.deviation = deviation;
   request.asynch_mode = asynch;
   bool res = SendTradeRequest(request);
   if(res)
   {
      string text = "Position #" + (string)ID()+ "(ExpertMagic = "+ (string)ExpertMagic() + ") was successfully closed";
      CMessage* msg = new CMessage(MESSAGE_INFO, __FUNCTION__, text);
      Log.AddMessage(msg);
   }
   else
   {
      string text = "Position #" + (string)ID()+ "(ExpertMagic = "+ (string)ExpertMagic() + ") closed failed. Reason: " + EnumToString(GetHedgeError());
      CMessage* msg = new CMessage(MESSAGE_WARNING, __FUNCTION__, text);
      Log.AddMessage(msg);
   }
   m_is_closed = res;
   return res;
   #endif
   return false;
}

//+------------------------------------------------------------------+
//| Returns current position volume.                                 |
//+------------------------------------------------------------------+
double CPosition::Volume(void)
{
   #ifdef __HT__
   if(!TransactionSelect(ID(), SELECT_BY_TICKET, MODE_TRADES))
   {
      string text = "Position #" + (string)ID()+ "(ExpertMagic = "+ (string)ExpertMagic() + ") not find. Get volume failed.";
      CMessage* msg_err = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg_err);
      return 0.0;
   }
   double vol = HedgePositionGetDouble(HEDGE_POSITION_VOLUME);
   return vol;
   #endif
}
//+------------------------------------------------------------------+
//| Returns current profit of position in deposit currency.            |
//+------------------------------------------------------------------+
double CPosition::Profit(void)
{
   #ifdef __HT__
   if(!TransactionSelect(ID(), SELECT_BY_TICKET, MODE_TRADES))
   {
      string text = "Position #" + (string)ID()+ "(ExpertMagic = "+ (string)ExpertMagic() + ") not find. Get profit in currency failed.";
      CMessage* msg_err = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg_err);
      return 0.0;
   }
   double profit = HedgePositionGetDouble(HEDGE_POSITION_PROFIT_CURRENCY);
   return profit;
   #endif
}
//+------------------------------------------------------------------+
//| Returns the current profit in the symbol points.                 |
//+------------------------------------------------------------------+
double CPosition::ProfitInPips(void)
{
   #ifdef __HT__
   if(!TransactionSelect(ID(), SELECT_BY_TICKET, MODE_TRADES))
   {
      string text = "Position #" + (string)ID()+ "(ExpertMagic = "+ (string)ExpertMagic() + ") not find. Get profit in pips failed.";
      CMessage* msg_err = new CMessage(MESSAGE_ERROR, __FUNCTION__, text);
      Log.AddMessage(msg_err);
      return 0.0;
   }
   double profit = HedgePositionGetDouble(HEDGE_POSITION_PROFIT_POINTS);
   return profit;
   #endif
}

//+------------------------------------------------------------------+
//| Checks the correctness of the passed stoplevel. Returns          |
//| true if the SL level is correct and false in the opposite        |
//|                                                                  |
//+------------------------------------------------------------------+
bool CPosition::CheckStopLevel(double stoplevel)
{
   double last = 0.0;
   double max = SymbolInfoDouble(m_symbol, SYMBOL_SESSION_PRICE_LIMIT_MAX);
   double min = SymbolInfoDouble(m_symbol, SYMBOL_SESSION_PRICE_LIMIT_MIN);
   if(stoplevel >= max && max != 0.0)
      return false;
   if(stoplevel <= min)
      return false;
   if(m_direction == POSITION_TYPE_BUY)
   {
      if(stoplevel >= SymbolInfoDouble(m_symbol, SYMBOL_BID))
         return false;
      return true;
   }
   else
   {
      if(stoplevel <= SymbolInfoDouble(m_symbol, SYMBOL_ASK))
         return false;
   }
   return true;
}