#ifndef CALI_H
#define CALI_H

typedef enum Month { 
    JAN, FEB, MAR, APR, MAY, JUN, 
    JUL, AUG, SEP, OCT, NOV, DEC 
} Month;

typedef enum weekday { 
    MON = 1, TUE, WED, THU, FRI, SAT, SUN, TODAY, TOMORROW 
} weekday;

typedef struct datetime {
    int next;

    weekday dayofweek;
    Month month;
    int daynum;
    int year;
    int hours;
    int minutes;
} datetime;

#define DECODEHOUR(n) ((n) >> 5)
#define DECODEMIN(n) (n % (1 << 5))
#define ENCODEHOUR(n) ((n) << 5)

typedef struct event_t {
    int repeating; // every
    int multi_days;
    int active_days[7];

    datetime dates[3];
    #define FROM    dates[0]
    #define TO      dates[1]
    #define AT      dates[0]
    #define DUR     dates[1]
    #define START   dates[0]
    #define END     dates[1]

    int from, to;
    int at, dur, dur_days;
    int start, end;
    int started_with_date;
} event_t;

int yyparse();
int yylex();

void clear_datetime(datetime *dt);
void print_datetime(datetime *dt);
void print_time(datetime *dt);
void print_date(datetime *dt);
void print_event(event_t *stuff);
void clear_event(event_t *stuff);
void copy_datetime(datetime *dest, datetime *src);

#endif
