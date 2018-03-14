//+------------------------------------------------------------------+
//|                                             CTrade_Sample_EA.mq5 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include<Trade\Trade.mqh>
#property description "This Expert Advisor shows some examples of working  "
#property description "with CTrade class. Its functions are not called."

//--- object for performing trade operations
CTrade  trade;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- set MagicNumber for your orders identification
   int MagicNumber=123456;
   trade.SetExpertMagicNumber(MagicNumber);
//--- set available slippage in points when buying/selling
   int deviation=10;
   trade.SetDeviationInPoints(deviation);
//--- order execution mode
   trade.SetTypeFilling(ORDER_FILLING_RETURN);
//--- logging mode: it would be better not to declare this method at all, the class will set the best mode on its own
   trade.LogLevel(1);
//--- what function is to be used for trading: true - OrderSendAsync(), false - OrderSend()
   trade.SetAsyncMode(true);
//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- 

  }
//--- Buy sample  
//+------------------------------------------------------------------+
//|  Buying a specified volume at the current symbol                 |
//+------------------------------------------------------------------+
void BuySample1()
  {
//--- 1. example of buying at the current symbol
   if(!trade.Buy(0.1))
     {
      //--- failure message
      Print("Buy() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("Buy() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---
  }
//+------------------------------------------------------------------+
//|  Buying with specified volume and symbol                         |
//+------------------------------------------------------------------+
void BuySample2()
  {
//--- 2. example of buying at the specified symbol
   if(!trade.Buy(0.1,"GBPUSD"))
     {
      //--- failure message
      Print("Buy() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("Buy() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---
  }
//+------------------------------------------------------------------+
//|  Buying with specifying all order parameters                     |
//+------------------------------------------------------------------+
void BuySample3()
  {
//--- 3. example of buying at the specified symbol with specified SL and TP
   double volume=0.1;         // specify a trade operation volume
   string symbol="GBPUSD";    //specify the symbol, for which the operation is performed
   int    digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS); // number of decimal places
   double point=SymbolInfoDouble(symbol,SYMBOL_POINT);         // point
   double bid=SymbolInfoDouble(symbol,SYMBOL_BID);             // current price for closing LONG
   double SL=bid-1000*point;                                   // unnormalized SL value
   SL=NormalizeDouble(SL,digits);                              // normalizing Stop Loss
   double TP=bid+1000*point;                                   // unnormalized TP value
   TP=NormalizeDouble(TP,digits);                              // normalizing Take Profit
//--- receive the current open price for LONG positions
   double open_price=SymbolInfoDouble(symbol,SYMBOL_ASK);
   string comment=StringFormat("Buy %s %G lots at %s, SL=%s TP=%s",
                               symbol,volume,
                               DoubleToString(open_price,digits),
                               DoubleToString(SL,digits),
                               DoubleToString(TP,digits));
   if(!trade.Buy(volume,symbol,open_price,SL,TP,comment))
     {
      //--- failure message
      Print("Buy() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("Buy() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---
  }
//--- Examples for placing a limit order  
//+------------------------------------------------------------------+
//| Placing a limit order at the current symbol                      |
//+------------------------------------------------------------------+
void BuyLimit_Sample1()
  {
//--- 1. example of placing a Buy Limit pending order
   string symbol="GBPUSD";    // specify the symbol, at which the order is placed
   int    digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS); // number of decimal places
   double point=SymbolInfoDouble(symbol,SYMBOL_POINT);         // point
   double ask=SymbolInfoDouble(symbol,SYMBOL_ASK);             // current buy price
   double price=1000*point;                                    // unnormalized open price
   price=NormalizeDouble(price,digits);                        // normalizing open price
//--- everything is ready, sending a Buy Limit pending order to the server
   if(!trade.BuyLimit(0.1,price))
     {
      //--- failure message
      Print("BuyLimit() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("BuyLimit() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---
  }
//+------------------------------------------------------------------+
//| Placing a limit order specifying all the parameters              |
//+------------------------------------------------------------------+
void BuyLimit_Sample2()
  {
//--- 2. example of placing a Buy Limit pending order with all parameters
   double volume=0.1;
   string symbol="GBPUSD";    // specify the symbol, at which the order is placed
   int    digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS); // number of decimal places
   double point=SymbolInfoDouble(symbol,SYMBOL_POINT);         // point
   double ask=SymbolInfoDouble(symbol,SYMBOL_ASK);             // current buy price
   double price=1000*point;                                    // unnormalized open price
   price=NormalizeDouble(price,digits);                        // normalizing open price
   int SL_pips=300;                                            // Stop Loss in points
   int TP_pips=500;                                            // Take Profit in points
   double SL=price-SL_pips*point;                              // unnormalized SL value
   SL=NormalizeDouble(SL,digits);                              // normalizing Stop Loss
   double TP=price+TP_pips*point;                              // unnormalized TP value
   TP=NormalizeDouble(TP,digits);                              // normalizing Take Profit
   datetime expiration=TimeTradeServer()+PeriodSeconds(PERIOD_D1);
   string comment=StringFormat("Buy Limit %s %G lots at %s, SL=%s TP=%s",
                               symbol,volume,
                               DoubleToString(price,digits),
                               DoubleToString(SL,digits),
                               DoubleToString(TP,digits));
//--- everything is ready, sending a Buy Limit pending order to the server
   if(!trade.BuyLimit(volume,price,symbol,SL,TP,ORDER_TIME_GTC,expiration,comment))
     {
      //--- failure message
      Print("BuyLimit() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("BuyLimit() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---   
  }
//--- Examples for placing a stop order    
//+------------------------------------------------------------------+
//| Placing a stop order at the current symbol                       |
//+------------------------------------------------------------------+
void BuyStop_Sample1()
  {
//--- 1. example of placing a Buy Stop pending order
   string symbol="USDJPY";    // specify the symbol, at which the order is placed
   int    digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS); // number of decimal places
   double point=SymbolInfoDouble(symbol,SYMBOL_POINT);         // point
   double ask=SymbolInfoDouble(symbol,SYMBOL_ASK);             // current buy price
   double price=1000*point;                                    // unnormalized open price
   price=NormalizeDouble(price,digits);                        // normalizing open price
//--- everything is ready, sending a Buy Stop pending order to the server 
   if(!trade.BuyStop(0.1,price))
     {
      //--- failure message
      Print("BuyStop() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("BuyStop() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---  
  }
//+------------------------------------------------------------------+
//| Placing a stop order specifying all the parameters               |
//+------------------------------------------------------------------+
void BuyStop_Sample2()
  {
//--- 2. example of placing a Buy Stop pending order with all parameters
   double volume=0.1;
   string symbol="USDJPY";    // specify the symbol, at which the order is placed
   int    digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS); // number of decimal places
   double point=SymbolInfoDouble(symbol,SYMBOL_POINT);         // point
   double ask=SymbolInfoDouble(symbol,SYMBOL_ASK);             // current buy price
   double price=1000*point;                                    // unnormalized open price
   price=NormalizeDouble(price,digits);                        // normalizing open price
   int SL_pips=300;                                            // Stop Loss in points
   int TP_pips=500;                                            // Take Profit in points
   double SL=price-SL_pips*point;                              // unnormalized SL value
   SL=NormalizeDouble(SL,digits);                              // normalizing Stop Loss
   double TP=price+TP_pips*point;                              // unnormalized TP value
   TP=NormalizeDouble(TP,digits);                              // normalizing Take Profit
   datetime expiration=TimeTradeServer()+PeriodSeconds(PERIOD_D1);
   string comment=StringFormat("Buy Stop %s %G lots at %s, SL=%s TP=%s",
                               symbol,volume,
                               DoubleToString(price,digits),
                               DoubleToString(SL,digits),
                               DoubleToString(TP,digits));
//--- everything is ready, sending a Buy Stop pending order to the server 
   if(!trade.BuyStop(volume,price,symbol,SL,TP,ORDER_TIME_GTC,expiration,comment))
     {
      //--- failure message
      Print("BuyStop() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("BuyStop() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---     
  }
//--- Examples for working with positions
//+------------------------------------------------------------------+
//|  Position opening                                                |
//+------------------------------------------------------------------+
void Open()
  {
//--- number of decimal places
   int    digits=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
//--- point value
   double point=SymbolInfoDouble(_Symbol,SYMBOL_POINT);
//--- receiving a buy price
   double price=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
//--- calculate and normalize SL and TP levels
   double SL=NormalizeDouble(price-1000*point,digits);
   double TP=NormalizeDouble(price+1000*point,digits);
//--- filling comments
   string comment="Buy "+_Symbol+" 0.1 at "+DoubleToString(price,digits);
//--- everything is ready, trying to open a buy position
   if(!trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,0.1,price,SL,TP,comment))
     {
      //--- failure message
      Print("PositionOpen() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("PositionOpen() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---
  }
//+------------------------------------------------------------------+
//| Closing a position specifying only a symbol                      |
//+------------------------------------------------------------------+
void Close()
  {
//--- closing a position at the current symbol
   if(!trade.PositionClose(_Symbol))
     {
      //--- failure message
      Print("PositionClose() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("PositionClose() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---     
  }
//+------------------------------------------------------------------+
//|  Modification for Long position of StopLoss and TakeProfit levels|
//+------------------------------------------------------------------+
void ModifyPosition()
  {
//--- number of decimal places
   int    digits=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
//--- point value
   double point=SymbolInfoDouble(_Symbol,SYMBOL_POINT);
//--- receiving the current Bid price
   double price=SymbolInfoDouble(_Symbol,SYMBOL_BID);
//--- calculate and normalize SL and TP levels
   double SL=NormalizeDouble(price-1000*point,digits);
   double TP=NormalizeDouble(price+1000*point,digits);
//--- everything is ready, trying to modify the buy position
   if(!trade.PositionModify(_Symbol,SL,TP))
     {
      //--- failure message
      Print("Метод PositionModify() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("PositionModify() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---     
  }
//--- Examples for working with orders
//+------------------------------------------------------------------+
//|  Deleting an order by its ticket                                 |
//+------------------------------------------------------------------+
void DeleteOrder()
  {
//--- this is a sample order ticket, it should be received
   ulong ticket=1234556;
//--- everything is ready, trying to modify the buy position
   if(!trade.OrderDelete(ticket))
     {
      //--- failure message
      Print("OrderDelete() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("OrderDelete() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---     
  }
//+------------------------------------------------------------------+
//|  Modifying a pending order                                       |
//+------------------------------------------------------------------+
void ModifyOrder()
  {
//--- this is a sample order ticket, it should be received
   ulong ticket=1234556;
//--- this is a sample symbol, it should be received
   string symbol="EURUSD";
//--- number of decimal places
   int    digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
//--- point value
   double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
//--- receiving a buy price
   double price=SymbolInfoDouble(symbol,SYMBOL_ASK);
//--- calculate and normalize SL and TP levels
//--- they should be calculated based on the order type
   double SL=NormalizeDouble(price-1000*point,digits);
   double TP=NormalizeDouble(price+1000*point,digits);
   //--- setting one day as a lifetime
   datetime expiration=TimeTradeServer()+PeriodSeconds(PERIOD_D1);   
//--- everything is ready, trying to modify the order 
   if(!trade.OrderModify(ticket,price,SL,TP,ORDER_TIME_GTC,expiration))
     {
      //--- failure message
      Print("OrderModify() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("OrderModify() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
//---
  }

//+------------------------------------------------------------------+
