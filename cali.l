%{
#include <stdlib.h>
#include "cali.tab.h"
#include "cali.h"
%}

%%

every                   return(TOK_EVERY);
other                   return(TOK_OTHER);

mon(day)?               yylval.intval = 1; return(TOK_DAYOFWEEK);
tue(sday|s)?            yylval.intval = 2; return(TOK_DAYOFWEEK);
wed(nesday)?            yylval.intval = 3; return(TOK_DAYOFWEEK);
thu(rsday)?             yylval.intval = 4; return(TOK_DAYOFWEEK);
fri(day)?               yylval.intval = 5; return(TOK_DAYOFWEEK);
sat(urday)?             yylval.intval = 6; return(TOK_DAYOFWEEK);
sun(day)?               yylval.intval = 7; return(TOK_DAYOFWEEK);

jan(uary)?              yylval.intval = 1; return(TOK_MONTH);
feb(ruary)?             yylval.intval = 2; return(TOK_MONTH);
mar(ch)?                yylval.intval = 3; return(TOK_MONTH);
apr(il)?                yylval.intval = 4; return(TOK_MONTH);
may                     yylval.intval = 5; return(TOK_MONTH);
jun(e)?                 yylval.intval = 6; return(TOK_MONTH);
jul(y)?                 yylval.intval = 7; return(TOK_MONTH);
aug(ust)?               yylval.intval = 8; return(TOK_MONTH);
sep(t|tember)?          yylval.intval = 9; return(TOK_MONTH);
oct(ober)?              yylval.intval = 10; return(TOK_MONTH);
nov(ember)?             yylval.intval = 11; return(TOK_MONTH);
dec(ember)?             yylval.intval = 12; return(TOK_MONTH);

noon                    return(TOK_NOON);
midnight                return(TOK_MIDNIGHT);

today                   yylval.intval = 8; return(TOK_TODAY);
tomorrow                yylval.intval = 9; return(TOK_TOMORROW);

from                    return(TOK_FROM);
to                      return(TOK_TO);
at                      return(TOK_AT);
dur                     return(TOK_DUR);
starting                return(TOK_START);
ending                  return(TOK_END);

pm                      return(TOK_PM);
am                      return(TOK_AM);
[0-9]?[0-9]             yylval.intval = atoi(yytext); return(TOK_2INT);
[0-9]?[0-9]:[0-9][0-9]  return(TOK_HOURMIN);

hours                   return(TOK_HOURS);
h                       return(TOK_HOURS);
minutes                 return(TOK_MINS);
m                       return(TOK_MINS);

\n                      /* ignore end of line */;
[ \t]+                  /* ignore whitespace */;

%%
