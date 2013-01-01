%{
#include <stdlib.h>
#include "cali.tab.h"
#include "cali.h"

#define DAYHANDLER(n, token) yylval.intval = n; \
last = 1; \
return(token)

#define MONTHHANDLER(n) yylval.intval = n; \
if (last == 1) { \
    last = 2; \
    return(TOK_MONTHAFTERDAY); \
} else { \
    last = 2; \
    return(TOK_MONTH); \
}

#define EXTRACTFIRST(token) last = 0; \
                        for (pos = 0; yytext[pos] >= '0' && yytext[pos] <= '9'; pos++); \
                        yytext[pos] = '\0'; \
                        yylval.intval = atoi(yytext); \
                        return(token)

int last = 0;
int pos;
%}

%%

every                   return(TOK_EVERY);
other                   return(TOK_OTHER);

,[ \t]*mon(day)?               { DAYHANDLER(1, TOK_CDAYOFWEEK); }
,[ \t]*tue(sday|s)?            { DAYHANDLER(2, TOK_CDAYOFWEEK); }
,[ \t]*wed(nesday)?            { DAYHANDLER(3, TOK_CDAYOFWEEK); }
,[ \t]*thu(rsday)?             { DAYHANDLER(4, TOK_CDAYOFWEEK); }
,[ \t]*fri(day)?               { DAYHANDLER(5, TOK_CDAYOFWEEK); }
,[ \t]*sat(urday)?             { DAYHANDLER(6, TOK_CDAYOFWEEK); }
,[ \t]*sun(day)?               { DAYHANDLER(7, TOK_CDAYOFWEEK); }

mon(day)?               { DAYHANDLER(1, TOK_DAYOFWEEK); }
tue(sday|s)?            { DAYHANDLER(2, TOK_DAYOFWEEK); }
wed(nesday)?            { DAYHANDLER(3, TOK_DAYOFWEEK); }
thu(rsday)?             { DAYHANDLER(4, TOK_DAYOFWEEK); }
fri(day)?               { DAYHANDLER(5, TOK_DAYOFWEEK); }
sat(urday)?             { DAYHANDLER(6, TOK_DAYOFWEEK); }
sun(day)?               { DAYHANDLER(7, TOK_DAYOFWEEK); }

jan(uary)?              { MONTHHANDLER(1) }
feb(ruary)?             { MONTHHANDLER(2) }
mar(ch)?                yylval.intval = 3; last = 2; return(TOK_MONTH);
apr(il)?                yylval.intval = 4; last = 2; return(TOK_MONTH);
may                     yylval.intval = 5; last = 2; return(TOK_MONTH);
jun(e)?                 yylval.intval = 6; last = 2; return(TOK_MONTH);
jul(y)?                 yylval.intval = 7; last = 2; return(TOK_MONTH);
aug(ust)?               yylval.intval = 8; last = 2; return(TOK_MONTH);
sep(t|tember)?          yylval.intval = 9; last = 2; return(TOK_MONTH);
oct(ober)?              yylval.intval = 10; last = 2; return(TOK_MONTH);
nov(ember)?             yylval.intval = 11; last = 2; return(TOK_MONTH);
dec(ember)?             yylval.intval = 12; last = 2; return(TOK_MONTH);

noon                    return(TOK_NOON);
midnight                return(TOK_MIDNIGHT);

today                   yylval.intval = 8; return(TOK_TODAY);
tomorrow                printf("tomorrow\n"); yylval.intval = 9; return(TOK_TOMORROW);

from                    last = 0; return(TOK_FROM);
to                      printf("to\n"); last = 0; return(TOK_TO);
at                      printf("at\n"); last = 0; return(TOK_AT);
dur                     last = 0; return(TOK_DUR);
starting                last = 0; return(TOK_START);
ending                  last = 0; return(TOK_END);

[0-9]+[ \t]*m(inute|inutes)   { EXTRACTFIRST(TOK_MINS); }

[0-9]+[ \t]*h(our|ours)   { EXTRACTFIRST(TOK_HOURS); }

[0-9]+[ \t]*d(ay|ays)   { EXTRACTFIRST(TOK_DAYS); }
                            
                        
pm                      return(TOK_PM);
am                      return(TOK_AM);
[0-9]?[0-9]             yylval.intval = atoi(yytext); return(TOK_2INT);
[0-9]?[0-9]:[0-9][0-9]  {
                            for (pos=0; yytext[pos] != ':'; pos++);
                            yytext[pos] = '\0';
                            yylval.intval = atoi(yytext);
                            yylval.intval |= atoi(yytext+pos+1);
                            return(TOK_HOURMIN);
                        }

[0-9]{4}                yylval.intval = atoi(yytext); return(TOK_4INT);

\n                      /* ignore end of line */;
[ \t]+                  /* ignore white space */;

%%
/*
*/
