#include "cali.h"
#include <stdio.h>

void print_remind(event_t *event) {
    printf("rem ");
    if (event->repeating) {
        for (int i=0; i<7; i++) {
            if (event->active_days[i]) {
                switch(i) {
                    case MON: printf("mon "); break;
                    case TUE: printf("tue "); break;
                    case WED: printf("wed "); break;
                    case THU: printf("thu "); break;
                    case FRI: printf("fri "); break;
                    case SAT: printf("sat "); break;
                    case SUN: printf("sun "); break;
                }
            }
        }
    } else {
        printf("only ");
    }

}
