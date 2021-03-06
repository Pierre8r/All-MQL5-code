//+------------------------------------------------------------------+
//|                                                UsingTrailing.mqh |
//|                                 Copyright 2016, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include "TrailingLibrary.mqh"
#define USE_TRAILING
input string TrailingStopWork = "VALUES OF TRAILING"; // -------- TRAILING-STOP SETTINGS --------
input bool  UseTrailing = false;                            // Trailing Enable      
input ENUM_TRAILING_TYPE TrailingType = TRAILING_CLASSIC;   // Type of Trailing

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

