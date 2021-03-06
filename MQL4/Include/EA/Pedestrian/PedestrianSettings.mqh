//+------------------------------------------------------------------+
//|                                           PedestrianSettings.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

sinput string PedestrianSettings1; // ####
sinput string PedestrianSettings2; // #### Signal Settings
sinput string PedestrianSettings3; // ####

input int BotPeriod=120; // Period for calculating exits.
input double BotMinimumTpSlDistance=3.0; // Tp/Sl minimum distance, in spreads.
input double BotSkew=0.18; // Skew sl/tp spread
input double BotAtrMultiplier=0.675; // Sl/tp spread width.
input int BotRangePeriod=12; // Range Period
input ENUM_TIMEFRAMES BotIntradayTimeframe=PERIOD_H1; // Intraday Timeframe
input int BotIntradayPeriod=14; // Intraday Period

#include <EA\PortfolioManagerBasedBot\BasicSettings.mqh>
//+------------------------------------------------------------------+
