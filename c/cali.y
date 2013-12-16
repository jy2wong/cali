%{
#include <stdio.h>
#include <stdlib.h>
#include "cali.h"
#include "remind.h"

datetime tmp;
event_t *stuff;

void yyerror(const char *str) {
    fprintf(stderr,"error: %s\n",str);
}

int yywrap() {
    return 1;
}

int main() {
    stuff = malloc(sizeof(event_t));
    clear_event(stuff);

    yyparse();
    print_event(stuff);
    print_remind(stuff);
    free(stuff);
    return 0;
}
%}

%union {
    int intval;
    char charval;
}

%token TOK_EVERY TOK_OTHER TOK_NEXT
%token TOK_FROM TOK_TO TOK_AT TOK_DUR TOK_START TOK_END
%token TOK_REMIND TOK_BY TOK_EMAIL TOK_ALARM
%token TOK_NOON TOK_MIDNIGHT
%token TOK_AM TOK_PM
%token TOK_NEVER

%token <intval> TOK_DAYOFWEEK
%token <intval> TOK_CDAYOFWEEK
%token <intval>TOK_TODAY 
%token <intval> TOK_TOMORROW

%token <intval> TOK_MONTH
%token <intval> TOK_MONTHAFTERDAY
%token <intval> TOK_2INT 
%token <intval> TOK_4INT 
%token <intval> TOK_REAL

%token <intval> TOK_HOURS 
%token <intval> TOK_MINS 
%token <intval> TOK_HOURMIN
%token <intval> TOK_DAYS

%type <intval> hour
%type <intval> month_number
%type <intval> day_number
%type <intval> year_number

%%
event   : 
        | event info 
        ;

info: TOK_EVERY TOK_DAYOFWEEK {
        stuff->repeating = 1;
        stuff->multi_days++;
        stuff->active_days[$2]++; 
    } 
    | TOK_EVERY TOK_OTHER TOK_DAYOFWEEK {
        stuff->repeating = 2;
        stuff->active_days[$3]++;
    } 
    | dates TOK_CDAYOFWEEK {
        stuff->active_days[$2]++;
    } 
    | TOK_FROM clock_time {
        stuff->from++;
        copy_datetime(&stuff->FROM, &tmp);
        clear_datetime(&tmp);
    }
    | TOK_TO clock_time {
        stuff->to++;
        copy_datetime(&stuff->TO, &tmp);
        clear_datetime(&tmp);
    }
    | TOK_AT clock_time {
        stuff->at++;
        copy_datetime(&stuff->AT, &tmp);
        clear_datetime(&tmp);
    }
    | TOK_DUR length {
        stuff->dur++;
    }
    | TOK_REMIND reminders
    | TOK_START date {
        stuff->start++;
        copy_datetime(&stuff->START, &tmp);
        clear_datetime(&tmp);
    }
    | TOK_END TOK_NEVER /* don't need to do anything */
    | TOK_END date {
        stuff->end++;
        copy_datetime(&stuff->END, &tmp);
        clear_datetime(&tmp);
    }
    | date {
        stuff->started_with_date++;
        copy_datetime(&stuff->FROM, &tmp);
        clear_datetime(&tmp);
    }
    ;

day : TOK_TODAY {
        tmp.dayofweek = $1;
    }
    | TOK_TOMORROW {
        tmp.dayofweek = $1;
    }
    | TOK_NEXT TOK_DAYOFWEEK {
        tmp.next = 1;
        tmp.dayofweek = $2;
    }
    | TOK_DAYOFWEEK {
        tmp.dayofweek = $1;
    }
    ;

dates   : 
        | dates TOK_CDAYOFWEEK {
            stuff->active_days[$2]++; 
        }
        ;

date: TOK_MONTH day_number year_number {
        tmp.month = $1;
        tmp.daynum = $2;
        tmp.year = $3;
    }
    | TOK_MONTH day_number {
        tmp.month = $1;
        tmp.daynum = $2;
    }
    | month_number '/' day_number '/' year_number {
        tmp.month = $1;
        tmp.daynum = $3;
        tmp.year = $5;
    }
    | TOK_DAYOFWEEK TOK_MONTHAFTERDAY day_number year_number {
        tmp.dayofweek = $1;
        tmp.month = $2;
        tmp.daynum = $3;
        tmp.year = $4;
    }
    | TOK_DAYOFWEEK TOK_MONTHAFTERDAY day_number {
        tmp.dayofweek = $1;
        tmp.month = $2;
        tmp.daynum = $3;
    }
    | day
    ;

clock_time  : TOK_HOURMIN TOK_AM {
                tmp.hours = DECODEHOUR($1);
                tmp.minutes = DECODEMIN($1);
            }
            | TOK_HOURMIN TOK_PM {
                tmp.hours = DECODEHOUR($1) + 12;
                tmp.minutes = DECODEMIN($1);
            }
            | TOK_HOURMIN {
                tmp.hours = DECODEHOUR($1);
                tmp.minutes = DECODEMIN($1);
            }
            | hour TOK_AM {
                tmp.hours = $1;
            }
            | hour TOK_PM {
                tmp.hours = $1 + 12;
            }
            | hour {
                tmp.hours = $1;
            }
            | TOK_NOON {
                tmp.hours = 12;
            }
            | TOK_MIDNIGHT {
                tmp.hours = 0;
            }
            ;

length  : length_unit
        | length length_unit
        ;

length_unit : TOK_DAYS {
                stuff->dur_days = $1;
            }
            | TOK_HOURMIN
            | TOK_MINS {
                stuff->DUR.minutes = $1;
            }
            | TOK_HOURS {
                stuff->DUR.hours = $1;
            }
            ;

reminders   : reminders ',' reminder
            | reminder
            ;

reminder: length TOK_BY mechanism
        ;

mechanism   : TOK_EMAIL
            | TOK_ALARM
            ;

hour: TOK_2INT
    | TOK_REAL
    ;

month_number: TOK_2INT
            ;

day_number  : TOK_2INT
            ;

year_number : TOK_4INT
            ;
%%

void clear_datetime(datetime *dt) {
    dt->next = 0;
    
    dt->dayofweek = 0;
    dt->month = 0;
    dt->daynum = 0;
    dt->year = 0;
    dt->hours = 0;
    dt->minutes = 0;
}

void print_datetime(datetime *dt) {
    if (dt->next) printf("Next, ");

    if (dt->dayofweek) printf("weekday %d, ", dt->dayofweek);
    if (dt->month) printf("month %d, ", dt->month);
    if (dt->daynum) printf("daynum %d, ", dt->daynum);
    if (dt->year) printf("year %d, ", dt->year);
    if (dt->hours) printf("hours %d, ", dt->hours);
    if (dt->minutes) printf("minutes %d, ", dt->minutes);
    printf("\n");
}

void print_time(datetime *dt) {
    if (dt->hours) printf("hours %d, ", dt->hours);
    if (dt->minutes) printf("minutes %d, ", dt->minutes);
    printf("\n");
}

void print_date(datetime *dt) {
    if (dt->next) printf("Next, ");

    if (dt->dayofweek) printf("weekday %d, ", dt->dayofweek);
    if (dt->month) printf("month %d, ", dt->month);
    if (dt->daynum) printf("daynum %d, ", dt->daynum);
    if (dt->year) printf("year %d, ", dt->year);
    printf("\n");
}

void print_event(event_t *stuff) {
    if (stuff->repeating) {
        printf("Repeating");
        if (stuff->repeating == 2) printf(" every other");
        printf(": [");

        for (int i=0; i<7; i++) {
            if (stuff->active_days[i]) {
                printf("%d,", i);
            }
        }
        printf("]\n");
    }

    if (stuff->multi_days) printf("Multi-day event\n");

    if (stuff->started_with_date) {
        printf("DATE: ");
        print_date(&(stuff->FROM));
    }
    if (stuff->from) {
        printf("FROM: ");
        print_time(&(stuff->FROM));
    } 
    if (stuff->to) {
        printf("TO: ");
        print_time(&(stuff->TO));
    }
    if (stuff->at) {
        printf("AT: ");
        print_time(&(stuff->AT));
    } else {
        printf("(all day)\n");
    }
    if (stuff->dur) {
        printf("DUR: ");
        print_time(&(stuff->DUR));
    }
    if (stuff->start) {
        printf("START: ");
        print_date(&(stuff->START));
    }
    if (stuff->end) {
        printf("END: ");
        print_date(&(stuff->END));
    }
}
    
void clear_event(event_t *stuff) {
    stuff->repeating = 0;
    stuff->multi_days = 0;
    for (int i=0; i<7; i++) {
        stuff->active_days[i] = 0;
    }

    for (int i=0; i<3; i++) {
        clear_datetime(&(stuff->dates[i]));
    }

    stuff->started_with_date = 0;
    stuff->from = 0;
    stuff->to = 0;
    stuff->at = 0;
    stuff->dur = 0;
    stuff->dur_days = 0;
    stuff->start = 0;
    stuff->end = 0;
}

void copy_datetime(datetime *dest, datetime *src) {
    dest->next |= src->next;
    
    dest->dayofweek |= src->dayofweek;
    dest->month |= src->month;
    dest->daynum |= src->daynum;
    dest->year |= src->year;
    dest->hours |= src->hours;
    dest->minutes |= src->minutes;
}

