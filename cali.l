%{
#include <stdlib.h>
#include "cali.tab.h"
#include "cali.h"

#define DAYHANDLER(n) yylval.intval = n; \
last = 1; \
return(TOK_DAYOFWEEK) 

#define MONTHHANDLER(n) yylval.intval = n; \
if (last == 1) { \
    last = 2; \
    return(TOK_MONTHAFTERDAY); \
} else { \
    last = 2; \
    return(TOK_MONTH); \
}

int last = 0;
%}

%%

every                   return(TOK_EVERY);
other                   return(TOK_OTHER);

mon(day)?               { DAYHANDLER(1); }
tue(sday|s)?            { DAYHANDLER(2); }
wed(nesday)?            { DAYHANDLER(3); }
thu(rsday)?             { DAYHANDLER(4); }
fri(day)?               { DAYHANDLER(5); }
sat(urday)?             { DAYHANDLER(6); }
sun(day)?               { DAYHANDLER(7); }

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
tomorrow                yylval.intval = 9; return(TOK_TOMORROW);

from                    last = 0; return(TOK_FROM);
to                      last = 0; return(TOK_TO);
at                      last = 0; return(TOK_AT);
dur                     last = 0; return(TOK_DUR);
starting                last = 0; return(TOK_START);
ending                  last = 0; return(TOK_END);

pm                      return(TOK_PM);
am                      return(TOK_AM);
[0-9]?[0-9]             yylval.intval = atoi(yytext); return(TOK_2INT);
[0-9]?[0-9]:[0-9][0-9]  return(TOK_HOURMIN);

hours                   return(TOK_HOURS);
h                       return(TOK_HOURS);
minutes                 return(TOK_MINS);
m                       return(TOK_MINS);

\n                      /* ignore end of line */;
[ \t]+                  

%%
