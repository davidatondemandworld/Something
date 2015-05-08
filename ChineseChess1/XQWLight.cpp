/**
 * XiangQi Wizard Light - A Very Simple Chinese Chess Program
 * Designed by Morning Yellow, Version: 0.6, Last Modified: Mar. 2008
 * Copyright (C) 2004-2008 www.elephantbase.net
 *
 * œÛ∆Â–°Œ◊ ¶ 0.6 µƒƒø±Í£∫
 * “ª°¢ µœ÷ø™æ÷ø‚£ª
 * ∂˛°¢ µœ÷PVS(÷˜“™±‰¿˝À—À˜)£ª
 * »˝°¢∞—∏˘Ω⁄µ„µƒÀ—À˜µ•∂¿¥¶¿Ì£¨‘ˆº”À—À˜µƒÀÊª˙–‘£ª
 * Àƒ°¢øÀ∑˛”…≥§Ω´“˝∆µƒ÷√ªª±Ìµƒ≤ªŒ»∂®–‘°£
 */

/////////////////////////////////////////////////////////////////////////////
// Name:            XQWLight.cpp
// Created:         10/11/2008
//
// Original Name:   XQWL06.CPP (of the package 'xqwlight_win32.7z')
//
// Description:     This is 'XQWLight' Engine to interface with HOXChess.
//                  XQWLight is an open-source (?) Xiangqi AI Engine
//                  written by Huang Chen at www.elephantbase.net
//
//  (Original Chinese URL)
//        http://www.elephantbase.net/computer/stepbystep1.htm
//
//  (Translated English URL using Goold Translate)
//       http://74.125.93.104/translate_c?hl=en&langpair=
//         zh-CN|en&u=http://www.elephantbase.net/computer/stepbystep1.htm&
//         usg=ALkJrhj7W0v3J1P-xmbufsWzYq7uKciL1w
/////////////////////////////////////////////////////////////////////////////


#include <time.h>
#include <cstring>
#include <cstdlib>


/////////////////////////////////////////////////////////////////////////////
///////          START of  HPHAN's changes                      /////////////

// *** Typedef (to avoid having to include WinDef.h) ***
typedef unsigned char       BYTE;
typedef int                 BOOL;
typedef unsigned short      WORD;
/* Not work on Ubuntu: typedef unsigned long       DWORD; */
typedef unsigned int       DWORD;
#ifndef FALSE
#  define FALSE               0
#endif

#ifndef TRUE
#  define TRUE                1
#endif

// *** Additional variables ***
static int         s_search_depth = 7; // Search Depth
static int         s_search_time = 1;  // In seconds (search-time)
//static const char* s_opening_book = "../plugins/BOOK.DAT";

///////          END of  HPHAN's changes                      /////////////
///////////////////////////////////////////////////////////////////////////////


const int SQUARE_SIZE = 56;
const int BOARD_EDGE = 8;
const int BOARD_WIDTH = BOARD_EDGE + SQUARE_SIZE * 9 + BOARD_EDGE;
const int BOARD_HEIGHT = BOARD_EDGE + SQUARE_SIZE * 10 + BOARD_EDGE;

// ∆Â≈Ã∑∂Œß
const int RANK_TOP = 3;
const int RANK_BOTTOM = 12;
const int FILE_LEFT = 3;
const int FILE_RIGHT = 11;

// ∆Â◊”±‡∫≈
const int PIECE_KING = 0;
const int PIECE_ADVISOR = 1;
const int PIECE_BISHOP = 2;
const int PIECE_KNIGHT = 3;
const int PIECE_ROOK = 4;
const int PIECE_CANNON = 5;
const int PIECE_PAWN = 6;

// ∆‰À˚≥£ ˝
const int MAX_GEN_MOVES = 128; // ◊Ó¥Ûµƒ…˙≥…◊ﬂ∑® ˝
const int MAX_MOVES = 256;     // ◊Ó¥Ûµƒ¿˙ ∑◊ﬂ∑® ˝
const int LIMIT_DEPTH = 64;    // ◊Ó¥ÛµƒÀ—À˜…Ó∂»
const int MATE_VALUE = 10000;  // ◊Ó∏ﬂ∑÷÷µ£¨º¥Ω´À¿µƒ∑÷÷µ
const int BAN_VALUE = MATE_VALUE - 100; // ≥§Ω´≈–∏∫µƒ∑÷÷µ£¨µÕ”⁄∏√÷µΩ´≤ª–¥»Î÷√ªª±Ì
const int WIN_VALUE = MATE_VALUE - 200; // À—À˜≥ˆ §∏∫µƒ∑÷÷µΩÁœﬁ£¨≥¨≥ˆ¥À÷µæÕÀµ√˜“—æ≠À—À˜≥ˆ…±∆Â¡À
const int DRAW_VALUE = 20;     // ∫Õ∆Â ±∑µªÿµƒ∑÷ ˝(»°∏∫÷µ)
const int ADVANCED_VALUE = 3;  // œ»––»®∑÷÷µ
const int RANDOM_MASK = 7;     // ÀÊª˙–‘∑÷÷µ
const int NULL_MARGIN = 400;   // ø’≤Ω≤√ºÙµƒ◊”¡¶±ﬂΩÁ
const int NULL_DEPTH = 2;      // ø’≤Ω≤√ºÙµƒ≤√ºÙ…Ó∂»
const int HASH_SIZE = 1 << 20; // ÷√ªª±Ì¥Û–°
const int HASH_ALPHA = 1;      // ALPHAΩ⁄µ„µƒ÷√ªª±ÌœÓ
const int HASH_BETA = 2;       // BETAΩ⁄µ„µƒ÷√ªª±ÌœÓ
const int HASH_PV = 3;         // PVΩ⁄µ„µƒ÷√ªª±ÌœÓ
const int BOOK_SIZE = 16384;   // ø™æ÷ø‚¥Û–°

// ≈–∂œ∆Â◊” «∑Ò‘⁄∆Â≈Ã÷–µƒ ˝◊È
static const char ccInBoard[256] = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
  0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
  0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
  0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
  0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
  0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
  0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
  0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
  0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
  0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

// ≈–∂œ∆Â◊” «∑Ò‘⁄æ≈π¨µƒ ˝◊È
static const char ccInFort[256] = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

// ≈–∂œ≤Ω≥§ «∑Ò∑˚∫œÃÿ∂®◊ﬂ∑®µƒ ˝◊È£¨1=Àß(Ω´)£¨2= À( ø)£¨3=œ‡(œÛ)
static const char ccLegalSpan[512] = {
                       0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 2, 1, 2, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 2, 1, 2, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0
};

// ∏˘æ›≤Ω≥§≈–∂œ¬Ì «∑ÒıøÕ»µƒ ˝◊È
static const char ccKnightPin[512] = {
                              0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,-16,  0,-16,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0, -1,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0, -1,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0, 16,  0, 16,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0
};

// Àß(Ω´)µƒ≤Ω≥§
static const char ccKingDelta[4] = {-16, -1, 1, 16};
//  À( ø)µƒ≤Ω≥§
static const char ccAdvisorDelta[4] = {-17, -15, 15, 17};
// ¬Ìµƒ≤Ω≥§£¨“‘Àß(Ω´)µƒ≤Ω≥§◊˜Œ™¬ÌÕ»
static const char ccKnightDelta[4][2] = {{-33, -31}, {-18, 14}, {-14, 18}, {31, 33}};
// ¬Ì±ªΩ´æ¸µƒ≤Ω≥§£¨“‘ À( ø)µƒ≤Ω≥§◊˜Œ™¬ÌÕ»
static const char ccKnightCheckDelta[4][2] = {{-33, -18}, {-31, -14}, {14, 31}, {18, 33}};

// ∆Â≈Ã≥ı º…Ë÷√
static const BYTE cucpcStartup[256] = {
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0, 20, 19, 18, 17, 16, 17, 18, 19, 20,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0, 21,  0,  0,  0,  0,  0, 21,  0,  0,  0,  0,  0,
  0,  0,  0, 22,  0, 22,  0, 22,  0, 22,  0, 22,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0, 14,  0, 14,  0, 14,  0, 14,  0, 14,  0,  0,  0,  0,
  0,  0,  0,  0, 13,  0,  0,  0,  0,  0, 13,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0, 12, 11, 10,  9,  8,  9, 10, 11, 12,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
};

// ◊”¡¶Œª÷√º€÷µ±Ì
static const BYTE cucvlPiecePos[7][256] = {
  { // Àß(Ω´)
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  2,  2,  2,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0, 11, 15, 11,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
  }, { //  À( ø)
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0, 20,  0, 20,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0, 23,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0, 20,  0, 20,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
  }, { // œ‡(œÛ)
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0, 20,  0,  0,  0, 20,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0, 18,  0,  0,  0, 23,  0,  0,  0, 18,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0, 20,  0,  0,  0, 20,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
  }, { // ¬Ì
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0, 90, 90, 90, 96, 90, 96, 90, 90, 90,  0,  0,  0,  0,
    0,  0,  0, 90, 96,103, 97, 94, 97,103, 96, 90,  0,  0,  0,  0,
    0,  0,  0, 92, 98, 99,103, 99,103, 99, 98, 92,  0,  0,  0,  0,
    0,  0,  0, 93,108,100,107,100,107,100,108, 93,  0,  0,  0,  0,
    0,  0,  0, 90,100, 99,103,104,103, 99,100, 90,  0,  0,  0,  0,
    0,  0,  0, 90, 98,101,102,103,102,101, 98, 90,  0,  0,  0,  0,
    0,  0,  0, 92, 94, 98, 95, 98, 95, 98, 94, 92,  0,  0,  0,  0,
    0,  0,  0, 93, 92, 94, 95, 92, 95, 94, 92, 93,  0,  0,  0,  0,
    0,  0,  0, 85, 90, 92, 93, 78, 93, 92, 90, 85,  0,  0,  0,  0,
    0,  0,  0, 88, 85, 90, 88, 90, 88, 90, 85, 88,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
  }, { // ≥µ
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,206,208,207,213,214,213,207,208,206,  0,  0,  0,  0,
    0,  0,  0,206,212,209,216,233,216,209,212,206,  0,  0,  0,  0,
    0,  0,  0,206,208,207,214,216,214,207,208,206,  0,  0,  0,  0,
    0,  0,  0,206,213,213,216,216,216,213,213,206,  0,  0,  0,  0,
    0,  0,  0,208,211,211,214,215,214,211,211,208,  0,  0,  0,  0,
    0,  0,  0,208,212,212,214,215,214,212,212,208,  0,  0,  0,  0,
    0,  0,  0,204,209,204,212,214,212,204,209,204,  0,  0,  0,  0,
    0,  0,  0,198,208,204,212,212,212,204,208,198,  0,  0,  0,  0,
    0,  0,  0,200,208,206,212,200,212,206,208,200,  0,  0,  0,  0,
    0,  0,  0,194,206,204,212,200,212,204,206,194,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
  }, { // ≈⁄
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,100,100, 96, 91, 90, 91, 96,100,100,  0,  0,  0,  0,
    0,  0,  0, 98, 98, 96, 92, 89, 92, 96, 98, 98,  0,  0,  0,  0,
    0,  0,  0, 97, 97, 96, 91, 92, 91, 96, 97, 97,  0,  0,  0,  0,
    0,  0,  0, 96, 99, 99, 98,100, 98, 99, 99, 96,  0,  0,  0,  0,
    0,  0,  0, 96, 96, 96, 96,100, 96, 96, 96, 96,  0,  0,  0,  0,
    0,  0,  0, 95, 96, 99, 96,100, 96, 99, 96, 95,  0,  0,  0,  0,
    0,  0,  0, 96, 96, 96, 96, 96, 96, 96, 96, 96,  0,  0,  0,  0,
    0,  0,  0, 97, 96,100, 99,101, 99,100, 96, 97,  0,  0,  0,  0,
    0,  0,  0, 96, 97, 98, 98, 98, 98, 98, 97, 96,  0,  0,  0,  0,
    0,  0,  0, 96, 96, 97, 99, 99, 99, 97, 96, 96,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
  }, { // ±¯(◊‰)
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  9,  9,  9, 11, 13, 11,  9,  9,  9,  0,  0,  0,  0,
    0,  0,  0, 19, 24, 34, 42, 44, 42, 34, 24, 19,  0,  0,  0,  0,
    0,  0,  0, 19, 24, 32, 37, 37, 37, 32, 24, 19,  0,  0,  0,  0,
    0,  0,  0, 19, 23, 27, 29, 30, 29, 27, 23, 19,  0,  0,  0,  0,
    0,  0,  0, 14, 18, 20, 27, 29, 27, 20, 18, 14,  0,  0,  0,  0,
    0,  0,  0,  7,  0, 13,  0, 16,  0, 13,  0,  7,  0,  0,  0,  0,
    0,  0,  0,  7,  0,  7,  0, 15,  0,  7,  0,  7,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
  }
};

// ≈–∂œ∆Â◊” «∑Ò‘⁄∆Â≈Ã÷–
inline BOOL IN_BOARD(int sq) {
  return ccInBoard[sq] != 0;
}

// ≈–∂œ∆Â◊” «∑Ò‘⁄æ≈π¨÷–
inline BOOL IN_FORT(int sq) {
  return ccInFort[sq] != 0;
}

// ªÒµ√∏Ò◊”µƒ∫·◊¯±Í
inline int RANK_Y(int sq) {
  return sq >> 4;
}

// ªÒµ√∏Ò◊”µƒ◊›◊¯±Í
inline int FILE_X(int sq) {
  return sq & 15;
}

// ∏˘æ›◊›◊¯±Í∫Õ∫·◊¯±ÍªÒµ√∏Ò◊”
inline int COORD_XY(int x, int y) {
  return x + (y << 4);
}

// ∑≠◊™∏Ò◊”
inline int SQUARE_FLIP(int sq) {
  return 254 - sq;
}

// ◊›◊¯±ÍÀÆ∆ΩæµœÒ
inline int FILE_FLIP(int x) {
  return 14 - x;
}

// ∫·◊¯±Í¥π÷±æµœÒ
inline int RANK_FLIP(int y) {
  return 15 - y;
}

// ∏Ò◊”ÀÆ∆ΩæµœÒ
inline int MIRROR_SQUARE(int sq) {
  return COORD_XY(FILE_FLIP(FILE_X(sq)), RANK_Y(sq));
}

// ∏Ò◊”ÀÆ∆ΩæµœÒ
inline int SQUARE_FORWARD(int sq, int sd) {
  return sq - 16 + (sd << 5);
}

// ◊ﬂ∑® «∑Ò∑˚∫œÀß(Ω´)µƒ≤Ω≥§
inline BOOL KING_SPAN(int sqSrc, int sqDst) {
  return ccLegalSpan[sqDst - sqSrc + 256] == 1;
}

// ◊ﬂ∑® «∑Ò∑˚∫œ À( ø)µƒ≤Ω≥§
inline BOOL ADVISOR_SPAN(int sqSrc, int sqDst) {
  return ccLegalSpan[sqDst - sqSrc + 256] == 2;
}

// ◊ﬂ∑® «∑Ò∑˚∫œœ‡(œÛ)µƒ≤Ω≥§
inline BOOL BISHOP_SPAN(int sqSrc, int sqDst) {
  return ccLegalSpan[sqDst - sqSrc + 256] == 3;
}

// œ‡(œÛ)—€µƒŒª÷√
inline int BISHOP_PIN(int sqSrc, int sqDst) {
  return (sqSrc + sqDst) >> 1;
}

// ¬ÌÕ»µƒŒª÷√
inline int KNIGHT_PIN(int sqSrc, int sqDst) {
  return sqSrc + ccKnightPin[sqDst - sqSrc + 256];
}

//  «∑ÒŒ¥π˝∫”
inline BOOL HOME_HALF(int sq, int sd) {
  return (sq & 0x80) != (sd << 7);
}

//  «∑Ò“—π˝∫”
inline BOOL AWAY_HALF(int sq, int sd) {
  return (sq & 0x80) == (sd << 7);
}

//  «∑Ò‘⁄∫”µƒÕ¨“ª±ﬂ
inline BOOL SAME_HALF(int sqSrc, int sqDst) {
  return ((sqSrc ^ sqDst) & 0x80) == 0;
}

//  «∑Ò‘⁄Õ¨“ª––
inline BOOL SAME_RANK(int sqSrc, int sqDst) {
  return ((sqSrc ^ sqDst) & 0xf0) == 0;
}

//  «∑Ò‘⁄Õ¨“ª¡–
inline BOOL SAME_FILE(int sqSrc, int sqDst) {
  return ((sqSrc ^ sqDst) & 0x0f) == 0;
}

// ªÒµ√∫Ï∫⁄±Íº«(∫Ï◊” «8£¨∫⁄◊” «16)
inline int SIDE_TAG(int sd) {
  return 8 + (sd << 3);
}

// ªÒµ√∂‘∑Ω∫Ï∫⁄±Íº«
inline int OPP_SIDE_TAG(int sd) {
  return 16 - (sd << 3);
}

// ªÒµ√◊ﬂ∑®µƒ∆µ„
inline int SRC(int mv) {
  return mv & 255;
}

// ªÒµ√◊ﬂ∑®µƒ÷’µ„
inline int DST(int mv) {
  return mv >> 8;
}

// ∏˘æ›∆µ„∫Õ÷’µ„ªÒµ√◊ﬂ∑®
inline int MOVE(int sqSrc, int sqDst) {
  return sqSrc + sqDst * 256;
}

// ◊ﬂ∑®ÀÆ∆ΩæµœÒ
inline int MIRROR_MOVE(int mv) {
  return MOVE(MIRROR_SQUARE(SRC(mv)), MIRROR_SQUARE(DST(mv)));
}

// RC4√‹¬Î¡˜…˙≥…∆˜
struct RC4Struct {
  BYTE s[256];
  int x, y;

  void InitZero(void);   // ”√ø’√‹‘ø≥ı ºªØ√‹¬Î¡˜…˙≥…∆˜
  BYTE NextByte(void) {  // …˙≥…√‹¬Î¡˜µƒœ¬“ª∏ˆ◊÷Ω⁄
    BYTE uc;
    x = (x + 1) & 255;
    y = (y + s[x]) & 255;
    uc = s[x];
    s[x] = s[y];
    s[y] = uc;
    return s[(s[x] + s[y]) & 255];
  }
  DWORD NextLong(void) { // …˙≥…√‹¬Î¡˜µƒœ¬Àƒ∏ˆ◊÷Ω⁄
    BYTE uc0, uc1, uc2, uc3;
    uc0 = NextByte();
    uc1 = NextByte();
    uc2 = NextByte();
    uc3 = NextByte();
    return uc0 + (uc1 << 8) + (uc2 << 16) + (uc3 << 24);
  }
};

// ”√ø’√‹‘ø≥ı ºªØ√‹¬Î¡˜…˙≥…∆˜
void RC4Struct::InitZero(void) {
  int i, j;
  BYTE uc;

  x = y = j = 0;
  for (i = 0; i < 256; i ++) {
    s[i] = i;
  }
  for (i = 0; i < 256; i ++) {
    j = (j + s[i]) & 255;
    uc = s[i];
    s[i] = s[j];
    s[j] = uc;
  }
}

// ZobristΩ·ππ
struct ZobristStruct {
  DWORD dwKey, dwLock0, dwLock1;

  void InitZero(void) {                 // ”√¡„ÃÓ≥‰Zobrist
    dwKey = dwLock0 = dwLock1 = 0;
  }
  void InitRC4(RC4Struct &rc4) {        // ”√√‹¬Î¡˜ÃÓ≥‰Zobrist
    dwKey = rc4.NextLong();
    dwLock0 = rc4.NextLong();
    dwLock1 = rc4.NextLong();
  }
  void Xor(const ZobristStruct &zobr) { // ÷¥––XOR≤Ÿ◊˜
    dwKey ^= zobr.dwKey;
    dwLock0 ^= zobr.dwLock0;
    dwLock1 ^= zobr.dwLock1;
  }
  void Xor(const ZobristStruct &zobr1, const ZobristStruct &zobr2) {
    dwKey ^= zobr1.dwKey ^ zobr2.dwKey;
    dwLock0 ^= zobr1.dwLock0 ^ zobr2.dwLock0;
    dwLock1 ^= zobr1.dwLock1 ^ zobr2.dwLock1;
  }
};

// Zobrist±Ì
static struct {
  ZobristStruct Player;
  ZobristStruct Table[14][256];
} Zobrist;

// ≥ı ºªØZobrist±Ì
static void InitZobrist(void) {
  int i, j;
  RC4Struct rc4;

  rc4.InitZero();
  Zobrist.Player.InitRC4(rc4);
  for (i = 0; i < 14; i ++) {
    for (j = 0; j < 256; j ++) {
      Zobrist.Table[i][j].InitRC4(rc4);
    }
  }
}

// ¿˙ ∑◊ﬂ∑®–≈œ¢(’º4◊÷Ω⁄)
struct MoveStruct {
  WORD wmv;
  BYTE ucpcCaptured, ucbCheck;
  DWORD dwKey;

  void Set(int mv, int pcCaptured, BOOL bCheck, DWORD dwKey_) {
    wmv = mv;
    ucpcCaptured = pcCaptured;
    ucbCheck = bCheck;
    dwKey = dwKey_;
  }
}; // mvs

// æ÷√ÊΩ·ππ
struct PositionStruct {
  int sdPlayer;                   // ¬÷µΩÀ≠◊ﬂ£¨0=∫Ï∑Ω£¨1=∫⁄∑Ω
  BYTE ucpcSquares[256];          // ∆Â≈Ã…œµƒ∆Â◊”
  int vlWhite, vlBlack;           // ∫Ï°¢∫⁄À´∑Ωµƒ◊”¡¶º€÷µ
  int nDistance, nMoveNum;        // æ‡¿Î∏˘Ω⁄µ„µƒ≤Ω ˝£¨¿˙ ∑◊ﬂ∑® ˝
  MoveStruct mvsList[MAX_MOVES];  // ¿˙ ∑◊ﬂ∑®–≈œ¢¡–±Ì
  ZobristStruct zobr;             // Zobrist

  void ClearBoard(void) {         // «Âø’∆Â≈Ã
    sdPlayer = vlWhite = vlBlack = nDistance = 0;
    memset(ucpcSquares, 0, 256);
    zobr.InitZero();
  }
  void SetIrrev(void) {           // «Âø’(≥ı ºªØ)¿˙ ∑◊ﬂ∑®–≈œ¢
    mvsList[0].Set(0, 0, Checked(), zobr.dwKey);
    nMoveNum = 1;
  }
  void Startup(unsigned char board[10][9]);             // ≥ı ºªØ∆Â≈Ã
  void ChangeSide(void) {         // Ωªªª◊ﬂ◊”∑Ω
    sdPlayer = 1 - sdPlayer;
    zobr.Xor(Zobrist.Player);
  }
  void AddPiece(int sq, int pc) { // ‘⁄∆Â≈Ã…œ∑≈“ª√∂∆Â◊”
    ucpcSquares[sq] = pc;
    // ∫Ï∑Ωº”∑÷£¨∫⁄∑Ω(◊¢“‚"cucvlPiecePos"»°÷µ“™µﬂµπ)ºı∑÷
    if (pc < 16) {
      vlWhite += cucvlPiecePos[pc - 8][sq];
      zobr.Xor(Zobrist.Table[pc - 8][sq]);
    } else {
      vlBlack += cucvlPiecePos[pc - 16][SQUARE_FLIP(sq)];
      zobr.Xor(Zobrist.Table[pc - 9][sq]);
    }
  }
  void DelPiece(int sq, int pc) { // ¥”∆Â≈Ã…œƒ√◊ﬂ“ª√∂∆Â◊”
    ucpcSquares[sq] = 0;
    // ∫Ï∑Ωºı∑÷£¨∫⁄∑Ω(◊¢“‚"cucvlPiecePos"»°÷µ“™µﬂµπ)º”∑÷
    if (pc < 16) {
      vlWhite -= cucvlPiecePos[pc - 8][sq];
      zobr.Xor(Zobrist.Table[pc - 8][sq]);
    } else {
      vlBlack -= cucvlPiecePos[pc - 16][SQUARE_FLIP(sq)];
      zobr.Xor(Zobrist.Table[pc - 9][sq]);
    }
  }
  int Evaluate(void) const {      // æ÷√Ê∆¿º€∫Ø ˝
    return (sdPlayer == 0 ? vlWhite - vlBlack : vlBlack - vlWhite) + ADVANCED_VALUE;
  }
  BOOL InCheck(void) const {      //  «∑Ò±ªΩ´æ¸
    return mvsList[nMoveNum - 1].ucbCheck;
  }
  BOOL Captured(void) const {     // …œ“ª≤Ω «∑Ò≥‘◊”
    return mvsList[nMoveNum - 1].ucpcCaptured != 0;
  }
  int MovePiece(int mv);                      // ∞·“ª≤Ω∆Âµƒ∆Â◊”
  void UndoMovePiece(int mv, int pcCaptured); // ≥∑œ˚∞·“ª≤Ω∆Âµƒ∆Â◊”
  BOOL MakeMove(int mv, int* ppcCaptured = NULL);            // ◊ﬂ“ª≤Ω∆Â
  void UndoMakeMove(void) {                   // ≥∑œ˚◊ﬂ“ª≤Ω∆Â
    nDistance --;
    nMoveNum --;
    ChangeSide();
    UndoMovePiece(mvsList[nMoveNum].wmv, mvsList[nMoveNum].ucpcCaptured);
  }
  void NullMove(void) {                       // ◊ﬂ“ª≤Ωø’≤Ω
    DWORD dwKey;
    dwKey = zobr.dwKey;
    ChangeSide();
    mvsList[nMoveNum].Set(0, 0, FALSE, dwKey);
    nMoveNum ++;
    nDistance ++;
  }
  void UndoNullMove(void) {                   // ≥∑œ˚◊ﬂ“ª≤Ωø’≤Ω
    nDistance --;
    nMoveNum --;
    ChangeSide();
  }
  // …˙≥…À˘”–◊ﬂ∑®£¨»Áπ˚"bCapture"Œ™"TRUE"‘Ú÷ª…˙≥…≥‘◊”◊ﬂ∑®
  int GenerateMoves(int *mvs, BOOL bCapture = FALSE) const;
  int GenerateMovesFrom(int sqSrc, int *mvs, BOOL bCapture = FALSE) const;
  BOOL LegalMove(int mv) const;               // ≈–∂œ◊ﬂ∑® «∑Ò∫œ¿Ì
  BOOL Checked(void) const;                   // ≈–∂œ «∑Ò±ªΩ´æ¸
  BOOL IsMate(void);                          // ≈–∂œ «∑Ò±ª…±
  int DrawValue(void) const {                 // ∫Õ∆Â∑÷÷µ
    return (nDistance & 1) == 0 ? -DRAW_VALUE : DRAW_VALUE;
  }
  int RepStatus(int nRecur = 1) const;        // ºÏ≤‚÷ÿ∏¥æ÷√Ê
  int RepValue(int nRepStatus) const {        // ÷ÿ∏¥æ÷√Ê∑÷÷µ
    int vlReturn;
    vlReturn = ((nRepStatus & 2) == 0 ? 0 : nDistance - BAN_VALUE) +
        ((nRepStatus & 4) == 0 ? 0 : BAN_VALUE - nDistance);
    return vlReturn == 0 ? DrawValue() : vlReturn;
  }
  BOOL NullOkay(void) const {                 // ≈–∂œ «∑Ò‘ –Ìø’≤Ω≤√ºÙ
    return (sdPlayer == 0 ? vlWhite : vlBlack) > NULL_MARGIN;
  }
  void Mirror(PositionStruct &posMirror) const; // ∂‘æ÷√ÊæµœÒ
};

// ≥ı ºªØ∆Â≈Ã
void PositionStruct::Startup(unsigned char board[10][9]) {
  int sq;
  ClearBoard();
  if ( board != NULL )
  {
      for (int i = 0; i<10;i++)
	      for (int j = 0; j <9; j++){
		      if (board[i][j] > 0){
			      sq = (3+i)*16 + 3 + j;
			      AddPiece(sq, board[i][j]);
		      }
	      }
  }
  else
  {
      int pc;
      for (sq = 0; sq < 256; sq ++) {
        pc = cucpcStartup[sq];
        if (pc != 0) {
          AddPiece(sq, pc);
        }
      }
  }
  SetIrrev();
}

// ∞·“ª≤Ω∆Âµƒ∆Â◊”
int PositionStruct::MovePiece(int mv) {
  int sqSrc, sqDst, pc, pcCaptured;
  sqSrc = SRC(mv);
  sqDst = DST(mv);
  pcCaptured = ucpcSquares[sqDst];
  if (pcCaptured != 0) {
    DelPiece(sqDst, pcCaptured);
  }
  pc = ucpcSquares[sqSrc];
  DelPiece(sqSrc, pc);
  AddPiece(sqDst, pc);
  return pcCaptured;
}

// ≥∑œ˚∞·“ª≤Ω∆Âµƒ∆Â◊”
void PositionStruct::UndoMovePiece(int mv, int pcCaptured) {
  int sqSrc, sqDst, pc;
  sqSrc = SRC(mv);
  sqDst = DST(mv);
  pc = ucpcSquares[sqDst];
  DelPiece(sqDst, pc);
  AddPiece(sqSrc, pc);
  if (pcCaptured != 0) {
    AddPiece(sqDst, pcCaptured);
  }
}

// ◊ﬂ“ª≤Ω∆Â
BOOL PositionStruct::MakeMove(int mv, int* ppcCaptured /*= NULL*/) {
  int pcCaptured;
  DWORD dwKey;

  dwKey = zobr.dwKey;
  pcCaptured = MovePiece(mv);
  if (Checked()) {
    UndoMovePiece(mv, pcCaptured);
    return FALSE;
  }
  ChangeSide();
  mvsList[nMoveNum].Set(mv, pcCaptured, Checked(), dwKey);
  nMoveNum ++;
  nDistance ++;
    
  // (HPHAN) Return the captured piece as well.
  if ( ppcCaptured != NULL ) {
    *ppcCaptured = pcCaptured;
  }
  return TRUE;
}

// "GenerateMoves"≤Œ ˝
const BOOL GEN_CAPTURE = TRUE;

int PositionStruct::GenerateMoves(int *mvs, BOOL bCapture) const {
    int nGenMoves = 0;
    int nMoves = 0;
    int *startMvs = mvs;
    for (int sqSrc = 0; sqSrc < 256; sqSrc++) {
        nMoves = GenerateMovesFrom(sqSrc, startMvs, bCapture);
        if (nMoves > 0) {
            nGenMoves += nMoves;
            startMvs += nMoves;
        }
    }
    return nGenMoves;
}

// …˙≥…À˘”–◊ﬂ∑®£¨»Áπ˚"bCapture"Œ™"TRUE"‘Ú÷ª…˙≥…≥‘◊”◊ﬂ∑®
int PositionStruct::GenerateMovesFrom(int sqSrc, int *mvs, BOOL bCapture) const {
  int i, j, nGenMoves, nDelta, sqDst;
  int pcSelfSide, pcOppSide, pcSrc, pcDst;
  // …˙≥…À˘”–◊ﬂ∑®£¨–Ë“™æ≠π˝“‘œ¬º∏∏ˆ≤Ω÷Ë£∫

  nGenMoves = 0;
  pcSelfSide = SIDE_TAG(sdPlayer);
  pcOppSide = OPP_SIDE_TAG(sdPlayer);
  if (sqSrc >= 0 && sqSrc < 256) {

    // 1. ’“µΩ“ª∏ˆ±æ∑Ω∆Â◊”£¨‘Ÿ◊ˆ“‘œ¬≈–∂œ£∫
    pcSrc = ucpcSquares[sqSrc];
    if ((pcSrc & pcSelfSide) == 0) {
      return nGenMoves;
    }

    // 2. ∏˘æ›∆Â◊”»∑∂®◊ﬂ∑®
    switch (pcSrc - pcSelfSide) {
    case PIECE_KING:
      for (i = 0; i < 4; i ++) {
        sqDst = sqSrc + ccKingDelta[i];
        if (!IN_FORT(sqDst)) {
          continue;
        }
        pcDst = ucpcSquares[sqDst];
        if (bCapture ? (pcDst & pcOppSide) != 0 : (pcDst & pcSelfSide) == 0) {
          mvs[nGenMoves] = MOVE(sqSrc, sqDst);
          nGenMoves ++;
        }
      }
      break;
    case PIECE_ADVISOR:
      for (i = 0; i < 4; i ++) {
        sqDst = sqSrc + ccAdvisorDelta[i];
        if (!IN_FORT(sqDst)) {
          continue;
        }
        pcDst = ucpcSquares[sqDst];
        if (bCapture ? (pcDst & pcOppSide) != 0 : (pcDst & pcSelfSide) == 0) {
          mvs[nGenMoves] = MOVE(sqSrc, sqDst);
          nGenMoves ++;
        }
      }
      break;
    case PIECE_BISHOP:
      for (i = 0; i < 4; i ++) {
        sqDst = sqSrc + ccAdvisorDelta[i];
        if (!(IN_BOARD(sqDst) && HOME_HALF(sqDst, sdPlayer) && ucpcSquares[sqDst] == 0)) {
          continue;
        }
        sqDst += ccAdvisorDelta[i];
        pcDst = ucpcSquares[sqDst];
        if (bCapture ? (pcDst & pcOppSide) != 0 : (pcDst & pcSelfSide) == 0) {
          mvs[nGenMoves] = MOVE(sqSrc, sqDst);
          nGenMoves ++;
        }
      }
      break;
    case PIECE_KNIGHT:
      for (i = 0; i < 4; i ++) {
        sqDst = sqSrc + ccKingDelta[i];
        if (ucpcSquares[sqDst] != 0) {
          continue;
        }
        for (j = 0; j < 2; j ++) {
          sqDst = sqSrc + ccKnightDelta[i][j];
          if (!IN_BOARD(sqDst)) {
            continue;
          }
          pcDst = ucpcSquares[sqDst];
          if (bCapture ? (pcDst & pcOppSide) != 0 : (pcDst & pcSelfSide) == 0) {
            mvs[nGenMoves] = MOVE(sqSrc, sqDst);
            nGenMoves ++;
          }
        }
      }
      break;
    case PIECE_ROOK:
      for (i = 0; i < 4; i ++) {
        nDelta = ccKingDelta[i];
        sqDst = sqSrc + nDelta;
        while (IN_BOARD(sqDst)) {
          pcDst = ucpcSquares[sqDst];
          if (pcDst == 0) {
            if (!bCapture) {
              mvs[nGenMoves] = MOVE(sqSrc, sqDst);
              nGenMoves ++;
            }
          } else {
            if ((pcDst & pcOppSide) != 0) {
              mvs[nGenMoves] = MOVE(sqSrc, sqDst);
              nGenMoves ++;
            }
            break;
          }
          sqDst += nDelta;
        }
      }
      break;
    case PIECE_CANNON:
      for (i = 0; i < 4; i ++) {
        nDelta = ccKingDelta[i];
        sqDst = sqSrc + nDelta;
        while (IN_BOARD(sqDst)) {
          pcDst = ucpcSquares[sqDst];
          if (pcDst == 0) {
            if (!bCapture) {
              mvs[nGenMoves] = MOVE(sqSrc, sqDst);
              nGenMoves ++;
            }
          } else {
            break;
          }
          sqDst += nDelta;
        }
        sqDst += nDelta;
        while (IN_BOARD(sqDst)) {
          pcDst = ucpcSquares[sqDst];
          if (pcDst != 0) {
            if ((pcDst & pcOppSide) != 0) {
              mvs[nGenMoves] = MOVE(sqSrc, sqDst);
              nGenMoves ++;
            }
            break;
          }
          sqDst += nDelta;
        }
      }
      break;
    case PIECE_PAWN:
      sqDst = SQUARE_FORWARD(sqSrc, sdPlayer);
      if (IN_BOARD(sqDst)) {
        pcDst = ucpcSquares[sqDst];
        if (bCapture ? (pcDst & pcOppSide) != 0 : (pcDst & pcSelfSide) == 0) {
          mvs[nGenMoves] = MOVE(sqSrc, sqDst);
          nGenMoves ++;
        }
      }
      if (AWAY_HALF(sqSrc, sdPlayer)) {
        for (nDelta = -1; nDelta <= 1; nDelta += 2) {
          sqDst = sqSrc + nDelta;
          if (IN_BOARD(sqDst)) {
            pcDst = ucpcSquares[sqDst];
            if (bCapture ? (pcDst & pcOppSide) != 0 : (pcDst & pcSelfSide) == 0) {
              mvs[nGenMoves] = MOVE(sqSrc, sqDst);
              nGenMoves ++;
            }
          }
        }
      }
      break;
    }
  }
  return nGenMoves;
}

// ≈–∂œ◊ﬂ∑® «∑Ò∫œ¿Ì
BOOL PositionStruct::LegalMove(int mv) const {
  int sqSrc, sqDst, sqPin;
  int pcSelfSide, pcSrc, pcDst, nDelta;
  // ≈–∂œ◊ﬂ∑® «∑Ò∫œ∑®£¨–Ë“™æ≠π˝“‘œ¬µƒ≈–∂œπ˝≥Ã£∫

  // 1. ≈–∂œ∆ º∏Ò «∑Ò”–◊‘º∫µƒ∆Â◊”
  sqSrc = SRC(mv);
  pcSrc = ucpcSquares[sqSrc];
  pcSelfSide = SIDE_TAG(sdPlayer);
  if ((pcSrc & pcSelfSide) == 0) {
    return FALSE;
  }

  // 2. ≈–∂œƒø±Í∏Ò «∑Ò”–◊‘º∫µƒ∆Â◊”
  sqDst = DST(mv);
  pcDst = ucpcSquares[sqDst];
  if ((pcDst & pcSelfSide) != 0) {
    return FALSE;
  }

  // 3. ∏˘æ›∆Â◊”µƒ¿‡–ÕºÏ≤È◊ﬂ∑® «∑Ò∫œ¿Ì
  switch (pcSrc - pcSelfSide) {
  case PIECE_KING:
    return IN_FORT(sqDst) && KING_SPAN(sqSrc, sqDst);
  case PIECE_ADVISOR:
    return IN_FORT(sqDst) && ADVISOR_SPAN(sqSrc, sqDst);
  case PIECE_BISHOP:
    return SAME_HALF(sqSrc, sqDst) && BISHOP_SPAN(sqSrc, sqDst) &&
        ucpcSquares[BISHOP_PIN(sqSrc, sqDst)] == 0;
  case PIECE_KNIGHT:
    sqPin = KNIGHT_PIN(sqSrc, sqDst);
    return sqPin != sqSrc && ucpcSquares[sqPin] == 0;
  case PIECE_ROOK:
  case PIECE_CANNON:
    if (SAME_RANK(sqSrc, sqDst)) {
      nDelta = (sqDst < sqSrc ? -1 : 1);
    } else if (SAME_FILE(sqSrc, sqDst)) {
      nDelta = (sqDst < sqSrc ? -16 : 16);
    } else {
      return FALSE;
    }
    sqPin = sqSrc + nDelta;
    while (sqPin != sqDst && ucpcSquares[sqPin] == 0) {
      sqPin += nDelta;
    }
    if (sqPin == sqDst) {
      return pcDst == 0 || pcSrc - pcSelfSide == PIECE_ROOK;
    } else if (pcDst != 0 && pcSrc - pcSelfSide == PIECE_CANNON) {
      sqPin += nDelta;
      while (sqPin != sqDst && ucpcSquares[sqPin] == 0) {
        sqPin += nDelta;
      }
      return sqPin == sqDst;
    } else {
      return FALSE;
    }
  case PIECE_PAWN:
    if (AWAY_HALF(sqDst, sdPlayer) && (sqDst == sqSrc - 1 || sqDst == sqSrc + 1)) {
      return TRUE;
    }
    return sqDst == SQUARE_FORWARD(sqSrc, sdPlayer);
  default:
    return FALSE;
  }
}

// ≈–∂œ «∑Ò±ªΩ´æ¸
BOOL PositionStruct::Checked() const {
  int i, j, sqSrc, sqDst;
  int pcSelfSide, pcOppSide, pcDst, nDelta;
  pcSelfSide = SIDE_TAG(sdPlayer);
  pcOppSide = OPP_SIDE_TAG(sdPlayer);
  // ’“µΩ∆Â≈Ã…œµƒÀß(Ω´)£¨‘Ÿ◊ˆ“‘œ¬≈–∂œ£∫

  for (sqSrc = 0; sqSrc < 256; sqSrc ++) {
    if (ucpcSquares[sqSrc] != pcSelfSide + PIECE_KING) {
      continue;
    }

    // 1. ≈–∂œ «∑Ò±ª∂‘∑Ωµƒ±¯(◊‰)Ω´æ¸
    if (ucpcSquares[SQUARE_FORWARD(sqSrc, sdPlayer)] == pcOppSide + PIECE_PAWN) {
      return TRUE;
    }
    for (nDelta = -1; nDelta <= 1; nDelta += 2) {
      if (ucpcSquares[sqSrc + nDelta] == pcOppSide + PIECE_PAWN) {
        return TRUE;
      }
    }

    // 2. ≈–∂œ «∑Ò±ª∂‘∑Ωµƒ¬ÌΩ´æ¸(“‘ À( ø)µƒ≤Ω≥§µ±◊˜¬ÌÕ»)
    for (i = 0; i < 4; i ++) {
      if (ucpcSquares[sqSrc + ccAdvisorDelta[i]] != 0) {
        continue;
      }
      for (j = 0; j < 2; j ++) {
        pcDst = ucpcSquares[sqSrc + ccKnightCheckDelta[i][j]];
        if (pcDst == pcOppSide + PIECE_KNIGHT) {
          return TRUE;
        }
      }
    }

    // 3. ≈–∂œ «∑Ò±ª∂‘∑Ωµƒ≥µªÚ≈⁄Ω´æ¸(∞¸¿®Ω´Àß∂‘¡≥)
    for (i = 0; i < 4; i ++) {
      nDelta = ccKingDelta[i];
      sqDst = sqSrc + nDelta;
      while (IN_BOARD(sqDst)) {
        pcDst = ucpcSquares[sqDst];
        if (pcDst != 0) {
          if (pcDst == pcOppSide + PIECE_ROOK || pcDst == pcOppSide + PIECE_KING) {
            return TRUE;
          }
          break;
        }
        sqDst += nDelta;
      }
      sqDst += nDelta;
      while (IN_BOARD(sqDst)) {
        int pcDst = ucpcSquares[sqDst];
        if (pcDst != 0) {
          if (pcDst == pcOppSide + PIECE_CANNON) {
            return TRUE;
          }
          break;
        }
        sqDst += nDelta;
      }
    }
    return FALSE;
  }
  return FALSE;
}

// ≈–∂œ «∑Ò±ª…±
BOOL PositionStruct::IsMate(void) {
  int i, nGenMoveNum, pcCaptured;
  int mvs[MAX_GEN_MOVES];

  nGenMoveNum = GenerateMoves(mvs);
  for (i = 0; i < nGenMoveNum; i ++) {
    pcCaptured = MovePiece(mvs[i]);
    if (!Checked()) {
      UndoMovePiece(mvs[i], pcCaptured);
      return FALSE;
    } else {
      UndoMovePiece(mvs[i], pcCaptured);
    }
  }
  return TRUE;
}

// ºÏ≤‚÷ÿ∏¥æ÷√Ê
int PositionStruct::RepStatus(int nRecur) const {
  BOOL bSelfSide, bPerpCheck, bOppPerpCheck;
  const MoveStruct *lpmvs;

  bSelfSide = FALSE;
  bPerpCheck = bOppPerpCheck = TRUE;
  lpmvs = mvsList + nMoveNum - 1;
  while (lpmvs->wmv != 0 && lpmvs->ucpcCaptured == 0) {
    if (bSelfSide) {
      bPerpCheck = bPerpCheck && lpmvs->ucbCheck;
      if (lpmvs->dwKey == zobr.dwKey) {
        nRecur --;
        if (nRecur == 0) {
          return 1 + (bPerpCheck ? 2 : 0) + (bOppPerpCheck ? 4 : 0);
        }
      }
    } else {
      bOppPerpCheck = bOppPerpCheck && lpmvs->ucbCheck;
    }
    bSelfSide = !bSelfSide;
    lpmvs --;
  }
  return 0;
}

// ∂‘æ÷√ÊæµœÒ
void PositionStruct::Mirror(PositionStruct &posMirror) const {
  int sq, pc;
  posMirror.ClearBoard();
  for (sq = 0; sq < 256; sq ++) {
    pc = ucpcSquares[sq];
    if (pc != 0) {
      posMirror.AddPiece(MIRROR_SQUARE(sq), pc);
    }
  }
  if (sdPlayer == 1) {
    posMirror.ChangeSide();
  }
  posMirror.SetIrrev();
}

static PositionStruct pos; // æ÷√Ê µ¿˝

// ”ÎÕº–ŒΩÁ√Ê”–πÿµƒ»´æ÷±‰¡ø
#if 0
static struct {
  HINSTANCE hInst;                              // ”¶”√≥Ã–Úæ‰±˙ µ¿˝
  HWND hWnd;                                    // ÷˜¥∞ø⁄æ‰±˙
  HDC hdc, hdcTmp;                              // …Ë±∏æ‰±˙£¨÷ª‘⁄"ClickSquare"π˝≥Ã÷–”––ß
  HBITMAP bmpBoard, bmpSelected, bmpPieces[24]; // ◊ ‘¥Õº∆¨æ‰±˙
  int sqSelected, mvLast;                       // —°÷–µƒ∏Ò◊”£¨…œ“ª≤Ω∆Â
  BOOL bFlipped, bGameOver;                     //  «∑Ò∑≠◊™∆Â≈Ã£¨ «∑Ò”Œœ∑Ω· ¯(≤ª»√ºÃ–¯ÕÊœ¬»•)
} Xqwl;
#endif

// ÷√ªª±ÌœÓΩ·ππ
struct HashItem {
  BYTE ucDepth, ucFlag;
  short svl;
  WORD wmv, wReserved;
  DWORD dwLock0, dwLock1;
};

// ø™æ÷ø‚œÓΩ·ππ
struct BookItem {
  DWORD dwLock;
  WORD wmv, wvl;
};

// ”ÎÀ—À˜”–πÿµƒ»´æ÷±‰¡ø
static struct {
  int mvResult;                  // µÁƒ‘◊ﬂµƒ∆Â
  int nHistoryTable[65536];      // ¿˙ ∑±Ì
  int mvKillers[LIMIT_DEPTH][2]; // …± ÷◊ﬂ∑®±Ì
  HashItem HashTable[HASH_SIZE]; // ÷√ªª±Ì
  int nBookSize;                 // ø™æ÷ø‚¥Û–°
  BookItem BookTable[BOOK_SIZE]; // ø™æ÷ø‚
} Search;

// ◊∞»Îø™æ÷ø‚

#include <fstream>   // file I/O
#include <iomanip>
static void LoadBook(const char *opening_book) {
    /* CREDITS:
     *    How to read in an entire binary file
     *        http://www.cplusplus.com/doc/tutorial/files.html
     */

    using namespace std;
    ifstream fp_in;  // declarations of streams fp_in and fp_out
    fp_in.open(opening_book, ios::in|ios::binary|ios::ate);
                                // open and read til END
    if (!fp_in.is_open()) {
        return;
    }

    ifstream::pos_type size = fp_in.tellg();
    Search.nBookSize = (int)(size / sizeof(BookItem));
    if (Search.nBookSize > BOOK_SIZE) {
      Search.nBookSize = BOOK_SIZE;
    }
    bzero(Search.BookTable, BOOK_SIZE * sizeof(BookItem));
    fp_in.seekg (0, ios::beg);
    fp_in.read ((char*)Search.BookTable, Search.nBookSize * sizeof(BookItem));
    fp_in.close();   // close the streams
#ifdef DEBUG
    printf("%s: Success opening book Size = [%d (of %u)].\n",
        __func__, Search.nBookSize, (unsigned int)sizeof(BookItem));
#endif
}

static int CompareBook(const void *lpbk1, const void *lpbk2) {
  DWORD dw1, dw2;
  dw1 = ((BookItem *) lpbk1)->dwLock;
  dw2 = ((BookItem *) lpbk2)->dwLock;
  return dw1 > dw2 ? 1 : dw1 < dw2 ? -1 : 0;
}

// À—À˜ø™æ÷ø‚
static int SearchBook(void) {
  int i, vl, nBookMoves, mv;
  int mvs[MAX_GEN_MOVES], vls[MAX_GEN_MOVES];
  BOOL bMirror;
  BookItem bkToSearch, *lpbk;
  PositionStruct posMirror;
  // À—À˜ø™æ÷ø‚µƒπ˝≥Ã”–“‘œ¬º∏∏ˆ≤Ω÷Ë

  // 1. »Áπ˚√ª”–ø™æ÷ø‚£¨‘Ú¡¢º¥∑µªÿ
  if (Search.nBookSize == 0) {
    return 0;
  }
  // 2. À—À˜µ±«∞æ÷√Ê
  bMirror = FALSE;
  bkToSearch.dwLock = pos.zobr.dwLock1;
  lpbk = (BookItem *) bsearch(&bkToSearch, Search.BookTable, Search.nBookSize, sizeof(BookItem), CompareBook);
  // 3. »Áπ˚√ª”–’“µΩ£¨ƒ«√¥À—À˜µ±«∞æ÷√ÊµƒæµœÒæ÷√Ê
  if (lpbk == NULL) {
    bMirror = TRUE;
    pos.Mirror(posMirror);
    bkToSearch.dwLock = posMirror.zobr.dwLock1;
    lpbk = (BookItem *) bsearch(&bkToSearch, Search.BookTable, Search.nBookSize, sizeof(BookItem), CompareBook);
  }
  // 4. »Áπ˚æµœÒæ÷√Ê“≤√ª’“µΩ£¨‘Ú¡¢º¥∑µªÿ
  if (lpbk == NULL) {
    return 0;
  }
  // 5. »Áπ˚’“µΩ£¨‘ÚœÚ«∞≤Èµ⁄“ª∏ˆø™æ÷ø‚œÓ
  while (lpbk >= Search.BookTable && lpbk->dwLock == bkToSearch.dwLock) {
    lpbk --;
  }
  lpbk ++;
  // 6. ∞—◊ﬂ∑®∫Õ∑÷÷µ–¥»ÎµΩ"mvs"∫Õ"vls" ˝◊È÷–
  vl = nBookMoves = 0;
  while (lpbk < Search.BookTable + Search.nBookSize && lpbk->dwLock == bkToSearch.dwLock) {
    mv = (bMirror ? MIRROR_MOVE(lpbk->wmv) : lpbk->wmv);
    if (pos.LegalMove(mv)) {
      mvs[nBookMoves] = mv;
      vls[nBookMoves] = lpbk->wvl;
      vl += vls[nBookMoves];
      nBookMoves ++;
      if (nBookMoves == MAX_GEN_MOVES) {
        break; // ∑¿÷π"BOOK.DAT"÷–∫¨”–“Ï≥£ ˝æ›
      }
    }
    lpbk ++;
  }
  if (vl == 0) {
    return 0; // ∑¿÷π"BOOK.DAT"÷–∫¨”–“Ï≥£ ˝æ›
  }
  // 7. ∏˘æ›»®÷ÿÀÊª˙—°‘Ò“ª∏ˆ◊ﬂ∑®
  vl = rand() % vl;
  for (i = 0; i < nBookMoves; i ++) {
    vl -= vls[i];
    if (vl < 0) {
      break;
    }
  }
  return mvs[i];
}

// Ã·»°÷√ªª±ÌœÓ
static int ProbeHash(int vlAlpha, int vlBeta, int nDepth, int &mv) {
  BOOL bMate; // …±∆Â±Í÷æ£∫»Áπ˚ «…±∆Â£¨ƒ«√¥≤ª–Ë“™¬˙◊„…Ó∂»Ãıº˛
  HashItem hsh;

  hsh = Search.HashTable[pos.zobr.dwKey & (HASH_SIZE - 1)];
  if (hsh.dwLock0 != pos.zobr.dwLock0 || hsh.dwLock1 != pos.zobr.dwLock1) {
    mv = 0;
    return -MATE_VALUE;
  }
  mv = hsh.wmv;
  bMate = FALSE;
  if (hsh.svl > WIN_VALUE) {
    if (hsh.svl < BAN_VALUE) {
      return -MATE_VALUE; // ø…ƒ‹µº÷¬À—À˜µƒ≤ªŒ»∂®–‘£¨¡¢øÃÕÀ≥ˆ£¨µ´◊Óº—◊≈∑®ø…ƒ‹ƒ√µΩ
    }
    hsh.svl -= pos.nDistance;
    bMate = TRUE;
  } else if (hsh.svl < -WIN_VALUE) {
    if (hsh.svl > -BAN_VALUE) {
      return -MATE_VALUE; // Õ¨…œ
    }
    hsh.svl += pos.nDistance;
    bMate = TRUE;
  }
  if (hsh.ucDepth >= nDepth || bMate) {
    if (hsh.ucFlag == HASH_BETA) {
      return (hsh.svl >= vlBeta ? hsh.svl : -MATE_VALUE);
    } else if (hsh.ucFlag == HASH_ALPHA) {
      return (hsh.svl <= vlAlpha ? hsh.svl : -MATE_VALUE);
    }
    return hsh.svl;
  }
  return -MATE_VALUE;
};

// ±£¥Ê÷√ªª±ÌœÓ
static void RecordHash(int nFlag, int vl, int nDepth, int mv) {
  HashItem hsh;
  hsh = Search.HashTable[pos.zobr.dwKey & (HASH_SIZE - 1)];
  if (hsh.ucDepth > nDepth) {
    return;
  }
  hsh.ucFlag = nFlag;
  hsh.ucDepth = nDepth;
  if (vl > WIN_VALUE) {
    if (mv == 0 && vl <= BAN_VALUE) {
      return; // ø…ƒ‹µº÷¬À—À˜µƒ≤ªŒ»∂®–‘£¨≤¢«“√ª”–◊Óº—◊≈∑®£¨¡¢øÃÕÀ≥ˆ
    }
    hsh.svl = vl + pos.nDistance;
  } else if (vl < -WIN_VALUE) {
    if (mv == 0 && vl >= -BAN_VALUE) {
      return; // Õ¨…œ
    }
    hsh.svl = vl - pos.nDistance;
  } else {
    hsh.svl = vl;
  }
  hsh.wmv = mv;
  hsh.dwLock0 = pos.zobr.dwLock0;
  hsh.dwLock1 = pos.zobr.dwLock1;
  Search.HashTable[pos.zobr.dwKey & (HASH_SIZE - 1)] = hsh;
};

// MVV/LVA√ø÷÷◊”¡¶µƒº€÷µ
static BYTE cucMvvLva[24] = {
  0, 0, 0, 0, 0, 0, 0, 0,
  5, 1, 1, 3, 4, 3, 2, 0,
  5, 1, 1, 3, 4, 3, 2, 0
};

// «ÛMVV/LVA÷µ
inline int MvvLva(int mv) {
  return (cucMvvLva[pos.ucpcSquares[DST(mv)]] << 3) - cucMvvLva[pos.ucpcSquares[SRC(mv)]];
}

// "qsort"∞¥MVV/LVA÷µ≈≈–Úµƒ±»Ωœ∫Ø ˝
static int CompareMvvLva(const void *lpmv1, const void *lpmv2) {
  return MvvLva(*(int *) lpmv2) - MvvLva(*(int *) lpmv1);
}

// "qsort"∞¥¿˙ ∑±Ì≈≈–Úµƒ±»Ωœ∫Ø ˝
static int CompareHistory(const void *lpmv1, const void *lpmv2) {
  return Search.nHistoryTable[*(int *) lpmv2] - Search.nHistoryTable[*(int *) lpmv1];
}


// ◊ﬂ∑®≈≈–ÚΩ◊∂Œ
const int PHASE_HASH = 0;
const int PHASE_KILLER_1 = 1;
const int PHASE_KILLER_2 = 2;
const int PHASE_GEN_MOVES = 3;
const int PHASE_REST = 4;

// ◊ﬂ∑®≈≈–ÚΩ·ππ
struct SortStruct {
  int mvHash, mvKiller1, mvKiller2; // ÷√ªª±Ì◊ﬂ∑®∫Õ¡Ω∏ˆ…± ÷◊ﬂ∑®
  int nPhase, nIndex, nGenMoves;    // µ±«∞Ω◊∂Œ£¨µ±«∞≤…”√µ⁄º∏∏ˆ◊ﬂ∑®£¨◊‹π≤”–º∏∏ˆ◊ﬂ∑®
  int mvs[MAX_GEN_MOVES];           // À˘”–µƒ◊ﬂ∑®

  void Init(int mvHash_) { // ≥ı ºªØ£¨…Ë∂®÷√ªª±Ì◊ﬂ∑®∫Õ¡Ω∏ˆ…± ÷◊ﬂ∑®
    mvHash = mvHash_;
    mvKiller1 = Search.mvKillers[pos.nDistance][0];
    mvKiller2 = Search.mvKillers[pos.nDistance][1];
    nPhase = PHASE_HASH;
  }
  int Next(void); // µ√µΩœ¬“ª∏ˆ◊ﬂ∑®
};

// µ√µΩœ¬“ª∏ˆ◊ﬂ∑®
int SortStruct::Next(void) {
  int mv;
  switch (nPhase) {
  // "nPhase"±Ì æ◊≈∑®∆Ù∑¢µƒ»Ù∏…Ω◊∂Œ£¨“¿¥ŒŒ™£∫

  // 0. ÷√ªª±Ì◊≈∑®∆Ù∑¢£¨ÕÍ≥…∫Û¡¢º¥Ω¯»Îœ¬“ªΩ◊∂Œ£ª
  case PHASE_HASH:
    nPhase = PHASE_KILLER_1;
    if (mvHash != 0) {
      return mvHash;
    }
    // ºº«…£∫’‚¿Ô√ª”–"break"£¨±Ì æ"switch"µƒ…œ“ª∏ˆ"case"÷¥––ÕÍ∫ÛΩÙΩ”◊≈◊ˆœ¬“ª∏ˆ"case"£¨œ¬Õ¨

  // 1. …± ÷◊≈∑®∆Ù∑¢(µ⁄“ª∏ˆ…± ÷◊≈∑®)£¨ÕÍ≥…∫Û¡¢º¥Ω¯»Îœ¬“ªΩ◊∂Œ£ª
  case PHASE_KILLER_1:
    nPhase = PHASE_KILLER_2;
    if (mvKiller1 != mvHash && mvKiller1 != 0 && pos.LegalMove(mvKiller1)) {
      return mvKiller1;
    }

  // 2. …± ÷◊≈∑®∆Ù∑¢(µ⁄∂˛∏ˆ…± ÷◊≈∑®)£¨ÕÍ≥…∫Û¡¢º¥Ω¯»Îœ¬“ªΩ◊∂Œ£ª
  case PHASE_KILLER_2:
    nPhase = PHASE_GEN_MOVES;
    if (mvKiller2 != mvHash && mvKiller2 != 0 && pos.LegalMove(mvKiller2)) {
      return mvKiller2;
    }

  // 3. …˙≥…À˘”–◊≈∑®£¨ÕÍ≥…∫Û¡¢º¥Ω¯»Îœ¬“ªΩ◊∂Œ£ª
  case PHASE_GEN_MOVES:
    nPhase = PHASE_REST;
    nGenMoves = pos.GenerateMoves(mvs);
    qsort(mvs, nGenMoves, sizeof(int), CompareHistory);
    nIndex = 0;

  // 4. ∂‘ £”‡◊≈∑®◊ˆ¿˙ ∑±Ì∆Ù∑¢£ª
  case PHASE_REST:
    while (nIndex < nGenMoves) {
      mv = mvs[nIndex];
      nIndex ++;
      if (mv != mvHash && mv != mvKiller1 && mv != mvKiller2) {
        return mv;
      }
    }

  // 5. √ª”–◊≈∑®¡À£¨∑µªÿ¡„°£
  default:
    return 0;
  }
}

// ∂‘◊Óº—◊ﬂ∑®µƒ¥¶¿Ì
inline void SetBestMove(int mv, int nDepth) {
  int *lpmvKillers;
  Search.nHistoryTable[mv] += nDepth * nDepth;
  lpmvKillers = Search.mvKillers[pos.nDistance];
  if (lpmvKillers[0] != mv) {
    lpmvKillers[1] = lpmvKillers[0];
    lpmvKillers[0] = mv;
  }
}

// æ≤Ã¨(Quiescence)À—À˜π˝≥Ã
static int SearchQuiesc(int vlAlpha, int vlBeta) {
  int i, nGenMoves;
  int vl, vlBest;
  int mvs[MAX_GEN_MOVES];
  // “ª∏ˆæ≤Ã¨À—À˜∑÷Œ™“‘œ¬º∏∏ˆΩ◊∂Œ

  // 1. ºÏ≤È÷ÿ∏¥æ÷√Ê
  vl = pos.RepStatus();
  if (vl != 0) {
    return pos.RepValue(vl);
  }

  // 2. µΩ¥Ôº´œﬁ…Ó∂»æÕ∑µªÿæ÷√Ê∆¿º€
  if (pos.nDistance == LIMIT_DEPTH) {
    return pos.Evaluate();
  }

  // 3. ≥ı ºªØ◊Óº—÷µ
  vlBest = -MATE_VALUE; // ’‚—˘ø…“‘÷™µ¿£¨ «∑Ò“ª∏ˆ◊ﬂ∑®∂º√ª◊ﬂπ˝(…±∆Â)

  if (pos.InCheck()) {
    // 4. »Áπ˚±ªΩ´æ¸£¨‘Ú…˙≥…»´≤ø◊ﬂ∑®
    nGenMoves = pos.GenerateMoves(mvs);
    qsort(mvs, nGenMoves, sizeof(int), CompareHistory);
  } else {

    // 5. »Áπ˚≤ª±ªΩ´æ¸£¨œ»◊ˆæ÷√Ê∆¿º€
    vl = pos.Evaluate();
    if (vl > vlBest) {
      vlBest = vl;
      if (vl >= vlBeta) {
        return vl;
      }
      if (vl > vlAlpha) {
        vlAlpha = vl;
      }
    }

    // 6. »Áπ˚æ÷√Ê∆¿º€√ª”–Ωÿ∂œ£¨‘Ÿ…˙≥…≥‘◊”◊ﬂ∑®
    nGenMoves = pos.GenerateMoves(mvs, GEN_CAPTURE);
    qsort(mvs, nGenMoves, sizeof(int), CompareMvvLva);
  }

  // 7. ÷“ª◊ﬂ’‚–©◊ﬂ∑®£¨≤¢Ω¯––µ›πÈ
  for (i = 0; i < nGenMoves; i ++) {
    if (pos.MakeMove(mvs[i])) {
      vl = -SearchQuiesc(-vlBeta, -vlAlpha);
      pos.UndoMakeMove();

      // 8. Ω¯––Alpha-Beta¥Û–°≈–∂œ∫ÕΩÿ∂œ
      if (vl > vlBest) {    // ’“µΩ◊Óº—÷µ(µ´≤ªƒ‹»∑∂® «Alpha°¢PVªπ «Beta◊ﬂ∑®)
        vlBest = vl;        // "vlBest"æÕ «ƒø«∞“™∑µªÿµƒ◊Óº—÷µ£¨ø…ƒ‹≥¨≥ˆAlpha-Beta±ﬂΩÁ
        if (vl >= vlBeta) { // ’“µΩ“ª∏ˆBeta◊ﬂ∑®
          return vl;        // BetaΩÿ∂œ
        }
        if (vl > vlAlpha) { // ’“µΩ“ª∏ˆPV◊ﬂ∑®
          vlAlpha = vl;     // Àı–°Alpha-Beta±ﬂΩÁ
        }
      }
    }
  }

  // 9. À˘”–◊ﬂ∑®∂ºÀ—À˜ÕÍ¡À£¨∑µªÿ◊Óº—÷µ
  return vlBest == -MATE_VALUE ? pos.nDistance - MATE_VALUE : vlBest;
}

// "SearchFull"µƒ≤Œ ˝
const BOOL NO_NULL = TRUE;

// ≥¨≥ˆ±ﬂΩÁ(Fail-Soft)µƒAlpha-BetaÀ—À˜π˝≥Ã
static int SearchFull(int vlAlpha, int vlBeta, int nDepth, BOOL bNoNull = FALSE) {
  int nHashFlag, vl, vlBest;
  int mv, mvBest, mvHash, nNewDepth;
  SortStruct Sort;
  // “ª∏ˆAlpha-BetaÕÍ»´À—À˜∑÷Œ™“‘œ¬º∏∏ˆΩ◊∂Œ

  // 1. µΩ¥ÔÀÆ∆Ωœﬂ£¨‘Úµ˜”√æ≤Ã¨À—À˜(◊¢“‚£∫”…”⁄ø’≤Ω≤√ºÙ£¨…Ó∂»ø…ƒ‹–°”⁄¡„)
  if (nDepth <= 0) {
    return SearchQuiesc(vlAlpha, vlBeta);
  }

  // 1-1. ºÏ≤È÷ÿ∏¥æ÷√Ê(◊¢“‚£∫≤ª“™‘⁄∏˘Ω⁄µ„ºÏ≤È£¨∑Ò‘ÚæÕ√ª”–◊ﬂ∑®¡À)
  vl = pos.RepStatus();
  if (vl != 0) {
    return pos.RepValue(vl);
  }

  // 1-2. µΩ¥Ôº´œﬁ…Ó∂»æÕ∑µªÿæ÷√Ê∆¿º€
  if (pos.nDistance == LIMIT_DEPTH) {
    return pos.Evaluate();
  }

  // 1-3. ≥¢ ‘÷√ªª±Ì≤√ºÙ£¨≤¢µ√µΩ÷√ªª±Ì◊ﬂ∑®
  vl = ProbeHash(vlAlpha, vlBeta, nDepth, mvHash);
  if (vl > -MATE_VALUE) {
    return vl;
  }

  // 1-4. ≥¢ ‘ø’≤Ω≤√ºÙ(∏˘Ω⁄µ„µƒBeta÷µ «"MATE_VALUE"£¨À˘“‘≤ªø…ƒ‹∑¢…˙ø’≤Ω≤√ºÙ)
  if (!bNoNull && !pos.InCheck() && pos.NullOkay()) {
    pos.NullMove();
    vl = -SearchFull(-vlBeta, 1 - vlBeta, nDepth - NULL_DEPTH - 1, NO_NULL);
    pos.UndoNullMove();
    if (vl >= vlBeta) {
      return vl;
    }
  }

  // 2. ≥ı ºªØ◊Óº—÷µ∫Õ◊Óº—◊ﬂ∑®
  nHashFlag = HASH_ALPHA;
  vlBest = -MATE_VALUE; // ’‚—˘ø…“‘÷™µ¿£¨ «∑Ò“ª∏ˆ◊ﬂ∑®∂º√ª◊ﬂπ˝(…±∆Â)
  mvBest = 0;           // ’‚—˘ø…“‘÷™µ¿£¨ «∑ÒÀ—À˜µΩ¡ÀBeta◊ﬂ∑®ªÚPV◊ﬂ∑®£¨“‘±„±£¥ÊµΩ¿˙ ∑±Ì

  // 3. ≥ı ºªØ◊ﬂ∑®≈≈–ÚΩ·ππ
  Sort.Init(mvHash);

  // 4. ÷“ª◊ﬂ’‚–©◊ﬂ∑®£¨≤¢Ω¯––µ›πÈ
  while ((mv = Sort.Next()) != 0) {
    if (pos.MakeMove(mv)) {
      // Ω´æ¸—”…Ï
      nNewDepth = pos.InCheck() ? nDepth : nDepth - 1;
      // PVS
      if (vlBest == -MATE_VALUE) {
        vl = -SearchFull(-vlBeta, -vlAlpha, nNewDepth);
      } else {
        vl = -SearchFull(-vlAlpha - 1, -vlAlpha, nNewDepth);
        if (vl > vlAlpha && vl < vlBeta) {
          vl = -SearchFull(-vlBeta, -vlAlpha, nNewDepth);
        }
      }
      pos.UndoMakeMove();

      // 5. Ω¯––Alpha-Beta¥Û–°≈–∂œ∫ÕΩÿ∂œ
      if (vl > vlBest) {    // ’“µΩ◊Óº—÷µ(µ´≤ªƒ‹»∑∂® «Alpha°¢PVªπ «Beta◊ﬂ∑®)
        vlBest = vl;        // "vlBest"æÕ «ƒø«∞“™∑µªÿµƒ◊Óº—÷µ£¨ø…ƒ‹≥¨≥ˆAlpha-Beta±ﬂΩÁ
        if (vl >= vlBeta) { // ’“µΩ“ª∏ˆBeta◊ﬂ∑®
          nHashFlag = HASH_BETA;
          mvBest = mv;      // Beta◊ﬂ∑®“™±£¥ÊµΩ¿˙ ∑±Ì
          break;            // BetaΩÿ∂œ
        }
        if (vl > vlAlpha) { // ’“µΩ“ª∏ˆPV◊ﬂ∑®
          nHashFlag = HASH_PV;
          mvBest = mv;      // PV◊ﬂ∑®“™±£¥ÊµΩ¿˙ ∑±Ì
          vlAlpha = vl;     // Àı–°Alpha-Beta±ﬂΩÁ
        }
      }
    }
  }

  // 5. À˘”–◊ﬂ∑®∂ºÀ—À˜ÕÍ¡À£¨∞—◊Óº—◊ﬂ∑®(≤ªƒ‹ «Alpha◊ﬂ∑®)±£¥ÊµΩ¿˙ ∑±Ì£¨∑µªÿ◊Óº—÷µ
  if (vlBest == -MATE_VALUE) {
    // »Áπ˚ «…±∆Â£¨æÕ∏˘æ›…±∆Â≤Ω ˝∏¯≥ˆ∆¿º€
    return pos.nDistance - MATE_VALUE;
  }
  // º«¬ºµΩ÷√ªª±Ì
  RecordHash(nHashFlag, vlBest, nDepth, mvBest);
  if (mvBest != 0) {
    // »Áπ˚≤ª «Alpha◊ﬂ∑®£¨æÕΩ´◊Óº—◊ﬂ∑®±£¥ÊµΩ¿˙ ∑±Ì
    SetBestMove(mvBest, nDepth);
  }
  return vlBest;
}

// ∏˘Ω⁄µ„µƒAlpha-BetaÀ—À˜π˝≥Ã
static int SearchRoot(int nDepth) {
  int vl, vlBest, mv, nNewDepth;
  SortStruct Sort;

  vlBest = -MATE_VALUE;
  Sort.Init(Search.mvResult);
  while ((mv = Sort.Next()) != 0) {
    if (pos.MakeMove(mv)) {
      nNewDepth = pos.InCheck() ? nDepth : nDepth - 1;
      if (vlBest == -MATE_VALUE) {
        vl = -SearchFull(-MATE_VALUE, MATE_VALUE, nNewDepth, NO_NULL);
      } else {
        vl = -SearchFull(-vlBest - 1, -vlBest, nNewDepth);
        if (vl > vlBest) {
          vl = -SearchFull(-MATE_VALUE, -vlBest, nNewDepth, NO_NULL);
        }
      }
      pos.UndoMakeMove();
      if (vl > vlBest) {
        vlBest = vl;
        Search.mvResult = mv;
        if (vlBest > -WIN_VALUE && vlBest < WIN_VALUE) {
          vlBest += (rand() & RANDOM_MASK) - (rand() & RANDOM_MASK);
        }
      }
    }
  }
  RecordHash(HASH_PV, vlBest, nDepth, Search.mvResult);
  SetBestMove(Search.mvResult, nDepth);
  return vlBest;
}

// µ¸¥˙º”…ÓÀ—À˜π˝≥Ã
static void SearchMain(void) {
  int i, t, vl, nGenMoves;
  int mvs[MAX_GEN_MOVES];

  // ≥ı ºªØ
  memset(Search.nHistoryTable, 0, 65536 * sizeof(int));       // «Âø’¿˙ ∑±Ì
  memset(Search.mvKillers, 0, LIMIT_DEPTH * 2 * sizeof(int)); // «Âø’…± ÷◊ﬂ∑®±Ì
  memset(Search.HashTable, 0, HASH_SIZE * sizeof(HashItem));  // «Âø’÷√ªª±Ì
  t = (int)clock();       // ≥ı ºªØ∂® ±∆˜
  pos.nDistance = 0; // ≥ı º≤Ω ˝

  // À—À˜ø™æ÷ø‚
  Search.mvResult = SearchBook();
  if (Search.mvResult != 0) {
    pos.MakeMove(Search.mvResult);
    if (pos.RepStatus(3) == 0) {
      pos.UndoMakeMove();
      return;
    }
    pos.UndoMakeMove();
  }

  // ºÏ≤È «∑Ò÷ª”–Œ®“ª◊ﬂ∑®
  vl = 0;
  nGenMoves = pos.GenerateMoves(mvs);
  for (i = 0; i < nGenMoves; i ++) {
    if (pos.MakeMove(mvs[i])) {
      pos.UndoMakeMove();
      Search.mvResult = mvs[i];
      vl ++;
    }
  }
  if (vl == 1) {
    return;
  }

  // µ¸¥˙º”…Óπ˝≥Ã
  for (i = 1; i <= s_search_depth; i ++) {
    vl = SearchRoot(i);
    // À—À˜µΩ…±∆Â£¨æÕ÷’÷πÀ—À˜
    if (vl > WIN_VALUE || vl < -WIN_VALUE) {
      break;
    }
    // ≥¨π˝“ª√Î£¨æÕ÷’÷πÀ—À˜
    //if (clock() - t > CLOCKS_PER_SEC) {
    //float elapse = ((float) clock() - t) / CLOCKS_PER_SEC;
    //printf("%s: Search depth DONE = [%d]. elapse=[%.02f]\n", __FUNCTION__, i, elapse);
    if ( clock() - t > (CLOCKS_PER_SEC * s_search_time) ) {
      break;
    }
    //printf("%s: Search depth START = [%d].\n", __FUNCTION__, i+1);
  }
  //printf("%s: Search depth = *** [%d].\n", __FUNCTION__, i);
}

// ≥ı ºªØ∆Âæ÷
static void Startup(unsigned char board[10][9]) {
  pos.Startup(board);
  //Xqwl.sqSelected = Xqwl.mvLast = 0;
  //Xqwl.bGameOver = FALSE;
}

/////////////////////////////////////////////////////////////
////////////////// HPHAN Code addition //////////////////////

extern "C" void
XQWLight_init_engine( int searchDepth )
{
    if ( searchDepth < LIMIT_DEPTH )
    {
        s_search_depth = searchDepth;
    }
}

extern "C" void
XQWLight_init_game()
{
    //unsigned char board[10][9] = NULL;
    const char    side = 'w';

    // ----------
    srand((DWORD) time(NULL));
    InitZobrist();
    //Xqwl.hInst = hInstance;
    //Xqwl.bFlipped = FALSE;
    Startup(NULL /*board*/);

    if ( side == 'b' )
    {
        pos.ChangeSide();
    }
}

unsigned int
XQWLight_hox2xqwlight( int row1, int col1, int row2, int col2 )
{
	unsigned int sx = row1;
	unsigned int sy = col1;
	unsigned int dx = row2;
	unsigned int dy = col2;
	unsigned int src = (3+sx) + (3+sy) * 16;
	unsigned int dst = (3+dx) + (3+dy) * 16;
	return src | (dst << 8);
}

void
XQWLight_xqwlight2hox( unsigned int move,
                       int* pRow1, int* pCol1, int* pRow2, int* pCol2 )
{
	unsigned int src = move & 255;
	unsigned int dst = move >> 8;
	*pRow1 = (src % 16) - 3;
	*pCol1 = (src / 16) - 3;
	*pRow2 = (dst % 16) - 3;
	*pCol2 = (dst / 16) - 3;
}

extern "C" void
XQWLight_generate_move( int* pRow1, int* pCol1, int* pRow2, int* pCol2 )
{
    SearchMain();

    XQWLight_xqwlight2hox( Search.mvResult,
                           pRow1, pCol1, pRow2, pCol2 ); 
    pos.MakeMove( Search.mvResult );
}

extern "C" void
XQWLight_on_human_move( int row1, int col1, int row2, int col2 )
{
    unsigned int nMove = XQWLight_hox2xqwlight( row1, col1, row2, col2 );
    Search.mvResult = nMove;
    pos.MakeMove( Search.mvResult );
}

extern "C" void
XQWLight_set_search_time( int nSeconds )
{
    s_search_time = nSeconds;
}

extern "C" void
XQWLight_load_book( const char *bookfile )
{
    LoadBook(bookfile);
}

extern "C" int
XQWLight_generate_move_from( int sqSrc, int *mvs )
{
    BOOL bCapture = FALSE;
    return pos.GenerateMovesFrom( sqSrc, mvs, bCapture );
}

/////////////
extern "C" int
XQWLight_is_legal_move( int mv )
{
    int bLegal = 1; /* Default: legal */

    if ( ! pos.LegalMove( mv ) ) {
        return 0; /* illegal */
    }
    
    /* Make sure you are not in check after you make your move. */
    int pcCaptured = pos.MovePiece(mv);
    if ( pos.Checked() ) {
        bLegal = 0;
    }
    pos.UndoMovePiece(mv, pcCaptured);
    return bLegal;
}

extern "C" void
XQWLight_make_move( int mv, int* ppcCaptured )
{
    Search.mvResult = mv;  // TODO: Is this assignment necessary?
    pos.MakeMove( Search.mvResult, ppcCaptured );
}

extern "C" int
XQWLight_rep_status(int nRecur, int *repValue)
{
    int vl = pos.RepStatus(nRecur);
    if (vl != 0) {
        *repValue = pos.RepValue(vl);
    }
    return vl;
}

extern "C" int
XQWLight_is_mate()
{
    BOOL bMated = pos.IsMate();
    return (bMated ? 1 : 0);
}

extern "C" int
XQWLight_get_nMoveNum()
{
    return pos.nMoveNum;
}

extern "C" int
XQWLight_get_sdPlayer()
{
    return pos.sdPlayer;
}

/************************* END OF FILE ***************************************/
