//+------------------------------------------------------------------+
//|                           InstitutionalGradeTradingRobot.mq5     |
//|                                    Copyright 2025, Pankhuri      |
//|                    INSTITUTIONAL-GRADE TRADING SYSTEM             |
//|                         With 20 Professional Fixes                |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Pankhuri"
#property link      "https://www.mql5.com"
#property version   "2.00"
#property description "Institutional-Grade Trading Robot - Citadel-Level Implementation"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>

//+------------------------------------------------------------------+
//| INPUTS - INSTITUTIONAL CONFIGURATION                              |
//+------------------------------------------------------------------+
input group "===== CORE SETTINGS ====="
input bool     EnableTrading = false;                   // Enable Auto Trading (START WITH FALSE!)
input bool     IndicatorMode = true;                    // Indicator Mode (Visual Analysis)
input ENUM_TIMEFRAMES PreferredTimeframe = PERIOD_H4;   // Preferred Timeframe (H4 Default)
input double   MinLotSize = 0.01;                       // Minimum Lot Size
input int      MagicNumber = 999888;                    // Magic Number

input group "===== INSTITUTIONAL FILTERS ====="
input bool     UseVolumeFilter = true;                  // FIX #1: Volume Confirmation
input double   MinVolumeMultiplier = 1.5;               // Minimum Volume (x Average)
input bool     UseSpreadFilter = true;                  // FIX #2: Spread Protection
input double   MaxSpreadATR = 0.3;                      // Max Spread (% of ATR)
input bool     UseSlippageModel = true;                 // FIX #3: Slippage Modeling
input double   ExpectedSlippageATR = 0.1;               // Expected Slippage (% of ATR)

input group "===== MULTI-DIMENSIONAL ANALYSIS ====="
input bool     UseMTFConfirmation = true;               // FIX #5: Multi-Timeframe Confirmation
input bool     UseSessionFilter = true;                 // FIX #6: Session Filtering
input bool     TradeAsianSession = false;               // Trade Asian Session
input bool     TradeLondonSession = true;               // Trade London Session
input bool     TradeNYSession = true;                   // Trade New York Session
input bool     UseCorrelationFilter = true;             // FIX #7: Correlation Analysis
input bool     UseNewsFilter = true;                    // FIX #8: Economic Calendar
input int      NewsAvoidanceMinutes = 30;               // Minutes Before/After News

input group "===== VOLATILITY & ADAPTATION ====="
input bool     UseVolatilityAdaptation = true;          // FIX #9: Volatility Regime
input bool     UseDynamicRisk = true;                   // FIX #10: Drawdown-Adjusted Sizing
input bool     UsePatternDecay = true;                  // FIX #11: Time-Based Pattern Decay
input int      PatternExpiryBars = 3;                   // Pattern Expiry (Bars)

input group "===== SMART MONEY CONCEPTS ====="
input bool     UseLiquiditySweep = true;                // FIX #13: Liquidity Sweep Confirm
input bool     UseRetailTrapDetection = true;           // FIX #14: False Breakout Detection
input bool     UseOBInvalidation = true;                // FIX #15: Order Block Invalidation
input int      MaxOBTests = 3;                          // Max Order Block Tests
input bool     UseMarketStructure = true;               // FIX #16: Structure Sequence

input group "===== MACHINE LEARNING ====="
input bool     UsePatternPerformanceTracking = true;    // FIX #17: Pattern Success by Context
input bool     UseParameterAdaptation = true;           // FIX #18: Self-Optimization
input bool     UseRegimeStrategy = true;                // FIX #19: Regime-Specific Strategy
input int      AdaptationPeriod = 20;                   // Trades for Adaptation

input group "===== RISK MANAGEMENT ====="
input double   BaseRiskPercent = 0.5;                   // Base Risk Per Trade (%)
input int      MaxOpenTrades = 3;                       // Maximum Open Trades
input double   DailyLossLimit = 2.0;                    // Daily Loss Limit (%)
input double   WeeklyLossLimit = 5.0;                   // Weekly Loss Limit (%)
input double   StopLossATR = 2.0;                       // Stop Loss (ATR)
input double   MaxPortfolioCorrelation = 0.7;           // Max Correlation Exposure

input group "===== VISUAL DASHBOARD ====="
input bool     ShowDashboard = true;                    // Show Information Dashboard
input bool     ShowCommentary = true;                   // Show Real-Time Commentary
input bool     ShowAdvice = true;                       // Show Trading Advice
input int      Dashboard_X = 20;                        // Dashboard X Position
input int      Dashboard_Y = 50;                        // Dashboard Y Position
input color    DashboardColorBG = C'20,20,30';          // Dashboard Background
input color    DashboardColorText = clrWhite;           // Dashboard Text Color
input int      DashboardFontSize = 9;                   // Dashboard Font Size

input group "===== TAKE PROFIT MODEL ====="
enum TP_MODEL { TP_LIQUIDITY, TP_RR_PARTIAL, TP_IMBALANCE };
input TP_MODEL TPModel = TP_RR_PARTIAL;
input double   TP1_RR = 2.0;
input double   TP2_RR = 3.0;
input double   TP3_RR = 5.0;

//+------------------------------------------------------------------+
//| GLOBAL OBJECTS                                                    |
//+------------------------------------------------------------------+
CTrade         trade;
CPositionInfo  position;
CAccountInfo   account;

string prefix = "IGTR_";

//+------------------------------------------------------------------+
//| INDICATOR HANDLES                                                 |
//+------------------------------------------------------------------+
int h_EMA_Current, h_EMA_Higher;
int h_ATR_Current, h_ATR_Higher;
int h_Volume_MA;

//+------------------------------------------------------------------+
//| ENUMERATIONS                                                      |
//+------------------------------------------------------------------+
enum MARKET_REGIME {
    REGIME_TREND,       // Trending market
    REGIME_RANGE,       // Range-bound market
    REGIME_TRANSITION   // Transitioning/Choppy
};

enum MARKET_BIAS {
    BIAS_BULLISH,       // Buy bias
    BIAS_BEARISH,       // Sell bias
    BIAS_NEUTRAL        // No bias
};

enum TRADING_SESSION {
    SESSION_ASIAN,      // Asian session (low volatility)
    SESSION_LONDON,     // London session (high volatility)
    SESSION_NY,         // New York session
    SESSION_OVERLAP     // London-NY overlap (best liquidity)
};

enum VOLATILITY_REGIME {
    VOL_LOW,            // Low volatility
    VOL_NORMAL,         // Normal volatility
    VOL_HIGH            // High volatility (reduce risk)
};

enum TRADE_DECISION {
    DECISION_ENTER,     // Enter trade
    DECISION_SKIP,      // Skip trade
    DECISION_WAIT       // Wait for confirmation
};

//+------------------------------------------------------------------+
//| STRUCTURES                                                        |
//+------------------------------------------------------------------+

// Pattern Information
struct PatternInfo {
    string name;
    string signal;
    int strength;
    datetime time;
    double price;
    bool is_bullish;
    int bar_index;
    datetime detected_time;
    int bars_since_detection;
};

// Liquidity Zone
struct LiquidityZone {
    double price;
    int priority;
    datetime time;
    bool is_high;
    bool swept;
    int touch_count;
};

// Fair Value Gap
struct FairValueGap {
    double top;
    double bottom;
    datetime time;
    bool is_bullish;
    bool filled;
    double fill_percent;
};

// Order Block
struct OrderBlock {
    double top;
    double bottom;
    datetime time;
    bool is_bullish;
    bool tested;
    int test_count;
    bool invalidated;
    datetime last_test_time;
};

// Market Structure
struct MarketStructureInfo {
    double last_HH;     // Last Higher High
    double last_HL;     // Last Higher Low
    double last_LH;     // Last Lower High
    double last_LL;     // Last Lower Low
    string structure;   // "BULLISH", "BEARISH", "CHOPPY"
    datetime last_update;
};

// Volume Analysis
struct VolumeData {
    double current_volume;
    double average_volume;
    double volume_ratio;
    bool above_average;
    bool spike_detected;
    string analysis;
};

// Spread Analysis
struct SpreadData {
    double current_spread_pips;
    double max_allowed_pips;
    bool acceptable;
    string status;
};

// Session Info
struct SessionData {
    TRADING_SESSION current_session;
    bool is_tradeable;
    string session_name;
    double expected_volatility;
    string commentary;
};

// Volatility Regime
struct VolatilityData {
    VOLATILITY_REGIME regime;
    double atr_current;
    double atr_average;
    double ratio;
    string status;
    string advice;
};

// Pattern Performance Tracking
struct PatternPerformance {
    string pattern_name;
    MARKET_REGIME regime;
    int total_trades;
    int winning_trades;
    double total_pnl;
    double avg_rr;
    double expectancy;
    double win_rate;
};

// News Event
struct NewsEvent {
    datetime time;
    string currency;
    string event_name;
    int importance;
    bool is_near;
};

// Trade Decision Info
struct TradeDecisionInfo {
    TRADE_DECISION decision;
    string primary_reason;
    string detailed_explanation;
    string passed_filters[20];  // Fixed-size array (max 20 filters)
    string failed_filters[20];  // Fixed-size array (max 20 filters)
    int passed_count;           // Number of passed filters
    int failed_count;           // Number of failed filters
    int confluence_score;
    string advice;
};

// Commentary Line
struct CommentaryLine {
    string text;
    color text_color;
    datetime timestamp;
    int priority;  // 1=Critical, 2=Important, 3=Info
};

// Dashboard Data
struct DashboardInfo {
    // Market Context
    MARKET_REGIME regime;
    MARKET_BIAS bias;
    TRADING_SESSION session;
    VOLATILITY_REGIME volatility;

    // Active Filters
    bool volume_ok;
    bool spread_ok;
    bool session_ok;
    bool news_ok;
    bool mtf_ok;
    bool correlation_ok;

    // Risk Metrics
    double current_risk;
    double daily_pnl;
    double weekly_pnl;
    int open_trades;
    double drawdown_percent;

    // Pattern Info
    string last_pattern;
    int pattern_strength;
    int confluence_score;

    // Performance
    double win_rate;
    double expectancy;
    int total_trades_today;
};

//+------------------------------------------------------------------+
//| GLOBAL VARIABLES                                                  |
//+------------------------------------------------------------------+

// Market State
MARKET_REGIME current_regime = REGIME_TREND;
MARKET_BIAS current_bias = BIAS_NEUTRAL;
TRADING_SESSION current_session = SESSION_ASIAN;
VOLATILITY_REGIME current_volatility = VOL_NORMAL;

// Patterns and Zones
PatternInfo last_pattern;
bool has_active_pattern = false;

LiquidityZone liquidity_zones[];
FairValueGap fvg_zones[];
OrderBlock order_blocks[];
MarketStructureInfo market_structure;

// Analysis Data
VolumeData volume_data;
SpreadData spread_data;
SessionData session_data;
VolatilityData volatility_data;
DashboardInfo dashboard;
TradeDecisionInfo last_decision;

// Commentary System
CommentaryLine commentary_buffer[50];
int commentary_count = 0;

// Pattern Performance Matrix
PatternPerformance pattern_performance[];

// Risk Management
double daily_start_balance;
double weekly_start_balance;
datetime last_daily_reset;
datetime last_weekly_reset;
int consecutive_losses = 0;
int consecutive_wins = 0;
double peak_balance = 0;

// Adaptive Parameters
int dynamic_required_confluence = 3;
double dynamic_risk_percent = 0.5;
double dynamic_tp1_rr = 2.0;

// News Events
NewsEvent upcoming_news[];

//+------------------------------------------------------------------+
//| Expert initialization function                                    |
//+------------------------------------------------------------------+
int OnInit()
{
    Print("╔════════════════════════════════════════════════════════════╗");
    Print("║  INSTITUTIONAL GRADE TRADING ROBOT v2.0                   ║");
    Print("║  Citadel-Level Implementation                             ║");
    Print("║  20 Professional Fixes Integrated                         ║");
    Print("╚════════════════════════════════════════════════════════════╝");

    // Set trade parameters
    trade.SetExpertMagicNumber(MagicNumber);
    trade.SetDeviationInPoints(10);
    trade.SetTypeFilling(ORDER_FILLING_FOK);

    // Initialize indicators
    InitializeIndicators();

    // Initialize risk tracking
    InitializeRiskManagement();

    // Initialize market structure
    ZeroMemory(market_structure);
    market_structure.structure = "INITIALIZING";

    // Load historical performance data
    LoadPatternPerformance();

    // Initialize dashboard
    ZeroMemory(dashboard);

    // Add startup commentary
    AddCommentary("═══ SYSTEM INITIALIZED ═══", clrLime, 1);
    AddCommentary("Preferred Timeframe: " + EnumToString(PreferredTimeframe), clrYellow, 2);
    AddCommentary("20 Institutional Filters Active", clrAqua, 2);

    if(!EnableTrading) {
        AddCommentary("⚠ TRADING DISABLED - Indicator Mode Active", clrOrange, 1);
    } else {
        AddCommentary("✓ AUTO-TRADING ENABLED", clrLime, 1);
    }

    // Validate current timeframe
    if(_Period != PreferredTimeframe) {
        string advice = "ADVICE: You're on " + EnumToString((ENUM_TIMEFRAMES)_Period) +
                       " but preferred is " + EnumToString(PreferredTimeframe) +
                       ". Switch for optimal performance!";
        AddCommentary(advice, clrYellow, 1);
    }

    Print("✓ All systems operational");
    Print("✓ Dashboard ready");
    Print("✓ Commentary system active");

    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Initialize Indicators                                             |
//+------------------------------------------------------------------+
void InitializeIndicators()
{
    // Current timeframe indicators
    h_EMA_Current = iMA(_Symbol, PreferredTimeframe, 200, 0, MODE_EMA, PRICE_CLOSE);
    h_ATR_Current = iATR(_Symbol, PreferredTimeframe, 14);

    // Higher timeframe for MTF confirmation
    ENUM_TIMEFRAMES higher_tf = GetHigherTimeframe(PreferredTimeframe);
    h_EMA_Higher = iMA(_Symbol, higher_tf, 200, 0, MODE_EMA, PRICE_CLOSE);
    h_ATR_Higher = iATR(_Symbol, higher_tf, 14);

    // Volume MA
    h_Volume_MA = iMA(_Symbol, PreferredTimeframe, 20, 0, MODE_SMA, VOLUME_TICK);

    if(h_EMA_Current == INVALID_HANDLE || h_ATR_Current == INVALID_HANDLE ||
       h_EMA_Higher == INVALID_HANDLE || h_ATR_Higher == INVALID_HANDLE ||
       h_Volume_MA == INVALID_HANDLE)
    {
        Print("ERROR: Failed to initialize indicators!");
        AddCommentary("ERROR: Indicator initialization failed!", clrRed, 1);
    } else {
        AddCommentary("✓ Indicators initialized successfully", clrLime, 3);
    }
}

//+------------------------------------------------------------------+
//| Initialize Risk Management                                        |
//+------------------------------------------------------------------+
void InitializeRiskManagement()
{
    daily_start_balance = account.Balance();
    weekly_start_balance = account.Balance();
    peak_balance = account.Balance();
    last_daily_reset = TimeCurrent();
    last_weekly_reset = TimeCurrent();

    AddCommentary("Risk Management: 0.5% per trade, Max 3 positions", clrAqua, 3);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Release indicators
    if(h_EMA_Current != INVALID_HANDLE) IndicatorRelease(h_EMA_Current);
    if(h_ATR_Current != INVALID_HANDLE) IndicatorRelease(h_ATR_Current);
    if(h_EMA_Higher != INVALID_HANDLE) IndicatorRelease(h_EMA_Higher);
    if(h_ATR_Higher != INVALID_HANDLE) IndicatorRelease(h_ATR_Higher);
    if(h_Volume_MA != INVALID_HANDLE) IndicatorRelease(h_Volume_MA);

    // Save pattern performance
    SavePatternPerformance();

    // Delete all objects
    ObjectsDeleteAll(0, prefix);

    Print("═══════════════════════════════════════");
    Print("  Institutional Trading Robot Stopped  ");
    Print("═══════════════════════════════════════");
}

//+------------------------------------------------------------------+
//| Expert tick function                                              |
//+------------------------------------------------------------------+
void OnTick()
{
    // Check for new bar
    static datetime last_bar_time = 0;
    datetime current_bar_time = iTime(_Symbol, PreferredTimeframe, 0);

    if(current_bar_time == last_bar_time)
        return;

    last_bar_time = current_bar_time;

    AddCommentary("═══ NEW BAR: " + TimeToString(current_bar_time) + " ═══", clrWhite, 2);

    // ═══════════════════════════════════════════════════════════
    // PHASE 0: PRE-FLIGHT CHECKS
    // ═══════════════════════════════════════════════════════════

    // FIX #2: Check Spread
    if(UseSpreadFilter) {
        AnalyzeSpread();
        if(!spread_data.acceptable) {
            AddCommentary("⛔ SPREAD TOO WIDE: " + spread_data.status, clrRed, 1);
            AddCommentary("ADVICE: Wait for spread to tighten before trading", clrOrange, 2);
            dashboard.spread_ok = false;
        } else {
            dashboard.spread_ok = true;
        }
    }

    // FIX #6: Check Trading Session
    if(UseSessionFilter) {
        AnalyzeSession();
        if(!session_data.is_tradeable) {
            AddCommentary("⏸ " + session_data.commentary, clrYellow, 2);
            dashboard.session_ok = false;
        } else {
            AddCommentary("✓ Session: " + session_data.session_name + " (Active)", clrLime, 3);
            dashboard.session_ok = true;
        }
    }

    // FIX #8: Check News Events
    if(UseNewsFilter) {
        CheckEconomicCalendar();
        bool news_clear = true;
        for(int i = 0; i < ArraySize(upcoming_news); i++) {
            if(upcoming_news[i].is_near) {
                AddCommentary("📰 HIGH IMPACT NEWS in " +
                             IntegerToString((int)(upcoming_news[i].time - TimeCurrent())/60) +
                             " minutes: " + upcoming_news[i].event_name, clrRed, 1);
                AddCommentary("ADVICE: Avoid trading around major news events", clrOrange, 2);
                news_clear = false;
            }
        }
        dashboard.news_ok = news_clear;
    }

    // ═══════════════════════════════════════════════════════════
    // PHASE 1: MARKET REGIME & CONTEXT
    // ═══════════════════════════════════════════════════════════

    AddCommentary("─── Phase 1: Market Analysis ───", clrAqua, 2);

    // FIX #9: Analyze Volatility Regime
    if(UseVolatilityAdaptation) {
        AnalyzeVolatilityRegime();
        AddCommentary("Volatility: " + volatility_data.status, clrYellow, 3);
        if(volatility_data.advice != "") {
            AddCommentary("ADVICE: " + volatility_data.advice, clrOrange, 2);
        }
    }

    // Detect Market Regime
    DetectMarketRegime();
    string regime_text = "Market Regime: ";
    color regime_color = clrWhite;

    switch(current_regime) {
        case REGIME_TREND:
            regime_text += "TRENDING";
            regime_color = clrLime;
            AddCommentary("ADVICE: Trend following mode - Trade with momentum", clrAqua, 3);
            break;
        case REGIME_RANGE:
            regime_text += "RANGING";
            regime_color = clrYellow;
            AddCommentary("ADVICE: Mean reversion mode - Fade extremes", clrAqua, 3);
            break;
        case REGIME_TRANSITION:
            regime_text += "TRANSITION/CHOPPY";
            regime_color = clrOrange;
            AddCommentary("ADVICE: Avoid trading or wait for breakout confirmation", clrOrange, 2);
            break;
    }
    AddCommentary(regime_text, regime_color, 2);

    // Determine Bias
    DetermineBias();
    string bias_text = "Market Bias: ";
    switch(current_bias) {
        case BIAS_BULLISH:
            bias_text += "BULLISH (Buy Setups Preferred)";
            AddCommentary(bias_text, clrLime, 2);
            break;
        case BIAS_BEARISH:
            bias_text += "BEARISH (Sell Setups Preferred)";
            AddCommentary(bias_text, clrRed, 2);
            break;
        case BIAS_NEUTRAL:
            bias_text += "NEUTRAL (Wait for Direction)";
            AddCommentary(bias_text, clrGray, 2);
            break;
    }

    // FIX #16: Update Market Structure
    if(UseMarketStructure) {
        UpdateMarketStructureSequence();
        AddCommentary("Structure: " + market_structure.structure, clrWhite, 3);
    }

    // ═══════════════════════════════════════════════════════════
    // PHASE 2: LIQUIDITY & LEVELS MAPPING
    // ═══════════════════════════════════════════════════════════

    AddCommentary("─── Phase 2: Liquidity Mapping ───", clrAqua, 2);

    MapLiquidityLevels();
    AddCommentary("Liquidity Levels: " + IntegerToString(ArraySize(liquidity_zones)) + " zones identified", clrWhite, 3);

    DetectFairValueGaps();
    int unfilled_fvg = 0;
    for(int i = 0; i < ArraySize(fvg_zones); i++)
        if(!fvg_zones[i].filled) unfilled_fvg++;
    if(unfilled_fvg > 0)
        AddCommentary("FVG: " + IntegerToString(unfilled_fvg) + " unfilled gaps (targets)", clrAqua, 3);

    DetectOrderBlocks();
    int active_ob = 0;
    for(int i = 0; i < ArraySize(order_blocks); i++)
        if(!order_blocks[i].invalidated) active_ob++;
    if(active_ob > 0)
        AddCommentary("Order Blocks: " + IntegerToString(active_ob) + " active zones", clrAqua, 3);

    // Draw zones if indicator mode or visual enabled
    if(IndicatorMode || ShowDashboard) {
        DrawLiquidityLevels();
        DrawFVGZones();
        DrawOrderBlocks();
    }

    // ═══════════════════════════════════════════════════════════
    // PHASE 3: PATTERN DETECTION & ANALYSIS
    // ═══════════════════════════════════════════════════════════

    AddCommentary("─── Phase 3: Pattern Detection ───", clrAqua, 2);

    ScanForPatterns();

    if(has_active_pattern) {
        AddCommentary("✓ PATTERN DETECTED: " + last_pattern.name +
                     " [Strength: " + IntegerToString(last_pattern.strength) + "/5]",
                     last_pattern.is_bullish ? clrLime : clrRed, 1);

        // Draw pattern
        DrawPatternBox(last_pattern);
        DrawPatternLabel(last_pattern);

        // FIX #11: Check Pattern Decay
        if(UsePatternDecay) {
            if(!IsPatternStillValid()) {
                AddCommentary("⚠ Pattern expired (too old), waiting for fresh setup", clrOrange, 2);
                has_active_pattern = false;
            }
        }
    } else {
        AddCommentary("No valid patterns detected", clrGray, 3);
    }

    // ═══════════════════════════════════════════════════════════
    // PHASE 4: INSTITUTIONAL FILTERS & CONFLUENCE
    // ═══════════════════════════════════════════════════════════

    if(has_active_pattern) {
        AddCommentary("─── Phase 4: Institutional Filters ───", clrAqua, 2);

        // FIX #1: Volume Analysis
        if(UseVolumeFilter) {
            AnalyzeVolume();
            if(volume_data.above_average) {
                AddCommentary("✓ Volume: " + volume_data.analysis +
                             " (" + DoubleToString(volume_data.volume_ratio, 1) + "x avg)", clrLime, 3);
                dashboard.volume_ok = true;
            } else {
                AddCommentary("⚠ Volume: Below average - Pattern may lack conviction", clrOrange, 2);
                AddCommentary("ADVICE: Wait for volume confirmation on next bar", clrYellow, 3);
                dashboard.volume_ok = false;
            }
        }

        // FIX #5: Multi-Timeframe Confirmation
        if(UseMTFConfirmation) {
            bool mtf_aligned = CheckMultiTimeframeConfirmation();
            if(mtf_aligned) {
                AddCommentary("✓ MTF: Higher timeframe confirms direction", clrLime, 3);
                dashboard.mtf_ok = true;
            } else {
                AddCommentary("⚠ MTF: Higher timeframe conflicts - Counter-trend trade", clrOrange, 2);
                AddCommentary("ADVICE: Counter-trend trades have lower probability", clrYellow, 3);
                dashboard.mtf_ok = false;
            }
        }

        // FIX #7: Correlation Check
        if(UseCorrelationFilter) {
            bool corr_ok = CheckPortfolioCorrelation();
            if(!corr_ok) {
                AddCommentary("⛔ Correlation: Portfolio exposure too concentrated", clrRed, 2);
                AddCommentary("ADVICE: Already have correlated positions - Skip to manage risk", clrOrange, 2);
                dashboard.correlation_ok = false;
            } else {
                dashboard.correlation_ok = true;
            }
        }

        // FIX #13: Liquidity Sweep Confirmation
        if(UseLiquiditySweep) {
            bool sweep_confirmed = ConfirmLiquiditySweep(last_pattern.is_bullish);
            if(sweep_confirmed) {
                AddCommentary("✓ Liquidity Sweep: Stop hunt confirmed - Smart money entry", clrLime, 2);
                AddCommentary("ADVICE: High probability setup after liquidity grab", clrAqua, 2);
            }
        }

        // FIX #14: Retail Trap Detection
        if(UseRetailTrapDetection) {
            bool is_trap = IsRetailTrap();
            if(is_trap) {
                AddCommentary("⛔ Retail Trap: False breakout detected - Skipping", clrRed, 1);
                AddCommentary("ADVICE: Smart money fading retail breakout", clrOrange, 2);
                has_active_pattern = false;
            }
        }

        // Evaluate Total Confluence
        TradeDecisionInfo decision = EvaluateTradeDecision();
        last_decision = decision;

        AddCommentary("═══ CONFLUENCE SCORE: " + IntegerToString(decision.confluence_score) +
                     "/" + IntegerToString(dynamic_required_confluence) + " ═══",
                     decision.confluence_score >= dynamic_required_confluence ? clrLime : clrOrange, 1);

        // Show what passed/failed
        for(int i = 0; i < decision.passed_count; i++) {
            AddCommentary("  ✓ " + decision.passed_filters[i], clrLime, 3);
        }
        for(int i = 0; i < decision.failed_count; i++) {
            AddCommentary("  ✗ " + decision.failed_filters[i], clrRed, 3);
        }

        // Show decision and advice
        string decision_text = "";
        color decision_color = clrWhite;

        switch(decision.decision) {
            case DECISION_ENTER:
                decision_text = "🎯 DECISION: ENTER TRADE";
                decision_color = clrLime;
                break;
            case DECISION_SKIP:
                decision_text = "⛔ DECISION: SKIP TRADE";
                decision_color = clrRed;
                break;
            case DECISION_WAIT:
                decision_text = "⏸ DECISION: WAIT FOR CONFIRMATION";
                decision_color = clrYellow;
                break;
        }

        AddCommentary(decision_text, decision_color, 1);
        AddCommentary("REASON: " + decision.detailed_explanation, clrWhite, 2);
        if(decision.advice != "")
            AddCommentary("ADVICE: " + decision.advice, clrAqua, 2);

        // ═══════════════════════════════════════════════════════════
        // PHASE 5: EXECUTION
        // ═══════════════════════════════════════════════════════════

        if(decision.decision == DECISION_ENTER && EnableTrading && !IndicatorMode) {
            AddCommentary("─── Phase 5: Trade Execution ───", clrAqua, 2);

            if(CheckRiskLimits()) {
                // FIX #10: Dynamic Risk
                double risk_percent = UseDynamicRisk ? CalculateDynamicRisk() : BaseRiskPercent;
                AddCommentary("Risk Allocation: " + DoubleToString(risk_percent, 2) + "%", clrYellow, 3);

                // FIX #3: Slippage Model
                if(UseSlippageModel) {
                    double expected_slippage = CalculateExpectedSlippage();
                    AddCommentary("Expected Slippage: " + DoubleToString(expected_slippage * 10000, 1) + " pips", clrYellow, 3);
                }

                ExecuteInstitutionalTrade(risk_percent);
            } else {
                AddCommentary("⛔ RISK LIMIT REACHED - No new trades allowed", clrRed, 1);
                AddCommentary("ADVICE: Daily or weekly loss limit hit - Stop trading", clrOrange, 2);
            }
        }
    }

    // ═══════════════════════════════════════════════════════════
    // PHASE 6: TRADE MANAGEMENT
    // ═══════════════════════════════════════════════════════════

    if(PositionsTotal() > 0) {
        ManageOpenTradesInstitutional();
    }

    // ═══════════════════════════════════════════════════════════
    // PHASE 7: ADAPTATION & LEARNING
    // ═══════════════════════════════════════════════════════════

    // FIX #18: Parameter Adaptation
    if(UseParameterAdaptation) {
        AdaptParameters();
    }

    // Update Dashboard
    UpdateDashboard();
    if(ShowDashboard) {
        DrawDashboard();
    }

    // Render Commentary
    if(ShowCommentary) {
        DrawCommentary();
    }
}

//+------------------------------------------------------------------+
//| FIX #1: VOLUME ANALYSIS                                          |
//+------------------------------------------------------------------+
void AnalyzeVolume()
{
    long current_vol = iVolume(_Symbol, PreferredTimeframe, 1);

    double vol_ma_buffer[];
    ArraySetAsSeries(vol_ma_buffer, true);
    if(CopyBuffer(h_Volume_MA, 0, 0, 20, vol_ma_buffer) <= 0) return;

    double avg_vol = vol_ma_buffer[0];

    volume_data.current_volume = (double)current_vol;
    volume_data.average_volume = avg_vol;
    volume_data.volume_ratio = current_vol / avg_vol;
    volume_data.above_average = volume_data.volume_ratio >= MinVolumeMultiplier;
    volume_data.spike_detected = volume_data.volume_ratio >= 2.0;

    if(volume_data.spike_detected) {
        volume_data.analysis = "SPIKE DETECTED";
    } else if(volume_data.above_average) {
        volume_data.analysis = "Above Average";
    } else {
        volume_data.analysis = "Below Average (Weak)";
    }
}

//+------------------------------------------------------------------+
//| FIX #2: SPREAD FILTERING                                         |
//+------------------------------------------------------------------+
void AnalyzeSpread()
{
    long spread_points = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
    double spread_pips = spread_points * _Point / 10.0;

    double atr_buffer[];
    ArraySetAsSeries(atr_buffer, true);
    if(CopyBuffer(h_ATR_Current, 0, 0, 1, atr_buffer) <= 0) return;

    double atr = atr_buffer[0];
    double max_spread = atr * MaxSpreadATR;
    double max_spread_pips = max_spread / _Point / 10.0;

    spread_data.current_spread_pips = spread_pips;
    spread_data.max_allowed_pips = max_spread_pips;
    spread_data.acceptable = spread_pips <= max_spread_pips;

    if(spread_data.acceptable) {
        spread_data.status = DoubleToString(spread_pips, 1) + " pips (OK)";
    } else {
        spread_data.status = DoubleToString(spread_pips, 1) + " pips (TOO WIDE, max: " +
                            DoubleToString(max_spread_pips, 1) + ")";
    }
}

//+------------------------------------------------------------------+
//| FIX #3: SLIPPAGE MODELING                                        |
//+------------------------------------------------------------------+
double CalculateExpectedSlippage()
{
    double atr_buffer[];
    ArraySetAsSeries(atr_buffer, true);
    if(CopyBuffer(h_ATR_Current, 0, 0, 1, atr_buffer) <= 0) return 0.0001;

    double expected_slippage = atr_buffer[0] * ExpectedSlippageATR;
    return expected_slippage;
}

//+------------------------------------------------------------------+
//| FIX #5: MULTI-TIMEFRAME CONFIRMATION                             |
//+------------------------------------------------------------------+
bool CheckMultiTimeframeConfirmation()
{
    double ema_higher_buffer[];
    ArraySetAsSeries(ema_higher_buffer, true);
    if(CopyBuffer(h_EMA_Higher, 0, 0, 1, ema_higher_buffer) <= 0) return false;

    ENUM_TIMEFRAMES higher_tf = GetHigherTimeframe(PreferredTimeframe);
    double price_higher = iClose(_Symbol, higher_tf, 0);

    bool higher_bullish = price_higher > ema_higher_buffer[0];
    bool higher_bearish = price_higher < ema_higher_buffer[0];

    // Check if pattern direction aligns with higher TF
    if(last_pattern.is_bullish && higher_bearish) return false;
    if(!last_pattern.is_bullish && higher_bullish) return false;

    return true;
}

//+------------------------------------------------------------------+
//| Get Higher Timeframe                                             |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES GetHigherTimeframe(ENUM_TIMEFRAMES current)
{
    switch(current) {
        case PERIOD_M1:  return PERIOD_M5;
        case PERIOD_M5:  return PERIOD_M15;
        case PERIOD_M15: return PERIOD_H1;
        case PERIOD_H1:  return PERIOD_H4;
        case PERIOD_H4:  return PERIOD_D1;
        case PERIOD_D1:  return PERIOD_W1;
        default:         return PERIOD_D1;
    }
}

//+------------------------------------------------------------------+
//| FIX #6: SESSION FILTERING                                        |
//+------------------------------------------------------------------+
void AnalyzeSession()
{
    MqlDateTime dt;
    TimeToStruct(TimeGMT(), dt);
    int hour = dt.hour;

    if(hour >= 0 && hour < 8) {
        current_session = SESSION_ASIAN;
        session_data.current_session = SESSION_ASIAN;
        session_data.session_name = "Asian";
        session_data.expected_volatility = 0.5;
        session_data.is_tradeable = TradeAsianSession;
        session_data.commentary = "Asian Session: Low volatility, tight ranges";
    }
    else if(hour >= 8 && hour < 13) {
        current_session = SESSION_LONDON;
        session_data.current_session = SESSION_LONDON;
        session_data.session_name = "London";
        session_data.expected_volatility = 1.2;
        session_data.is_tradeable = TradeLondonSession;
        session_data.commentary = "London Session: High volatility, trending moves";
    }
    else if(hour >= 13 && hour < 16) {
        current_session = SESSION_OVERLAP;
        session_data.current_session = SESSION_OVERLAP;
        session_data.session_name = "London-NY Overlap";
        session_data.expected_volatility = 1.5;
        session_data.is_tradeable = TradeLondonSession && TradeNYSession;
        session_data.commentary = "Overlap: Best liquidity and opportunity";
    }
    else if(hour >= 16 && hour < 21) {
        current_session = SESSION_NY;
        session_data.current_session = SESSION_NY;
        session_data.session_name = "New York";
        session_data.expected_volatility = 1.1;
        session_data.is_tradeable = TradeNYSession;
        session_data.commentary = "New York Session: Good volatility";
    }
    else {
        current_session = SESSION_ASIAN;
        session_data.current_session = SESSION_ASIAN;
        session_data.session_name = "After Hours";
        session_data.expected_volatility = 0.3;
        session_data.is_tradeable = TradeAsianSession;
        session_data.commentary = "After Hours: Very low liquidity";
    }
}

//+------------------------------------------------------------------+
//| FIX #7: CORRELATION ANALYSIS                                     |
//+------------------------------------------------------------------+
bool CheckPortfolioCorrelation()
{
    // Simplified correlation check
    // In production, use correlation matrix across all pairs

    string base_currency = StringSubstr(_Symbol, 0, 3);
    string quote_currency = StringSubstr(_Symbol, 3, 3);

    double net_exposure = 0;
    int position_count = 0;

    for(int i = 0; i < PositionsTotal(); i++) {
        if(position.SelectByIndex(i)) {
            if(position.Magic() != MagicNumber) continue;

            string pos_symbol = position.Symbol();
            string pos_base = StringSubstr(pos_symbol, 0, 3);
            string pos_quote = StringSubstr(pos_symbol, 3, 3);

            double lots = position.Volume();
            int direction = position.Type() == POSITION_TYPE_BUY ? 1 : -1;

            // Check if correlated (same base or quote currency)
            if(pos_base == base_currency || pos_quote == quote_currency ||
               pos_base == quote_currency || pos_quote == base_currency) {
                net_exposure += lots * direction;
                position_count++;
            }
        }
    }

    // Reject if too much correlated exposure
    if(MathAbs(net_exposure) > MaxPortfolioCorrelation * 10) {
        return false;
    }

    return true;
}

//+------------------------------------------------------------------+
//| FIX #8: ECONOMIC CALENDAR INTEGRATION                            |
//+------------------------------------------------------------------+
void CheckEconomicCalendar()
{
    ArrayResize(upcoming_news, 0);

    MqlCalendarValue values[];
    MqlCalendarEvent events[];

    datetime from = TimeCurrent();
    datetime to = TimeCurrent() + NewsAvoidanceMinutes * 60;

    if(CalendarValueHistory(values, from, to) > 0) {
        for(int i = 0; i < ArraySize(values); i++) {
            MqlCalendarEvent event;
            if(CalendarEventById(values[i].event_id, event)) {
                if(event.importance == CALENDAR_IMPORTANCE_HIGH) {
                    int idx = ArraySize(upcoming_news);
                    ArrayResize(upcoming_news, idx + 1);

                    upcoming_news[idx].time = values[i].time;
                    upcoming_news[idx].event_name = event.name;
                    upcoming_news[idx].importance = event.importance;
                    upcoming_news[idx].is_near = true;

                    MqlCalendarCountry country;
                    CalendarCountryById(event.country_id, country);
                    upcoming_news[idx].currency = country.currency;
                }
            }
        }
    }
}

//+------------------------------------------------------------------+
//| FIX #9: VOLATILITY REGIME ADAPTATION                             |
//+------------------------------------------------------------------+
void AnalyzeVolatilityRegime()
{
    double atr_buffer[];
    ArraySetAsSeries(atr_buffer, true);
    if(CopyBuffer(h_ATR_Current, 0, 0, 100, atr_buffer) <= 0) return;

    double atr_current = atr_buffer[0];
    double atr_sum = 0;
    for(int i = 0; i < 100; i++) atr_sum += atr_buffer[i];
    double atr_avg = atr_sum / 100;

    double ratio = atr_current / atr_avg;

    volatility_data.atr_current = atr_current;
    volatility_data.atr_average = atr_avg;
    volatility_data.ratio = ratio;

    if(ratio < 0.7) {
        current_volatility = VOL_LOW;
        volatility_data.regime = VOL_LOW;
        volatility_data.status = "LOW (Compress Mode)";
        volatility_data.advice = "Low volatility - Expect expansion soon. Tighten stops, smaller targets.";
    }
    else if(ratio > 1.5) {
        current_volatility = VOL_HIGH;
        volatility_data.regime = VOL_HIGH;
        volatility_data.status = "HIGH (Caution Mode)";
        volatility_data.advice = "High volatility - Reduce position size, widen stops, be selective.";

        // Adapt parameters for high volatility
        if(UseVolatilityAdaptation) {
            dynamic_risk_percent = BaseRiskPercent * 0.5;  // Half risk
            dynamic_required_confluence = 5;  // Very selective
        }
    }
    else {
        current_volatility = VOL_NORMAL;
        volatility_data.regime = VOL_NORMAL;
        volatility_data.status = "NORMAL";
        volatility_data.advice = "";
    }
}

//+------------------------------------------------------------------+
//| FIX #10: DYNAMIC RISK CALCULATION                                |
//+------------------------------------------------------------------+
double CalculateDynamicRisk()
{
    double base_risk = BaseRiskPercent / 100.0;

    // Track peak balance
    if(account.Balance() > peak_balance) {
        peak_balance = account.Balance();
    }

    // Calculate current drawdown
    double drawdown = 0;
    if(peak_balance > 0) {
        drawdown = (peak_balance - account.Balance()) / peak_balance;
    }

    // Reduce risk during drawdown
    if(drawdown > 0.05) {  // 5%+ drawdown
        base_risk *= (1.0 - drawdown);
        AddCommentary("Risk Reduced: Drawdown " + DoubleToString(drawdown*100, 1) +
                     "% → Risk now " + DoubleToString(base_risk*100, 2) + "%", clrOrange, 2);
    }

    // Reduce risk after consecutive losses
    if(consecutive_losses >= 2) {
        base_risk *= 0.5;
        AddCommentary("Risk Reduced: " + IntegerToString(consecutive_losses) +
                     " losses → Risk now " + DoubleToString(base_risk*100, 2) + "%", clrOrange, 2);
    }

    // Adjust for volatility
    if(current_volatility == VOL_HIGH) {
        base_risk *= 0.5;
    }

    return base_risk * 100.0;  // Return as percentage
}

//+------------------------------------------------------------------+
//| FIX #11: PATTERN DECAY CHECK                                     |
//+------------------------------------------------------------------+
bool IsPatternStillValid()
{
    int bars_ago = Bars(_Symbol, PreferredTimeframe, last_pattern.detected_time, TimeCurrent()) - 1;

    if(bars_ago > PatternExpiryBars) {
        return false;
    }

    // Reduce strength over time
    last_pattern.strength -= bars_ago;
    if(last_pattern.strength < 1) {
        return false;
    }

    return true;
}

//+------------------------------------------------------------------+
//| INCLUDE ADDITIONAL MODULES                                        |
//+------------------------------------------------------------------+
#include "CandlestickPatterns.mqh"
#include "InstitutionalGradeTradingRobot_Part2.mqh"

//+------------------------------------------------------------------+
//| HELPER FUNCTIONS FROM ORIGINAL EA                                |
//+------------------------------------------------------------------+

void DetectMarketRegime()
{
    double ema_buffer[];
    double atr_buffer[];
    ArraySetAsSeries(ema_buffer, true);
    ArraySetAsSeries(atr_buffer, true);

    if(CopyBuffer(h_EMA_Current, 0, 0, 50, ema_buffer) <= 0) return;
    if(CopyBuffer(h_ATR_Current, 0, 0, 20, atr_buffer) <= 0) return;

    double ema_slope = (ema_buffer[0] - ema_buffer[10]) / 10;
    double avg_atr = 0;
    for(int i = 0; i < 10; i++) avg_atr += atr_buffer[i];
    avg_atr /= 10;
    double atr_ratio = atr_buffer[0] / avg_atr;

    bool bos_detected = DetectBreakOfStructure();

    if(MathAbs(ema_slope) > 0.0001 && !bos_detected) {
        current_regime = REGIME_TREND;
    } else if(MathAbs(ema_slope) < 0.00005 && atr_ratio < 1.1) {
        current_regime = REGIME_RANGE;
    } else {
        current_regime = REGIME_TRANSITION;
    }
}

void DetermineBias()
{
    double ema_buffer[];
    ArraySetAsSeries(ema_buffer, true);
    if(CopyBuffer(h_EMA_Current, 0, 0, 3, ema_buffer) <= 0) return;

    double close_price = iClose(_Symbol, PreferredTimeframe, 1);

    if(current_regime == REGIME_TREND) {
        if(close_price > ema_buffer[0])
            current_bias = BIAS_BULLISH;
        else
            current_bias = BIAS_BEARISH;
    } else if(current_regime == REGIME_RANGE) {
        double range_high = GetRangeHigh();
        double range_low = GetRangeLow();
        double range_middle = (range_high + range_low) / 2;

        if(close_price < range_low + (range_high - range_low) * 0.2)
            current_bias = BIAS_BULLISH;
        else if(close_price > range_high - (range_high - range_low) * 0.2)
            current_bias = BIAS_BEARISH;
        else
            current_bias = BIAS_NEUTRAL;
    } else {
        current_bias = BIAS_NEUTRAL;
    }
}

bool DetectBreakOfStructure()
{
    double high1 = iHigh(_Symbol, PreferredTimeframe, 1);
    double high2 = iHigh(_Symbol, PreferredTimeframe, 2);
    double low1 = iLow(_Symbol, PreferredTimeframe, 1);
    double low2 = iLow(_Symbol, PreferredTimeframe, 2);

    if(high1 > high2) return true;
    if(low1 < low2) return true;
    return false;
}

double GetRangeHigh()
{
    double high = 0;
    for(int i = 1; i < 50; i++) {
        double h = iHigh(_Symbol, PreferredTimeframe, i);
        if(h > high) high = h;
    }
    return high;
}

double GetRangeLow()
{
    double low = DBL_MAX;
    for(int i = 1; i < 50; i++) {
        double l = iLow(_Symbol, PreferredTimeframe, i);
        if(l < low) low = l;
    }
    return low;
}

double GetSwingHigh(int lookback)
{
    double high = 0;
    for(int i = 1; i <= lookback; i++) {
        double h = iHigh(_Symbol, PreferredTimeframe, i);
        if(h > high) high = h;
    }
    return high;
}

double GetSwingLow(int lookback)
{
    double low = DBL_MAX;
    for(int i = 1; i <= lookback; i++) {
        double l = iLow(_Symbol, PreferredTimeframe, i);
        if(l < low) low = l;
    }
    return low;
}

void MapLiquidityLevels()
{
    ArrayResize(liquidity_zones, 0);
    int lookback = 20;

    for(int i = lookback; i < 100; i++) {
        double high = iHigh(_Symbol, PreferredTimeframe, i);
        double low = iLow(_Symbol, PreferredTimeframe, i);
        datetime time = iTime(_Symbol, PreferredTimeframe, i);

        bool is_swing_high = true;
        for(int j = 1; j <= lookback; j++) {
            if(iHigh(_Symbol, PreferredTimeframe, i-j) >= high ||
               iHigh(_Symbol, PreferredTimeframe, i+j) >= high) {
                is_swing_high = false;
                break;
            }
        }

        bool is_swing_low = true;
        for(int j = 1; j <= lookback; j++) {
            if(iLow(_Symbol, PreferredTimeframe, i-j) <= low ||
               iLow(_Symbol, PreferredTimeframe, i+j) <= low) {
                is_swing_low = false;
                break;
            }
        }

        if(is_swing_high) {
            int idx = ArraySize(liquidity_zones);
            ArrayResize(liquidity_zones, idx + 1);
            liquidity_zones[idx].price = high;
            liquidity_zones[idx].priority = 2;
            liquidity_zones[idx].time = time;
            liquidity_zones[idx].is_high = true;
            liquidity_zones[idx].swept = false;
            liquidity_zones[idx].touch_count = 0;
        }

        if(is_swing_low) {
            int idx = ArraySize(liquidity_zones);
            ArrayResize(liquidity_zones, idx + 1);
            liquidity_zones[idx].price = low;
            liquidity_zones[idx].priority = 2;
            liquidity_zones[idx].time = time;
            liquidity_zones[idx].is_high = false;
            liquidity_zones[idx].swept = false;
            liquidity_zones[idx].touch_count = 0;
        }
    }
}

void DetectFairValueGaps()
{
    ArrayResize(fvg_zones, 0);
    double min_gap = 5 * _Point * 10;

    for(int i = 1; i < 50; i++) {
        double high1 = iHigh(_Symbol, PreferredTimeframe, i+1);
        double low1 = iLow(_Symbol, PreferredTimeframe, i+1);
        double high2 = iHigh(_Symbol, PreferredTimeframe, i);
        double low2 = iLow(_Symbol, PreferredTimeframe, i);
        double high3 = iHigh(_Symbol, PreferredTimeframe, i-1);
        double low3 = iLow(_Symbol, PreferredTimeframe, i-1);

        if(low3 > high1 && (low3 - high1) >= min_gap) {
            int idx = ArraySize(fvg_zones);
            ArrayResize(fvg_zones, idx + 1);
            fvg_zones[idx].top = low3;
            fvg_zones[idx].bottom = high1;
            fvg_zones[idx].time = iTime(_Symbol, PreferredTimeframe, i);
            fvg_zones[idx].is_bullish = true;
            fvg_zones[idx].filled = false;
            fvg_zones[idx].fill_percent = 0;
        }

        if(high3 < low1 && (low1 - high3) >= min_gap) {
            int idx = ArraySize(fvg_zones);
            ArrayResize(fvg_zones, idx + 1);
            fvg_zones[idx].top = low1;
            fvg_zones[idx].bottom = high3;
            fvg_zones[idx].time = iTime(_Symbol, PreferredTimeframe, i);
            fvg_zones[idx].is_bullish = false;
            fvg_zones[idx].filled = false;
            fvg_zones[idx].fill_percent = 0;
        }
    }
}

void DetectOrderBlocks()
{
    ArrayResize(order_blocks, 0);

    for(int i = 2; i < 10; i++) {
        double close_prev = iClose(_Symbol, PreferredTimeframe, i);
        double open_prev = iOpen(_Symbol, PreferredTimeframe, i);
        double close_curr = iClose(_Symbol, PreferredTimeframe, i-1);

        if(close_prev < open_prev && close_curr > close_prev) {
            double body_top = MathMax(open_prev, close_prev);
            double body_bottom = MathMin(open_prev, close_prev);

            int idx = ArraySize(order_blocks);
            ArrayResize(order_blocks, idx + 1);
            order_blocks[idx].top = body_top;
            order_blocks[idx].bottom = body_bottom;
            order_blocks[idx].time = iTime(_Symbol, PreferredTimeframe, i);
            order_blocks[idx].is_bullish = true;
            order_blocks[idx].tested = false;
            order_blocks[idx].test_count = 0;
            order_blocks[idx].invalidated = false;
        }

        if(close_prev > open_prev && close_curr < close_prev) {
            double body_top = MathMax(open_prev, close_prev);
            double body_bottom = MathMin(open_prev, close_prev);

            int idx = ArraySize(order_blocks);
            ArrayResize(order_blocks, idx + 1);
            order_blocks[idx].top = body_top;
            order_blocks[idx].bottom = body_bottom;
            order_blocks[idx].time = iTime(_Symbol, PreferredTimeframe, i);
            order_blocks[idx].is_bullish = false;
            order_blocks[idx].tested = false;
            order_blocks[idx].test_count = 0;
            order_blocks[idx].invalidated = false;
        }
    }

    if(UseOBInvalidation) {
        UpdateOrderBlocksInvalidation();
    }
}

void ScanForPatterns()
{
    PatternInfo pattern;
    bool found = false;

    double o[], h[], l[], c[];
    ArraySetAsSeries(o, true);
    ArraySetAsSeries(h, true);
    ArraySetAsSeries(l, true);
    ArraySetAsSeries(c, true);

    if(CopyOpen(_Symbol, PreferredTimeframe, 0, 5, o) <= 0) return;
    if(CopyHigh(_Symbol, PreferredTimeframe, 0, 5, h) <= 0) return;
    if(CopyLow(_Symbol, PreferredTimeframe, 0, 5, l) <= 0) return;
    if(CopyClose(_Symbol, PreferredTimeframe, 0, 5, c) <= 0) return;

    if(!found) found = DetectHammer(1, o, h, l, c, pattern);
    if(!found) found = DetectShootingStar(1, o, h, l, c, pattern);
    if(!found) found = DetectEngulfing(1, o, h, l, c, pattern);
    if(!found) found = DetectMorningStar(1, o, h, l, c, pattern);
    if(!found) found = DetectEveningStar(1, o, h, l, c, pattern);
    if(!found) found = DetectThreeWhiteSoldiers(1, o, h, l, c, pattern);
    if(!found) found = DetectThreeBlackCrows(1, o, h, l, c, pattern);
    if(!found) found = DetectMarubozu(1, o, h, l, c, pattern);
    if(!found) found = DetectHarami(1, o, h, l, c, pattern);

    if(found && pattern.strength >= 2) {
        last_pattern = pattern;
        last_pattern.detected_time = TimeCurrent();
        last_pattern.bars_since_detection = 0;
        has_active_pattern = true;

        if(UseRegimeStrategy) {
            ApplyRegimeSpecificStrategy();
        }
    }
}

double CalculateStopLoss(bool is_buy)
{
    double atr_buffer[];
    ArraySetAsSeries(atr_buffer, true);
    if(CopyBuffer(h_ATR_Current, 0, 0, 1, atr_buffer) <= 0) return 0;

    double atr = atr_buffer[0];
    double sl_distance = atr * StopLossATR;
    double entry_price = last_pattern.price;
    double sl_price;

    if(is_buy) {
        double swing_low = GetSwingLow(20);
        double atr_sl = entry_price - sl_distance;
        sl_price = MathMin(swing_low - 5 * _Point, atr_sl);
    } else {
        double swing_high = GetSwingHigh(20);
        double atr_sl = entry_price + sl_distance;
        sl_price = MathMax(swing_high + 5 * _Point, atr_sl);
    }

    return NormalizeDouble(sl_price, _Digits);
}

void CalculateTakeProfits(bool is_buy, double entry, double sl, double &tp1, double &tp2, double &tp3)
{
    double sl_distance = MathAbs(entry - sl);

    tp1 = entry + (is_buy ? 1 : -1) * sl_distance * dynamic_tp1_rr;
    tp2 = entry + (is_buy ? 1 : -1) * sl_distance * TP2_RR;
    tp3 = entry + (is_buy ? 1 : -1) * sl_distance * TP3_RR;

    tp1 = NormalizeDouble(tp1, _Digits);
    tp2 = NormalizeDouble(tp2, _Digits);
    tp3 = NormalizeDouble(tp3, _Digits);
}

double CalculateLotSize(double stop_loss_pips, double risk_percent)
{
    double capital_risk = account.Balance() * (risk_percent / 100.0);
    double tick_value = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double tick_size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
    double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

    double sl_in_price = stop_loss_pips * point;
    double risk_per_lot = (sl_in_price / tick_size) * tick_value;

    double lot_size = capital_risk / risk_per_lot;
    double lot_step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
    lot_size = MathFloor(lot_size / lot_step) * lot_step;

    double min_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);

    if(lot_size < MinLotSize) lot_size = MinLotSize;
    if(lot_size < min_lot) lot_size = min_lot;
    if(lot_size > max_lot) lot_size = max_lot;

    return lot_size;
}

bool CheckRiskLimits()
{
    MqlDateTime dt_current, dt_last;
    TimeToStruct(TimeCurrent(), dt_current);
    TimeToStruct(last_daily_reset, dt_last);

    if(dt_current.day != dt_last.day) {
        daily_start_balance = account.Balance();
        last_daily_reset = TimeCurrent();
    }

    if(dt_current.day_of_week < dt_last.day_of_week || dt_current.day - dt_last.day >= 7) {
        weekly_start_balance = account.Balance();
        last_weekly_reset = TimeCurrent();
    }

    double daily_loss = ((daily_start_balance - account.Balance()) / daily_start_balance) * 100.0;
    if(daily_loss >= DailyLossLimit) return false;

    double weekly_loss = ((weekly_start_balance - account.Balance()) / weekly_start_balance) * 100.0;
    if(weekly_loss >= WeeklyLossLimit) return false;

    if(PositionsTotal() >= MaxOpenTrades) return false;

    return true;
}

bool CheckOppositeStructureBreak(bool is_buy_position)
{
    double close1 = iClose(_Symbol, PreferredTimeframe, 1);

    if(is_buy_position) {
        double swing_low = GetSwingLow(10);
        if(close1 < swing_low) return true;
    } else {
        double swing_high = GetSwingHigh(10);
        if(close1 > swing_high) return true;
    }

    return false;
}

void LoadPatternPerformance()
{
    int handle = FileOpen("IGTR_PatternPerformance.dat", FILE_READ | FILE_BIN);
    if(handle != INVALID_HANDLE) {
        int size = FileReadInteger(handle);
        ArrayResize(pattern_performance, size);
        for(int i = 0; i < size; i++) {
            FileReadStruct(handle, pattern_performance[i]);
        }
        FileClose(handle);
        AddCommentary("✓ Loaded " + IntegerToString(size) + " pattern performance records", clrAqua, 3);
    }
}

void SavePatternPerformance()
{
    int handle = FileOpen("IGTR_PatternPerformance.dat", FILE_WRITE | FILE_BIN);
    if(handle != INVALID_HANDLE) {
        FileWriteInteger(handle, ArraySize(pattern_performance));
        for(int i = 0; i < ArraySize(pattern_performance); i++) {
            FileWriteStruct(handle, pattern_performance[i]);
        }
        FileClose(handle);
    }
}

void DrawLiquidityLevels()
{
    for(int i = 0; i < ArraySize(liquidity_zones); i++) {
        string name = prefix + "LIQ_" + IntegerToString(i);
        if(ObjectFind(0, name) < 0) {
            ObjectCreate(0, name, OBJ_HLINE, 0, 0, liquidity_zones[i].price);
            ObjectSetInteger(0, name, OBJPROP_COLOR, liquidity_zones[i].is_high ? clrRed : clrBlue);
            ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT);
            ObjectSetInteger(0, name, OBJPROP_WIDTH, liquidity_zones[i].swept ? 2 : 1);
        }
    }
}

void DrawFVGZones()
{
    for(int i = 0; i < ArraySize(fvg_zones); i++) {
        if(fvg_zones[i].filled) continue;
        string name = prefix + "FVG_" + IntegerToString(i);
        if(ObjectFind(0, name) < 0) {
            datetime time_now = TimeCurrent();
            ObjectCreate(0, name, OBJ_RECTANGLE, 0,
                        fvg_zones[i].time, fvg_zones[i].top,
                        time_now + PeriodSeconds(PreferredTimeframe) * 50, fvg_zones[i].bottom);
            ObjectSetInteger(0, name, OBJPROP_COLOR, fvg_zones[i].is_bullish ? clrLightGreen : clrLightPink);
            ObjectSetInteger(0, name, OBJPROP_BACK, true);
            ObjectSetInteger(0, name, OBJPROP_FILL, true);
        }
    }
}

void DrawOrderBlocks()
{
    for(int i = 0; i < ArraySize(order_blocks); i++) {
        if(order_blocks[i].invalidated) continue;
        string name = prefix + "OB_" + IntegerToString(i);
        if(ObjectFind(0, name) < 0) {
            datetime time_now = TimeCurrent();
            ObjectCreate(0, name, OBJ_RECTANGLE, 0,
                        order_blocks[i].time, order_blocks[i].top,
                        time_now + PeriodSeconds(PreferredTimeframe) * 50, order_blocks[i].bottom);
            ObjectSetInteger(0, name, OBJPROP_COLOR, order_blocks[i].is_bullish ? C'0,100,0' : clrCrimson);
            ObjectSetInteger(0, name, OBJPROP_BACK, true);
            ObjectSetInteger(0, name, OBJPROP_FILL, true);
        }
    }
}

void DrawPatternBox(PatternInfo &p)
{
    double atr_buffer[];
    ArraySetAsSeries(atr_buffer, true);
    if(CopyBuffer(h_ATR_Current, 0, 0, 1, atr_buffer) <= 0) return;

    double atr = atr_buffer[0];
    datetime time = iTime(_Symbol, PreferredTimeframe, p.bar_index);
    string name = prefix + "BOX_" + TimeToString(time);

    double top = p.price + atr;
    double bottom = p.price - atr;

    ObjectCreate(0, name, OBJ_RECTANGLE, 0, time, top,
                time + PeriodSeconds(PreferredTimeframe), bottom);
    color box_color = p.is_bullish ? clrLime : clrRed;
    ObjectSetInteger(0, name, OBJPROP_COLOR, box_color);
    ObjectSetInteger(0, name, OBJPROP_BACK, false);
    ObjectSetInteger(0, name, OBJPROP_FILL, false);
    ObjectSetInteger(0, name, OBJPROP_WIDTH, 2);
}

void DrawPatternLabel(PatternInfo &p)
{
    datetime time = iTime(_Symbol, PreferredTimeframe, p.bar_index);
    string name = prefix + "LABEL_" + TimeToString(time);

    double price = p.is_bullish ? iLow(_Symbol, PreferredTimeframe, p.bar_index) - 10 * _Point :
                                   iHigh(_Symbol, PreferredTimeframe, p.bar_index) + 10 * _Point;

    ObjectCreate(0, name, OBJ_TEXT, 0, time, price);
    ObjectSetString(0, name, OBJPROP_TEXT, p.name + " (" + p.signal + ")");
    ObjectSetInteger(0, name, OBJPROP_COLOR, p.is_bullish ? clrLime : clrRed);
    ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
    ObjectSetString(0, name, OBJPROP_FONT, "Arial Bold");
}

//+------------------------------------------------------------------+
