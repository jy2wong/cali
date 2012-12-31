%{
#include <stdio.h>


/*
cali saturday at 5pm: do dishes
cali tomorrow from 5pm to 7pm: meeting
cali tomorrow at 5pm duration 2 hours: meeting
cali every (other tuesday),wednesday,thursday from 3 to 5 starting november 3 ending never remindme 3 days by email, 15 minutes by alarm: go bowling

split up using : as a delimiter.
*/

typedef enum month { 
    JAN, FEB, MAR, APR, MAY, JUN, 
    JUL, AUG, SEP, OCT, NOV, DEC 
} month;

typedef enum weekday { SUN, MON, TUE, WED, THU, FRI, SAT } weekday;

typedef struct datetime {
    int next;
    int all_day_event;

    int month;
    int daynum;
    int year;
    int hours;
    int minutes;
} datetime;

typedef struct event_t {
    int repeating; // every
    int active_days[7];

    #define FROM    dates[0]
    #define TO      dates[1]
    #define AT      dates[0]
    #define DUR     dates[1]
    #define START   dates[0]
    #define END     dates[1]
    datetime dates[3];

    int from, to;
    int at, dur, dur_days;
    int start, end;
} event_t;

void yyerror(const char *str) {
    fprintf(stderr,"error: %s\n",str);
}

int yywrap() {
    return 1;
}

int main() {
    yyparse();
    return 0;
}
/*
%parse-param    { event_t *param }
*/
%}

%union YYSTYPE {
    int intval;
    char charval;
}

%token TOK_FROM TOK_TO 
%token TOK_AT TOK_DUR 
%token TOK_START TOK_END
%token TOK_REMIND TOK_BY TOK_EMAIL TOK_ALARM
%token TOK_TODAY TOK_TOMORROW
%token TOK_NOON TOK_MIDNIGHT
%token TOK_HOURMIN
%token TOK_HOURS TOK_MINS TOK_DAYS
%token TOK_AM TOK_PM
%token TOK_NEVER
%token TOK_EVERY TOK_OTHER TOK_NEXT

%token <intval> TOK_DAYOFWEEK
%token <intval> TOK_MONTH
%token <intval> TOK_INT 
%token <intval> TOK_2INT 
%token <intval> TOK_4INT 
%token <intval> TOK_REAL

%%
event:  
     | event info
     ;

info: TOK_EVERY simple_days
    | TOK_EVERY TOK_OTHER simple_days
    | dates
    | TOK_FROM date
    | TOK_TO date
    | TOK_AT clock_time
    | TOK_DUR length
    | TOK_REMIND reminders
    | TOK_START date
    | TOK_END TOK_NEVER
    | TOK_END date
    ;

day: TOK_TODAY
   | TOK_TOMORROW
   | TOK_NEXT TOK_DAYOFWEEK
   | TOK_DAYOFWEEK
   ;

simple_days: simple_days ',' TOK_DAYOFWEEK
           | TOK_DAYOFWEEK
           ;

dates: dates ',' date
     | date
     ;

date: TOK_MONTH day_number year_number
    | TOK_MONTH day_number
    | TOK_MONTH
    | month_number '/' day_number '/' year_number
    | TOK_DAYOFWEEK TOK_MONTH day_number year_number
    | TOK_DAYOFWEEK TOK_MONTH day_number
    | day
    ;

clock_time: TOK_HOURMIN TOK_AM
          | TOK_HOURMIN TOK_PM
          | TOK_HOURMIN
          | hour TOK_AM
          | hour TOK_PM
          | hour
          | TOK_NOON
          | TOK_MIDNIGHT
          ;

length:
      | length length_unit
      ;

length_unit: TOK_INT TOK_DAYS
           | TOK_HOURMIN
           | minute TOK_MINS
           | hour TOK_HOURS
           ;

reminders: reminders ',' reminder
         | reminder
         ;

reminder: length TOK_BY mechanism
        ;

mechanism: TOK_EMAIL
         | TOK_ALARM
         ;

hour: TOK_REAL
    | TOK_2INT
    ;

minute: TOK_2INT
      ;

month_number: TOK_2INT
            ;

day_number: TOK_2INT
          ;

year_number: TOK_4INT
           ;
