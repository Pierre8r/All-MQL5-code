//+------------------------------------------------------------------+
//|                                                UsingTrailing.mqh |
//|                                 Copyright 2017, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include <Math\AlgLib\alglib.mqh>
#include <Math\AlgLib\dataanalysis.mqh>
#include <Arrays\ArrayObj.mqh>
#include "TimeSeries.mqh"

//+------------------------------------------------------------------+
//| Correlation type                                                 |
//+------------------------------------------------------------------+
enum ENUM_CORR_TYPE
  {
   CORR_PEARSON,     // Pearson's correlation
   CORR_SPEARMAN     // Spearman's Rank-Order correlation
  };
//+------------------------------------------------------------------+
//| Returns the R^2 estimate based on the strategy balance           |
//+------------------------------------------------------------------+
double CustomR2Balance(ENUM_CORR_TYPE corr_type = CORR_PEARSON)
{
   HistorySelect(0, TimeCurrent());
   double deals_equity[];
   double sum_profit = 0.0;
   int current = 0;
   int total = HistoryDealsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong ticket = HistoryDealGetTicket(i);
      double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
      double swap = HistoryDealGetDouble(ticket, DEAL_SWAP);
      if(profit == 0.0 && swap == 0.0)
         continue;
      if(ArraySize(deals_equity) <= current)
         ArrayResize(deals_equity, current+16);
      sum_profit += profit + swap;
      deals_equity[current] = sum_profit;
      current++;
   }
   ArrayResize(deals_equity, current);
   return CustomR2Equity(deals_equity, corr_type);
}
//+------------------------------------------------------------------+
//| Returns the R^2 estimate based on the strategy equity            |
//| The values of equity are passed as the 'equity' array            |
//+------------------------------------------------------------------+
double CustomR2Equity(double& equity[], ENUM_CORR_TYPE corr_type = CORR_PEARSON)
{
   int total = ArraySize(equity);
   if(total == 0)
      return 0.0;
   //-- Fill the matrix: Y - equity value, X - ordinal number of the value
   CMatrixDouble xy(total, 2);
   for(int i = 0; i < total; i++)
   {
      xy[i].Set(0, i);
      xy[i].Set(1, equity[i]);
   }
   //-- Find coefficients a and b of the linear model y = a*x + b;
   int retcode = 0;
   double a, b;
   CLinReg::LRLine(xy, total, retcode, a, b);
   //-- Generate the linear regression values for each X;
   double estimate[];
   ArrayResize(estimate, total);
   for(int x = 0; x < total; x++)
      estimate[x] = x*a+b;
   //-- Find the coefficient of correlation of values with their linear regression
   double corr = 0.0;
   if(corr_type == CORR_PEARSON)
      corr = CAlglib::PearsonCorr2(equity, estimate);
   else
      corr = CAlglib::SpearmanCorr2(equity, estimate);
   //-- Find R^2 and its sign
   double r2 = MathPow(corr, 2.0);
   int sign = 1;
   if(equity[0] > equity[total-1])
      sign = -1;
   r2 *= sign;
   //-- Return the R^2 estimate normalized to within hundredths
   return NormalizeDouble(r2,2);
}

