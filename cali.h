#ifndef CALI_H
#define CALI_H

typedef enum Month { 
    JAN, FEB, MAR, APR, MAY, JUN, 
    JUL, AUG, SEP, OCT, NOV, DEC 
} Month;

typedef enum weekday { SUN, MON, TUE, WED, THU, FRI, SAT, TODAY, TOMORROW } weekday;

typedef struct datetime {
    int next;
    int other;
    int all_day_event;

    weekday dayofweek;
    Month month;
    int daynum;
    int year;
    int hours;
    int minutes;
} datetime;

typedef struct event_t {
    int repeating; // every
    int multi_days;
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

int yyparse();
int yylex();

#endif
