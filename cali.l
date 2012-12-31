%{
#include "cali.tab.h"
%}

%%

mon(day)?               yylval.intval = 1; return(TOK_DAYOFWEEK);
tue(sday|s)?            yylval.intval = 1; return(TOK_DAYOFWEEK);
wed(nesday)?            yylval.intval = 1; return(TOK_DAYOFWEEK);
thu(rsday)?             yylval.intval = 1; return(TOK_DAYOFWEEK);
fri(day)?               yylval.intval = 1; return(TOK_DAYOFWEEK);
sat(urday)?             yylval.intval = 1; return(TOK_DAYOFWEEK);
sun(day)?               yylval.intval = 1; return(TOK_DAYOFWEEK);

jan(uary)?              yylval.intval = 1; return(TOK_MONTH);
feb(ruary)?             yylval.intval = 1; return(TOK_MONTH);
mar(ch)?                yylval.intval = 1; return(TOK_MONTH);
apr(il)?                yylval.intval = 1; return(TOK_MONTH);
may                     yylval.intval = 1; return(TOK_MONTH);
jun(e)?                 yylval.intval = 1; return(TOK_MONTH);
jul(y)?                 yylval.intval = 1; return(TOK_MONTH);
aug(ust)?               yylval.intval = 1; return(TOK_MONTH);
sep(t|tember)?          yylval.intval = 1; return(TOK_MONTH);
oct(ober)?              yylval.intval = 1; return(TOK_MONTH);
nov(ember)?             yylval.intval = 1; return(TOK_MONTH);
dec(ember)?             yylval.intval = 1; return(TOK_MONTH);

noon                    return(TOK_NOON);
midnight                return(TOK_MIDNIGHT);

today                   return(TOK_TODAY);
tomorrow                return(TOK_TOMORROW);

from                    return(TOK_FROM);
to                      return(TOK_TO);
at                      return(TOK_AT);
dur                     return(TOK_DUR);
starting                return(TOK_START);
ending                  return(TOK_END);

pm                      return(TOK_PM);
am                      return(TOK_AM);
[0-9]?[0-9]             return(TOK_2INT);
[0-9]?[0-9]:[0-9][0-9]  return(TOK_HOURMIN);

\n                      /* ignore end of line */;
[ \t]+                  /* ignore whitespace */;

%%
