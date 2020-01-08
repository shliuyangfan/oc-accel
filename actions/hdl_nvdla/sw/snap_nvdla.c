/*
 * Copyright 2019 International Business Machines
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <malloc.h>
#include <unistd.h>
#include <sys/time.h>
#include <getopt.h>
#include <ctype.h>

#include <libosnap.h>
#include <osnap_tools.h>
//#include <osnap_action_regs.h>

#include "snap_nvdla.h"

/*  defaults */
#define MEGAB       (1024*1024ull)
#define GIGAB       (1024 * MEGAB)
#define DDR_MEM_SIZE    (4 * GIGAB)     /* 4 GB (DDR RAM) */
#define DDR_MEM_BASE_ADDR   0x00000000  /* Start of FPGA Interconnect */
#define ACTION_WAIT_TIME	1	/* Default in sec */

#define VERBOSE0(fmt, ...) do {         \
        printf(fmt, ## __VA_ARGS__);    \
    } while (0)

#define VERBOSE1(fmt, ...) do {         \
        if (verbose_level > 0)          \
            printf(fmt, ## __VA_ARGS__);    \
    } while (0)

#define VERBOSE2(fmt, ...) do {         \
        if (verbose_level > 1)          \
            printf(fmt, ## __VA_ARGS__);    \
    } while (0)


#define VERBOSE3(fmt, ...) do {         \
        if (verbose_level > 2)          \
            printf(fmt, ## __VA_ARGS__);    \
    } while (0)

#define VERBOSE4(fmt, ...) do {         \
        if (verbose_level > 3)          \
            printf(fmt, ## __VA_ARGS__);    \
    } while (0)

static const char* version = GIT_VERSION;
static  int verbose_level = 0;

//static uint64_t get_usec (void)
//{
//    struct timeval t;
//
//    gettimeofday (&t, NULL);
//    return t.tv_sec * 1000000 + t.tv_usec;
//}
//
//static void print_time (uint64_t elapsed, uint64_t size)
//{
//    int t;
//    float fsize = (float)size / (1024 * 1024);
//    float ft;
//
//    if (elapsed > 10000) {
//        t = (int)elapsed / 1000;
//        ft = (1000 / (float)t) * fsize;
//        VERBOSE1 (" end after %d msec (%0.3f MB/sec)\n" , t, ft);
//    } else {
//        t = (int)elapsed;
//        ft = (1000000 / (float)t) * fsize;
//        VERBOSE1 (" end after %d usec (%0.3f MB/sec)\n", t, ft);
//    }
//}
//
//static void* alloc_mem (int align, int size)
//{
//    void* a;
//    int size2 = size + align;
//
//    VERBOSE2 ("%s Enter Align: %d Size: %d (malloc Size: %d)\n",
//              __func__, align, size, size2);
//
//    if (posix_memalign ((void**)&a, 4096, size2) != 0) {
//        perror ("FAILED: posix_memalign()");
//        return NULL;
//    }
//
//    VERBOSE2 ("%s Exit %p\n", __func__, a);
//    return a;
//}
//
//static void free_mem (void* a)
//{
//    VERBOSE2 ("Free Mem %p\n", a);
//
//    if (a) {
//        free (a);
//    }
//}
//
//static void memset2 (void* a, uint64_t pattern, int size)
//{
//    int i;
//    uint64_t* a64 = a;
//
//    for (i = 0; i < size; i += 8) {
//        *a64 = (pattern & 0xffffffff) | (~pattern << 32ull);
//        a64++;
//        pattern += 8;
//    }
//}
//
/* Action or Kernel Write and Read are 32 bit MMIO */
static int action_write (struct snap_card* h, uint32_t addr, uint32_t data)
{
    int rc;

    rc = snap_action_write32 (h, (uint64_t)addr, data);

    if (0 != rc) {
        VERBOSE0 ("Write MMIO 32 Err\n");
    }

    return rc;
}

///*  Calculate msec to FPGA ticks.
// *  we run at 250 Mhz on FPGA so 4 ns per tick
// */
//static uint32_t msec_2_ticks (int msec)
//{
//    uint32_t fpga_ticks = msec;
//
//    fpga_ticks = fpga_ticks * 250;
//#ifndef _SIM_
//    fpga_ticks = fpga_ticks * 1000;
//#endif
//    VERBOSE1 (" fpga Ticks = %d (0x%x)", fpga_ticks, fpga_ticks);
//    return fpga_ticks;
//}
//
///*
// * Return 0 if buffer is equal,
// * Return index+1 if not equal
// */
//static int memcmp2 (uint8_t* src, uint8_t* dest, int len)
//{
//    int i;
//
//    for (i = 0; i < len; i++) {
//        if (*src != *dest) {
//            return i + 1;
//        }
//
//        src++;
//        dest++;
//    }
//
//    return 0;
//}

static void usage (const char* prog)
{
    VERBOSE0 ("SNAP NVDLA demo.\n"
              "    %s --loadable <loadable> --image <image> --rawdump\n",
              prog);
    VERBOSE0 ("Usage: %s\n"
              "    -h, --help           print usage information\n"
              "    -v, --verbose        verbose mode\n"
              "    -C, --card <cardno>  use this card for operation\n"
              "    -V, --version\n"
              "    -q, --quiet          quiece output\n"
              "    -t, --timeout        Timeout after N sec (default 1 sec)\n"
              "    -I, --irq            Enable Action Done Interrupt (default No Interrupts)\n"
              "    --loadable <loadable> input loadable file\n"
              "    --image <file>        input jpg/pgm file\n"
              "    --normalize <value>   normalize value for input image\n"
              "    --rawdump             dump raw dimg data\n"
              , prog);
}

int main (int argc, char* argv[])
{
    char device[64];
    struct snap_card* dn;   /* lib snap handle */
    int card_no = 0;
    int cmd;
    int rc = 1;
    //uint64_t cir;
    uint32_t irq_control;
    uint32_t action_control;
    //uint32_t config;
    int timeout = ACTION_WAIT_TIME;
    snap_action_flag_t attach_flags = 0;
    unsigned long ioctl_data;
    unsigned long dma_align;
    unsigned long dma_min_size;
    struct snap_action *act = NULL;
    char card_name[16];   /* Space for Card name */
    char default_loadable[] = "./basic.nvdla";
    char default_image   [] = "./something.pgm";
    char default_input   [] = "./";
    char* loadable= NULL;
    char* image   = NULL;
    char* input   = NULL;
    int normalize = 0;
    int rawdump = 0;
    float mean[4] = {0.0, 0.0, 0.0, 0.0};
    char *mean_token;
    int i = 0;
    int eng_id = 0;

    //char loadable1[] = "../sw/nvdla-sw/regression/flatbufs/kmd/CDP/CDP_L0_0_large_fbuf";
    //char loadable2[] = "../sw/nvdla-sw/regression/flatbufs/kmd/SDP/SDP_X1_L0_0_large_fbuf";
    //char loadable3[] = "../sw/nvdla-sw/regression/flatbufs/kmd/PDP/PDP_L0_0_large_fbuf";
    //char loadable4[] = "../sw/nvdla-sw/regression/flatbufs/kmd/CONV/CONV_D_L0_0_large_fbuf";
    //char loadable5[] = "../sw/nvdla-sw/regression/flatbufs/kmd/NN/NN_L0_1_large_fbuf";
    //char loadable6[] = "../sw/nvdla-sw/regression/flatbufs/kmd/NN/NN_L0_1_large_random_fbuf";

    while (1) {
        int option_index = 0;
        static struct option long_options[] = {
            { "card",     required_argument, NULL, 'C' },
            { "verbose",  no_argument,       NULL, 'v' },
            { "help",     no_argument,       NULL, 'h' },
            { "version",  no_argument,       NULL, 'V' },
            { "quiet",    no_argument,       NULL, 'q' },
            { "loadable", required_argument, NULL, 'l' },
            { "image",    required_argument, NULL, 'm' },
            { "input",    required_argument, NULL, 'i' },
            { "rawdump",  no_argument,       NULL, 'r' },
            { "normalize",required_argument, NULL, 'n' },
            { "mean",     required_argument, NULL, 'M' },
            { "timeout",  required_argument, NULL, 't' },
            { "irq",      no_argument,       NULL, 'I' },
            { 0,          no_argument,       NULL, 0   },
        };
        cmd = getopt_long (argc, argv, "C:l:m:i:r:n:M:t:IqvVh",
                           long_options, &option_index);

        if (cmd == -1) { /* all params processed ? */
            break;
        }

        switch (cmd) {
        case 'v':   /* verbose */
            verbose_level++;
            break;

        case 'V':   /* version */
            VERBOSE0 ("%s\n", version);
            exit (EXIT_SUCCESS);;

        case 'h':   /* help */
            usage (argv[0]);
            exit (EXIT_SUCCESS);;

        case 'C':   /* card */
            card_no = strtol (optarg, (char**)NULL, 0);
            break;

        case 'l':
            loadable = optarg;
            break;

        case 'i':
            input = optarg;
            break;

        case 'm':
            image = optarg;
            break;

        case 'n':
            normalize = strtol (optarg, (char**)NULL, 0);
            break;

        case 'r':
            rawdump = 1;
            break;

        case 'M':
            mean_token = strtok(optarg, ",\n");
            while( mean_token != NULL ) {
                if (i > 3) {
                    VERBOSE0 ("ERROR: Number of mean values should not be greater than 4 \n");
                    usage (argv[0]);
                    exit (EXIT_FAILURE);
                }
                mean[i] = atof(mean_token);
                mean_token = strtok(NULL, ",\n");
                i++;
            }

            break;

        case 't':
            timeout = strtol (optarg, (char**)NULL, 0); /* in sec */
            break;

        case 'I':      /* irq */
            attach_flags = SNAP_ACTION_DONE_IRQ | SNAP_ATTACH_IRQ;
            break;

        default:
            usage (argv[0]);
            exit (EXIT_FAILURE);
        }
    }

    if (loadable == NULL) {
        loadable = (char*) default_loadable;
    }

    if (input == NULL) {
        input = (char*) default_input;
    }

    if (image == NULL) {
        image = (char*) default_image;
    }

    if (card_no > 4) {
        usage (argv[0]);
        exit (1);
    }

    VERBOSE0 ("Open Card: %d\n", card_no);

    if (card_no == 0) {
        snprintf (device, sizeof (device) - 1, "IBM,oc-snap");
    } else {
        snprintf (device, sizeof (device) - 1, "/dev/ocxl/IBM,oc-snap.000%d:00:00.1.0", card_no);
    }

    VERBOSE0 ("Allocate Device\n");

    dn = snap_card_alloc_dev (device, SNAP_VENDOR_ID_IBM, SNAP_DEVICE_ID_SNAP);

    if (NULL == dn) {
        errno = ENODEV;
        VERBOSE0 ("ERROR: snap_card_alloc_dev(%s)\n", device);
        return -1;
    }

    //// Disable the NVDLA register region
    //rc = action_write(dn, ACTION_CONFIG, 0x00000000);

    //if (rc) {
    //    VERBOSE0 ("ERROR: action_write ERROR\n");
    //    errno = ENODEV;
    //    perror ("ERROR");
    //    return -1;
    //} 

    /* Read Card Name */
    rc = snap_card_ioctl (dn, GET_CARD_NAME, (unsigned long)&card_name);
    VERBOSE1 ("SNAP on %s", card_name);

    if (rc) {
        VERBOSE0 ("ERROR: snap_card_ioctl ERROR\n");
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    }

    rc = snap_card_ioctl (dn, GET_SDRAM_SIZE, (unsigned long)&ioctl_data);
    VERBOSE1 (" Card, %d MB of Card Ram avilable. ", (int)ioctl_data);

    if (rc) {
        VERBOSE0 ("ERROR: snap_card_ioctl ERROR\n");
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    }

    rc = snap_card_ioctl (dn, GET_DMA_ALIGN, (unsigned long)&dma_align);
    VERBOSE1 (" (Align: %d ", (int)dma_align);

    if (rc) {
        VERBOSE0 ("ERROR: snap_card_ioctl ERROR\n");
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    }

    rc = snap_card_ioctl (dn, GET_DMA_MIN_SIZE, (unsigned long)&dma_min_size);
    VERBOSE1 (" Min DMA: %d Bytes)\n", (int)dma_min_size);

    if (rc) {
        VERBOSE0 ("ERROR: snap_card_ioctl ERROR\n");
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    }

    //rc = snap_mmio_read64 (dn, SNAP_S_CIR, &cir);
    //VERBOSE1 ("Start NVDLA in Card Handle: %p Context: %d\n", dn,
    //          (int) (cir & 0x1ff));

    if (rc) {
        VERBOSE0 ("ERROR: snap_mmio_read64 ERROR\n");
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    }

    act = snap_attach_action(dn, ACTION_TYPE_NVDLA,
            attach_flags, 5 * timeout);

    if (NULL == act) {
        VERBOSE0 ("ERROR: snap_attach_action ERROR\n");
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    }

    //// Disable the NVDLA register region
    //rc = action_write(dn, ACTION_CONFIG, 0x00000000);
    //VERBOSE0 ("Asserting soft reset\n");
    //// Assert soft reset
    //rc |= action_write(dn, ACTION_CONFIG, 0x00000200);
    //rc |= snap_action_read32 (dn, ACTION_CONFIG, &config);
    //VERBOSE0 ("Config register: %#x\n", config);
    //// Clear soft reset
    //rc |= action_write(dn, ACTION_CONFIG, 0x00000000);
    //rc |= snap_action_read32 (dn, ACTION_CONFIG, &config);
    //VERBOSE0 ("Config register: %#x\n", config);

    if (rc) {
        VERBOSE0 ("ERROR: action_write/read ERROR\n");
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    } 

    //VERBOSE1 ("Turn on the NVDLA register region\n");
    //// Enable the NVDLA register region
    //rc = action_write(dn, ACTION_CONFIG, 0x00000100);

    //if (rc) {
    //    VERBOSE0 ("ERROR: action_write ERROR\n");
    //    errno = ENODEV;
    //    perror ("ERROR");
    //    return -1;
    //}

    VERBOSE1 ("Start to run NVDLA\n");
    rc = nvdla_probe(dn, eng_id);

    if (rc) {
        VERBOSE0 ("ERROR: nvdla_probe ERROR\n");
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    }

    // Allocate interrupt handler
    rc = snap_action_assign_irq (dn, ACTION_INT_HANDLER_HI);

    if (rc) {
        VERBOSE0 ("ERROR: allocate interrupt handler ERROR\n");
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    }
    
    VERBOSE0 ("NVDLA loadable:  %s\n", loadable);
    VERBOSE0 ("NVDLA input:     %s\n", input);
    VERBOSE0 ("NVDLA image:     %s\n", image);
    VERBOSE0 ("NVDLA normalize: %d\n", normalize);
    VERBOSE0 ("NVDLA rawdump:   %d\n", rawdump);

    for (i = 0; i < 4; i++) {
        VERBOSE0 ("NVDLA mean[%d]:   %f\n", i, mean[i]);
    }

    rc = nvdla_capi_test(loadable, input, image, normalize, rawdump, mean);
    VERBOSE1 ("Stop to run NVDLA\n");

    if (rc) {
        VERBOSE0 ("ERROR: nvdla_capi_test ERROR\n");
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    }

    VERBOSE1 ("Turn off the NVDLA register region\n");
    //// Disable the NVDLA register region and indicate action done
    //rc = action_write(dn, ACTION_CONFIG, 0x00000400);

    //if (rc) {
    //    VERBOSE0 ("ERROR: action_write ERROR\n");
    //    errno = ENODEV;
    //    perror ("ERROR");
    //    return -1;
    //} 

    rc = snap_action_read32 (dn, ACTION_IRQ_CONTROL, &irq_control);
    VERBOSE1 ("irq_control: %#x\n", irq_control);
    rc |= snap_action_read32 (dn, ACTION_CONTROL, &action_control);
    VERBOSE1 ("action_control: %#x\n", action_control);

    if (rc) {
        VERBOSE0 ("ERROR: snap_action_read32 ERROR\n");
        errno = ENODEV;
        perror ("ERROR");
        return -1;
    }

    // Unmap AFU MMIO registers, if previously mapped
    VERBOSE2 ("Free Card Handle: %p\n", dn);
    snap_card_free (dn);

    VERBOSE1 ("End of Test rc: %d\n", rc);
    return rc;
}
