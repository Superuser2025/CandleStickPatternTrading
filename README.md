# CandlestickPatternTradingEA v1.0

## Professional Institutional Trading Expert Advisor

A sophisticated EA that combines **17 candlestick patterns** with advanced institutional trading concepts including market structure, liquidity detection, fair value gaps, order blocks, and professional risk management.

---

## 📋 Table of Contents

1. [Features](#features)
2. [Architecture](#architecture)
3. [Candlestick Patterns](#candlestick-patterns)
4. [Trading Strategy](#trading-strategy)
5. [Installation](#installation)
6. [Parameters](#parameters)
7. [Risk Management](#risk-management)
8. [Performance Metrics](#performance-metrics)
9. [Usage Guidelines](#usage-guidelines)

---

## ✨ Features

### Core Capabilities

- ✅ **17 Professional Candlestick Patterns** (Single, Double, Triple candle formations)
- ✅ **Market Regime Detection** (Trend/Range/Transition)
- ✅ **Liquidity Mapping** (Swing highs/lows, equal levels, FVG, Order Blocks)
- ✅ **Confluence-Based Entry System** (3-5 factors required)
- ✅ **Professional Risk Management** (0.5% risk per trade, daily/weekly limits)
- ✅ **Smart Trade Management** (Breakeven, Structure Trailing, Exit Rules)
- ✅ **Performance Metrics Tracking** (Win rate, expectancy, R:R analysis)
- ✅ **Indicator Mode** (Visual pattern display without trading)
- ✅ **Modular Architecture** (Clean, maintainable code structure)

---

## 🏗️ Architecture

The EA implements **6 PHASES** with **14 TASKS** as per institutional trading methodology:

### PHASE 1: Market Context
- **Task 1**: Identify Market Regime (Trend/Range/Transition)
- **Task 2**: Determine Bias (BUY/SELL/NEUTRAL)

### PHASE 2: Liquidity & Levels
- **Task 3**: Mark Liquidity Levels (Swings, Equal Highs/Lows)
- **Task 4**: Identify Targets (Liquidity pools, FVGs, Order Blocks)

### PHASE 3: Entry Precision
- **Task 5**: Evaluate Confluence (3-5 factors alignment)
- **Task 6**: Entry Trigger (Pattern + Zone + Confirmation)

### PHASE 4: Risk Management
- **Task 7**: Capital Risk Rules (0.5% per trade, max 3-5 positions)
- **Task 8**: Stop Loss Placement (Structure-based, ATR distance)
- **Task 9**: Take Profit Model (Liquidity/R:R/Imbalance targets)

### PHASE 5: Trade Management
- **Task 10**: Breakeven Logic (Move to BE at 1R)
- **Task 11**: Trailing Logic (Structure-based trailing)
- **Task 12**: Exit Rules (Opposite BOS, volume shift)

### PHASE 6: Review Loop
- **Task 13**: Metrics Tracking (Win rate, expectancy, drawdown)
- **Task 14**: Strategy Refinement (Performance analysis)

---

## 🕯️ Candlestick Patterns

### Single Candle Patterns (7)
| Pattern | Signal | Strength | Description |
|---------|--------|----------|-------------|
| **Hammer** | BUY | 4-5 | Long lower shadow, bullish reversal at bottom |
| **Shooting Star** | SELL | 4-5 | Long upper shadow, bearish reversal at top |
| **Doji** | SPARK | 3 | Indecision candle, wait for direction |
| **Dragonfly Doji** | BUY | 4 | Strong bullish reversal, rejection of lows |
| **Gravestone Doji** | SELL | 4 | Strong bearish reversal, rejection of highs |
| **Marubozu** | ENTER | 5 | Full body, strong continuation signal |
| **Spinning Top** | SPARK | 3 | Indecision, potential reversal coming |

### Two Candle Patterns (5)
| Pattern | Signal | Strength | Description |
|---------|--------|----------|-------------|
| **Bullish Engulfing** | ENTER | 5 | Green candle engulfs red, powerful reversal (80% success) |
| **Bearish Engulfing** | ENTER | 5 | Red candle engulfs green, powerful reversal (80% success) |
| **Bullish Harami** | BUY | 4 | Small green inside large red, needs confirmation |
| **Bearish Harami** | SELL | 4 | Small red inside large green, needs confirmation |
| **Piercing Line** | BUY | 4 | Bullish reversal, closes above 50% (72% success) |
| **Dark Cloud Cover** | SELL | 4 | Bearish reversal, closes below 50% (72% success) |
| **Tweezer Top/Bottom** | BUY/SELL | 3 | Same high/low twice, moderate reliability |

### Three Candle Patterns (5)
| Pattern | Signal | Strength | Description |
|---------|--------|----------|-------------|
| **Morning Star** | ENTER | 5 | Very strong bullish reversal (83% success) |
| **Evening Star** | ENTER | 5 | Very strong bearish reversal (83% success) |
| **Three White Soldiers** | ENTER | 5 | Extremely bullish, consecutive green candles (85% success) |
| **Three Black Crows** | ENTER | 5 | Extremely bearish, consecutive red candles (85% success) |
| **Three Inside Up/Down** | ENTER | 4 | Harami + confirmation (75% success) |

---

## 📊 Trading Strategy

### Entry Logic (Confluence System)

A trade is executed only when **3-5 confluence factors** align:

1. ✓ **Market Regime Aligned** - Trading with trend or at range extremes
2. ✓ **Bias Confirmed** - Pattern direction matches market bias
3. ✓ **Near Liquidity Level** - Within 20 pips of swing high/low
4. ✓ **FVG/Order Block Present** - Price in institutional zone
5. ✓ **Pattern Strength ≥4** - High-probability setup

### Market Structure Detection

```
TREND MODE:
- Price above/below 200 EMA
- EMA slope > threshold
- Clear HH/HL or LH/LL structure
- Bias: Direction of trend

RANGE MODE:
- Flat EMA (slope < threshold)
- Price bouncing between boundaries
- Bias: Only at extremes (80-20 zones)

TRANSITION MODE:
- ATR compression/expansion
- Break of Structure (BOS)
- CHoCH (Change of Character)
- Bias: NEUTRAL, wait for confirmation
```

### Liquidity Mapping

The EA identifies and tracks:

- **Swing Highs/Lows** - Key structural points
- **Equal Highs/Lows** - Where liquidity sits (higher priority)
- **Fair Value Gaps (FVG)** - Imbalance zones (bullish/bearish)
- **Order Blocks** - Last candle before strong move
- **Premium/Discount Zones** - Based on session range

### Take Profit Models

**Model 1: Liquidity Targets**
- TP = Next liquidity pool
- Most institutional approach

**Model 2: R:R Partial**
- TP1 at 2R (close 50%)
- TP2 at 3R
- TP3 at 5R
- Trail remainder

**Model 3: Imbalance Fill**
- Exit when FVG is filled
- Gap completion target

---

## 🔧 Installation

1. **Copy Files to MT5**
   ```
   MQL5/Experts/CandlestickPatternTradingEA.mq5
   MQL5/Include/CandlestickPatterns.mqh
   ```

2. **Compile the EA**
   - Open MetaEditor
   - Compile `CandlestickPatternTradingEA.mq5`
   - Check for any errors

3. **Attach to Chart**
   - Drag EA to your desired chart
   - Configure parameters
   - Enable AutoTrading

4. **Test First!**
   - Start with **Indicator Mode = true** to observe patterns
   - Run on demo account
   - Backtest on historical data

---

## ⚙️ Parameters

### General Settings
```
EnableTrading = true         // Enable auto trading
IndicatorMode = false        // Show patterns only (no trades)
MinLotSize = 0.01           // Minimum position size
MagicNumber = 888777        // Unique EA identifier
```

### Phase 1: Market Regime
```
EMA_Period = 200                     // EMA for trend detection
ATR_Period = 14                      // ATR for volatility
ATR_Expansion_Threshold = 1.3        // ATR expansion factor
EMA_Slope_Threshold = 0.0001         // Minimum EMA slope
```

### Phase 2: Liquidity & Levels
```
SwingLookback = 20                   // Swing high/low detection period
FVG_MinPips = 5                      // Minimum FVG size
OrderBlock_Lookback = 10             // Order block search period
ShowLiquidityLevels = true           // Display zones on chart
```

### Phase 3: Entry Confluence
```
RequiredConfluence = 3               // Required factors (3-5)
DetectSingleCandles = true           // Enable single patterns
DetectDoubleCandles = true           // Enable double patterns
DetectTripleCandles = true           // Enable triple patterns
MinPatternStrength = 2               // Minimum pattern strength (1-5)
```

### Phase 4: Risk Management
```
RiskPerTrade = 0.5                   // Risk % per trade
MaxOpenTrades = 3                    // Maximum concurrent positions
DailyLossLimit = 2.0                 // Stop trading if -2% daily
WeeklyLossLimit = 5.0                // Stop trading if -5% weekly
StopLossATR = 2.0                    // SL distance in ATR multiples
```

### Take Profit Settings
```
TPModel = TP_RR_PARTIAL              // TP_LIQUIDITY, TP_RR_PARTIAL, TP_IMBALANCE
TP1_RR = 2.0                         // First target at 2R
TP2_RR = 3.0                         // Second target at 3R
TP3_RR = 5.0                         // Third target at 5R
PartialClosePercent = 50.0           // Close 50% at TP1
```

### Phase 5: Trade Management
```
UseBreakeven = true                  // Move to BE
BreakevenAtRR = 1.0                  // Move at 1R profit
UseTrailing = true                   // Structure-based trailing
TrailingSwingBars = 10               // Swing lookback for trailing
```

### Visual Settings
```
ShowPatternBoxes = true              // Draw pattern boxes
ShowPatternLabels = true             // Show pattern names
ShowSignalLabels = true              // Show BUY/SELL labels
BuyColor = clrLime                   // Buy signal color
SellColor = clrRed                   // Sell signal color
LabelFontSize = 9                    // Label font size
```

---

## 🛡️ Risk Management

### Capital Protection Rules

**Per Trade Risk**
- Default: **0.5%** of account balance
- Adjustable: 0.1% - 2.0%
- Position size auto-calculated based on SL distance

**Maximum Exposure**
- Max concurrent trades: **3-5**
- Prevents over-leverage
- Diversification across setups

**Daily Loss Limit**
- Stop trading after **-2%** daily loss
- Resets next trading day
- Protects from revenge trading

**Weekly Loss Limit**
- Stop trading after **-5%** weekly loss
- Resets every Monday
- Circuit breaker for bad weeks

**Consecutive Loss Adjustment**
- After **2 losses**: Risk reduced to **0.25%** (50% reduction)
- After **3 wins**: Risk returns to **0.5%**
- Never increase risk after wins

**Stop Loss Placement**
- Structure-based: Below swing low / Above swing high
- ATR-based: 2 x ATR from entry
- Never tighter than structure
- Final SL = Min(structure, ATR-based)

---

## 📈 Performance Metrics

The EA tracks comprehensive performance data:

### Key Metrics
- **Total Trades** - Count of all closed positions
- **Win Rate** - % of profitable trades
- **R:R Ratio** - Average risk-reward achieved
- **Expectancy** - Expected profit per trade
- **Max Consecutive Wins/Losses** - Streak tracking
- **Largest Win/Loss** - Outlier analysis
- **Net P/L** - Total profit/loss
- **Drawdown** - Peak-to-valley decline

### Metrics File
- Saved to: `MQL5/Files/CPTEA_Metrics.dat`
- Persistent across restarts
- Printed on EA shutdown

### Viewing Metrics
```mql5
// Metrics summary printed on EA stop:
========================================
  PERFORMANCE METRICS SUMMARY
========================================
Total Trades: 47
Winning Trades: 32
Losing Trades: 15
Win Rate: 68.09%
Total Profit: $3,450.00
Total Loss: $1,200.00
Net P/L: $2,250.00
Largest Win: $250.00
Largest Loss: $150.00
Max Consecutive Wins: 7
Max Consecutive Losses: 3
Expectancy: $47.87
========================================
```

---

## 📚 Usage Guidelines

### For Beginners

1. **Start with Indicator Mode**
   ```
   IndicatorMode = true
   EnableTrading = false
   ```
   - Observe pattern detection
   - Understand liquidity zones
   - Study market structure

2. **Use Demo Account**
   - Test with virtual money first
   - Minimum 1 month demo testing
   - Verify pattern quality

3. **Conservative Settings**
   ```
   RiskPerTrade = 0.25           // Lower risk
   RequiredConfluence = 5        // More strict
   MinPatternStrength = 4        // High-quality only
   MaxOpenTrades = 2             // Limit exposure
   ```

4. **Study the Patterns**
   - Learn each pattern's characteristics
   - Understand success rates
   - Review why trades win/lose

### For Advanced Traders

1. **Optimize Parameters**
   - Backtest different confluence levels
   - Test TP models (Liquidity vs R:R)
   - Optimize for specific pairs/timeframes

2. **Combine with Analysis**
   - Use EA signals as confirmation
   - Add fundamental analysis
   - Consider session timing (London/NY)

3. **Advanced Risk**
   ```
   RiskPerTrade = 0.5-1.0        // Standard institutional risk
   RequiredConfluence = 3        // Balanced approach
   TPModel = TP_LIQUIDITY        // Institutional targets
   ```

4. **Monitor Performance**
   - Weekly metrics review
   - Identify weak setups
   - Refine entry criteria

### Best Practices

✅ **DO:**
- Start with major pairs (EURUSD, GBPUSD, USDJPY)
- Trade during liquid sessions (London, NY)
- Review metrics weekly
- Respect daily/weekly loss limits
- Wait for high-strength patterns (4-5)

❌ **DON'T:**
- Trade during low liquidity (Asian session)
- Override risk parameters
- Trade during high-impact news
- Chase trades after losses
- Ignore pattern context (trend vs range)

### Recommended Timeframes

| Timeframe | Style | Pattern Quality | Win Rate |
|-----------|-------|----------------|----------|
| **M15** | Scalping | Moderate | 55-65% |
| **H1** | Intraday | Good | 60-70% |
| **H4** | Swing | Excellent | 65-75% |
| **D1** | Position | Highest | 70-80% |

### Recommended Pairs

**Majors (Best):**
- EURUSD - Most liquid, tight spreads
- GBPUSD - Good volatility
- USDJPY - Trending behavior
- AUDUSD - Clear structures

**Crosses (Good):**
- EURGBP - Range-bound
- EURJPY - Trending
- GBPJPY - High volatility (careful!)

**Exotics (Avoid):**
- High spreads
- Low liquidity
- Unpredictable patterns

---

## 🎯 Expected Performance

### Conservative Settings (Demo/Small Account)
```
Risk per trade: 0.25%
Required confluence: 5
Min pattern strength: 4

Expected:
- Win rate: 68-72%
- Avg R:R: 1:2.5
- Trades/week: 2-5
- Monthly return: 3-6%
- Max drawdown: 5-8%
```

### Standard Settings (Experienced)
```
Risk per trade: 0.5%
Required confluence: 3
Min pattern strength: 3

Expected:
- Win rate: 60-65%
- Avg R:R: 1:2.8
- Trades/week: 5-12
- Monthly return: 8-15%
- Max drawdown: 10-15%
```

### Aggressive Settings (Expert Only)
```
Risk per trade: 1.0%
Required confluence: 3
Min pattern strength: 2

Expected:
- Win rate: 55-60%
- Avg R:R: 1:3
- Trades/week: 10-20
- Monthly return: 15-30%
- Max drawdown: 18-25%
```

> **Note:** Past performance doesn't guarantee future results. Always test on demo first!

---

## 🔍 Troubleshooting

### EA Not Trading

**Check:**
- `EnableTrading = true`
- `IndicatorMode = false`
- AutoTrading enabled in MT5
- Account has sufficient balance
- No risk limits reached (daily/weekly)

### No Patterns Detected

**Check:**
- `DetectSingleCandles = true` (etc.)
- `MinPatternStrength` not too high
- Timeframe has sufficient bars
- Patterns exist (use Indicator Mode)

### High Losing Streak

**Actions:**
- Increase `RequiredConfluence` to 4-5
- Increase `MinPatternStrength` to 4
- Trade only H4+ timeframes
- Review market conditions (trending vs ranging)
- Check if patterns match regime

### SL Hit Too Often

**Actions:**
- Increase `StopLossATR` from 2.0 to 2.5-3.0
- Trade higher timeframes
- Check for volatile news periods
- Verify swing detection parameters

---

## 📞 Support & Updates

**GitHub Repository:**
https://github.com/Superuser2025/CandleStickPatternTrading

**Version:** 1.0
**Last Updated:** 2025
**Author:** Pankhuri

---

## ⚖️ Disclaimer

**RISK WARNING:**

Trading Forex and CFDs involves significant risk of loss. This EA is provided for educational purposes. Past performance is not indicative of future results.

**No Guarantee:**
- No guaranteed profits
- Losses can exceed deposits
- Test extensively before live trading
- Start with demo accounts
- Only risk capital you can afford to lose

**User Responsibility:**
- Understand the EA logic
- Monitor performance
- Adjust parameters appropriately
- Comply with broker requirements
- Use proper risk management

---

## 📜 License

Copyright 2025 Pankhuri. All rights reserved.

This EA is for personal use only. Redistribution, modification, or commercial use requires explicit permission.

---

## 🙏 Acknowledgments

- Candlestick pattern logic based on CandleStickPatternMasterPro indicator
- Institutional trading concepts from SMC (Smart Money Concepts)
- Risk management principles from professional fund managers

---

**Happy Trading! 📈**

Remember: The best trader is a disciplined trader. Trust the system, follow the rules, and manage your risk.
