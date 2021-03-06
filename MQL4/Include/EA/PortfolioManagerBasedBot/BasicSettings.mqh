//+------------------------------------------------------------------+
//|                                                BasicSettings.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

sinput string PortfolioManagerSettings1; // ####
sinput string PortfolioManagerSettings2; // #### Portfolio Manager Settings
sinput string PortfolioManagerSettings3; // ####

input string WatchedSymbols="USDJPYpro,GBPUSDpro,USDCADpro,USDCHFpro,USDSEKpro"; // Currency Basket, csv list or blank for current chart.
input ENUM_TIMEFRAMES PortfolioTimeframe=PERIOD_CURRENT;
input double Lots=0.01; // Lots to trade.
input double RiskRewardFilter=1; // Filter RR. (reward / risk) 
input double ProfitTarget=25; // Profit target in account currency.
input double ProfitTargetSymbol=0; // Profit target per symbol in account currency.
input double ProfitTargetSymbolHedge=0; // Profit target per symbol per side (hedging) in account currency.
input double MaxLoss=25; // Maximum allowed loss in account currency.
input double MaxLossSymbol=0; // Maximum allowed loss per symbol in account currency.
input double MaxLossSymbolHedge=0; // Maximum allowed loss per symbol per side (hedging) in account currency.
input int Slippage=10; // Allowed slippage.
sinput string ScheduleManagerSettings1; // #### Schedule Settings
input ENUM_DAY_OF_WEEK Start_Day=0; // Start Day
input ENUM_DAY_OF_WEEK End_Day=6; // End Day
input string Start_Time="00:00"; // Start Time
input string End_Time="24:00"; // End Time
input bool ScheduleIsDaily=false; // Use start and stop times daily?
sinput string PositionManagerSettings1; // #### Position Entry and Exit Management
input bool TradeAtBarOpenOnly=false; // Trade only at opening of new bar?
input bool PinExits=true; // Disable signals from moving exits backward?
input bool SwitchDirectionBySignal=true; // Allow signal switching to close orders?
input int MaxOpenOrderCount=1; // Max Open Positions Per Symbol
input bool AverageUpStrategy=false; // Enable Average Up
input double GridStepUpSizeInPricePercent=1.25; // Average up when price moves X percent
input bool AverageDownStrategy=false; // Enable Average Down
input double GridStepDownSizeInPricePercent=1.25; // Average down when price moves X percent
input bool AllowHedging=false; // Enable Hedging (buy and sell on same symbol)

sinput string BacktestCustomSettings1; // ####
sinput string BacktestCustomSettings2; // #### Backtest Custom Optimization Settings
sinput string BacktestCustomSettings3; // ####

sinput double InitialScore=100; // Backtest Initial Score
sinput double GainsStdDevLimitMin=0.0; // Minimum value of StdDev of gains
sinput double GainsStdDevLimitMax=5.0; // Maximum value of StdDev of gains
sinput int GainsStdDevLimitWeight=2; // Weight of metric Gains StdDev Limit
sinput double LossesStdDevLimitMin=0.0; // Minimum value of StdDev of losses
sinput double LossesStdDevLimitMax=2.5; // Maximum value of StdDev of losses
sinput int LossesStdDevLimitWeight=2; // Weight of metric Losses StdDev Limit
sinput double NetProfitRangeMin=500.0; // Minimum Net Profit
sinput double NetProfitRangeMax=50000.0; // Maximum Net Profit
sinput int NetProfitRangeWeight=10; // Weight of metric NetProfit Range
sinput double ExpectancyRangeMin=1.0; // Minimum Expected Average Gain
sinput double ExpectancyRangeMax=5.0; // Maximum Expected Average Gain
sinput int ExpectancyRangeWeight=30; // Weight of metric Expected Average Gain
sinput double TradesPerDayRangeMin=0.2; // Minimum amount of Trades Per Day
sinput double TradesPerDayRangeMax=5.0;  // Maximum number of Trades Per Day
sinput int TradesPerDayRangeWeight=2; // Weight of metric Trades Per Day
sinput double LargestLossPerTotalGainLimit=1.0; // Max Percent of Largest Loss Per Total Gain
sinput int LargestLossPerTotalGainWeight=2; // Weight of metric Max Percent of Largest Loss Per Total Gain
sinput double MedianLossPerMedianGainPercentLimit=20.0; // Max Percent of Median Loss Per Median Gain
sinput int MedianLossPerMedianGainPercentWeight=2; // Weight of metric Max Percent of Median Loss Per Median Gain

#include <EA\PortfolioManagerBasedBot\BasePortfolioManagerBotConfig.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetBasicConfigs(BasePortfolioManagerBotConfig &config)
  {
   config.watchedSymbols=WatchedSymbols;
   config.lots=Lots;
   config.riskRewardFilter=RiskRewardFilter;
   config.profitTarget=ProfitTarget;
   config.profitTargetSymbol=ProfitTargetSymbol;
   config.maxLoss=MaxLoss;
   config.maxLossSymbol=MaxLossSymbol;
   if(AllowHedging)
     {
      config.profitTargetSymbolHedge=ProfitTargetSymbolHedge;
      config.maxLossSymbolHedge=MaxLossSymbolHedge;
     }
   else
     {
      config.profitTargetSymbolHedge=0;
      config.maxLossSymbolHedge=0;
     }
   config.slippage=Slippage;
   config.startDay=Start_Day;
   config.endDay=End_Day;
   config.startTime=Start_Time;
   config.endTime=End_Time;
   config.scheduleIsDaily=ScheduleIsDaily;
   config.tradeAtBarOpenOnly=TradeAtBarOpenOnly;
   config.pinExits=PinExits;
   config.switchDirectionBySignal=SwitchDirectionBySignal;
   config.maxOpenOrderCount=MaxOpenOrderCount;
   config.averageUpStrategy=AverageUpStrategy;
   config.gridStepUpSizeInPricePercent=GridStepUpSizeInPricePercent;
   config.averageDownStrategy=AverageDownStrategy;
   config.gridStepDownSizeInPricePercent=GridStepDownSizeInPricePercent;
   config.allowHedging=AllowHedging;

   config.backtestConfig.InitialScore=InitialScore;
   config.backtestConfig.GainsStdDevLimitMin=GainsStdDevLimitMin;
   config.backtestConfig.GainsStdDevLimitMax=GainsStdDevLimitMax;
   config.backtestConfig.GainsStdDevLimitWeight=GainsStdDevLimitWeight;
   config.backtestConfig.LossesStdDevLimitMin=LossesStdDevLimitMin;
   config.backtestConfig.LossesStdDevLimitMax=LossesStdDevLimitMax;
   config.backtestConfig.LossesStdDevLimitWeight=LossesStdDevLimitWeight;
   config.backtestConfig.NetProfitRangeMin=NetProfitRangeMin;
   config.backtestConfig.NetProfitRangeMax=NetProfitRangeMax;
   config.backtestConfig.NetProfitRangeWeight=NetProfitRangeWeight;
   config.backtestConfig.ExpectancyRangeMin=ExpectancyRangeMin;
   config.backtestConfig.ExpectancyRangeMax=ExpectancyRangeMax;
   config.backtestConfig.ExpectancyRangeWeight=ExpectancyRangeWeight;
   config.backtestConfig.TradesPerDayRangeMin=TradesPerDayRangeMin;
   config.backtestConfig.TradesPerDayRangeMax=TradesPerDayRangeMax;
   config.backtestConfig.TradesPerDayRangeWeight=TradesPerDayRangeWeight;
   config.backtestConfig.LargestLossPerTotalGainLimit=LargestLossPerTotalGainLimit;
   config.backtestConfig.LargestLossPerTotalGainWeight=LargestLossPerTotalGainWeight;
   config.backtestConfig.MedianLossPerMedianGainPercentLimit=MedianLossPerMedianGainPercentLimit;
   config.backtestConfig.MedianLossPerMedianGainPercentWeight=MedianLossPerMedianGainPercentWeight;

  }
//+------------------------------------------------------------------+
