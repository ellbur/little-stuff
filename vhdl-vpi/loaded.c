
#include <stdio.h>
#include <vpi_user.h>

void thing_register(void) {
    printf("In the VPI Thing\n");
    
    vpiHandle handle = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle iter = vpi_iterate(vpiModule, handle);
    printf("Listing:\n");
    for (vpiHandle mem; mem = vpi_scan(iter); ) {
        printf("    %s\n", vpi_get_str(vpiName, mem));
    }
    
    //vpiHandle x = vpi_handle_by_name("x", handle);
    //printf("x = %d\n", (int) x);
}

void (*vlog_startup_routines[])() = {
      thing_register,
      0
};


