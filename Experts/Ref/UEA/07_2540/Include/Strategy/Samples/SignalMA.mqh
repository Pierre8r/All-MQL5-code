//+------------------------------------------------------------------+
//|                                                EventListener.mqh |
//|           Copyright 2016, Vasiliy Sokolov, St-Petersburg, Russia |
//|                                https://www.mql5.com/en/users/c-4 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vasiliy Sokolov."
#property link      "https://www.mql5.com/en/users/c-4"
#include <Strategy\Strategy.mqh>
#include <Expert\Signal\SignalMACD.mqh>
#include <Expert\Signal\SignalMA.mqh>
//+------------------------------------------------------------------+
//| Strategy receives events and displays in terminal.               |
//+------------------------------------------------------------------+
class CStrategyMACD : public CStrategy
{
private:
   CSignalMACD       m_signal_ma;
   CiOpen            m_open;
   CiHigh            m_high;
   CiLow             m_low;
   CiClose           m_close;
   CIndicators       m_indicators;
public:
                     CStrategyMACD(void);
   //virtual void    InitBuy(const MarketEvent &event);
   //virtual void    SupportBuy(const MarketEvent &event, CPosition* pos);
   virtual void      InitSell(const MarketEvent &event);
   virtual void      SupportSell(const MarketEvent &event, CPosition* pos);
};
//+------------------------------------------------------------------+
//| Initialization of the CSignalMacd signal module                  |
//+------------------------------------------------------------------+
CStrategyMACD::CStrategyMACD(void)
{
   m_signal_ma.Pattern_0(0);
   m_signal_ma.Pattern_1(0);
   m_signal_ma.Pattern_2(0);
   m_signal_ma.Pattern_3(100);
   m_signal_ma.Pattern_4(0);
   m_signal_ma.Pattern_5(0);
   CSymbolInfo* info = new CSymbolInfo();                // Creating an object that represents the trading symbol of the strategy
   info.Name(Symbol());                                  // Initializing the object that represents the trading symbol of the strategy
   m_signal_ma.Init(info, Period(), 10);                 // Initializing the signal module by the trading symbol and timeframe
   m_signal_ma.InitIndicators(GetPointer(m_indicators)); // Creating required indicators in the signal module based on the empty list of indicators m_indicators
   m_signal_ma.EveryTick(true);                          // Testing mode
   m_signal_ma.Magic(ExpertMagic());                     // Magic number
   m_signal_ma.PatternsUsage(8);                         // Pattern mask
   m_open.Create(Symbol(), Period());                    // Initializing the timeseries of Open prices
   m_high.Create(Symbol(), Period());                    // Initializing the timeseries of High prices
   m_low.Create(Symbol(), Period());                     // Initializing the timeseries of Low prices
   m_close.Create(Symbol(), Period());                   // Initializing the timeseries of Close prices
   m_signal_ma.SetPriceSeries(GetPointer(m_open),        // Initializing the signal module by timeseries objects
                              GetPointer(m_high),
                              GetPointer(m_low),
                              GetPointer(m_close));
                              
}
//+------------------------------------------------------------------+
//| Buying.                                                          |
//+------------------------------------------------------------------+
void CStrategyMACD::InitSell(const MarketEvent &event)
{
   //if(event.type != MARKET_EVENT_BAR_OPEN)
   //   return;
   m_indicators.Refresh();
   m_signal_ma.SetDirection();
   //m_signal_ma
   int power_sell = m_signal_ma.ShortCondition();
   int power_buy = m_signal_ma.LongCondition();
   m_signal_ma.CheckCloseLong();
   printf("PowerSell: " + (string)power_sell + " PowerBuy: " + (string)power_buy);
}
//+------------------------------------------------------------------+
//| Selling.                                                         |
//+------------------------------------------------------------------+
void CStrategyMACD::SupportSell(const MarketEvent& event, CPosition* pos)
{
   ;
}
//+------------------------------------------------------------------+
