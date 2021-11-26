#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <string>
#include "../inc/loader.h"

void print_hex_bytes(const uint8_t *bytes, size_t size) {
    int i, j, k;
    for (i = 0; i < size; i += 32) {
        printf("    0x%08x: ", i);
        for (j = 0; j < 32; j++) {
            if (j % 2 == 0 && j != 0) printf(" ");
            if (i+j < size)
                printf("%02x", bytes[i+j]);
        }
        printf("\n");
    }
}

void usage(char *argv[]) {
    printf("Usage: %s -b <binary> [-s <section_name>]\n", argv[0]);
    exit(1);
}

int main(int argc, char *argv[]) {
    size_t i;
    Binary bin;
    Section *sec;
    Symbol *sym;
    std::string fname, secname;

    int c, f;
    while ((c = getopt(argc, argv, "b:s:")) != -1) {
        switch (c) {
        case 'b':
            if (optarg) {
                fname.assign(optarg);
                f = 1;
            }
            break;
        case 's':
            if (optarg) secname.assign(optarg);
            break;
        case '?':
        default:
            usage(argv);
        }
    }
    if (!f) usage(argv);

    if (load_binary(fname, &bin, Binary::BIN_TYPE_AUTO) < 0) {
        return 1;
    }

    printf("loaded binary '%s' %s/%s (%u bits) entry@0x%016jx\n",
           bin.filename.c_str(),
           bin.type_str.c_str(), bin.arch_str.c_str(),
           bin.bits, bin.entry
    );

    for (i = 0; i < bin.sections.size(); i++) {
        sec = &bin.sections[i];
        printf("  0x%016jx %-8ju %-20s %s\n",
               sec->vma, sec->size, sec->name.c_str(),
               sec->type == Section::SEC_TYPE_CODE ? "CODE" : "DATA"
        );
        if (secname == sec->name)
            print_hex_bytes(sec->bytes, sec->size);
    }

    if (bin.symbols.size() > 0) {
        printf("scanned symbol tables\n");
        for (i = 0; i < bin.symbols.size(); i++) {
            sym = &bin.symbols[i];
            printf("  %-40s 0x%016jx %s\n",
                   sym->name.c_str(), sym->addr,
                   (sym->type & Symbol::SYM_TYPE_FUNC) ? "FUNC" :
                   ((sym->type & Symbol::SYM_TYPE_DATA) ? "DATA": "")
            );
        }
    }

    unload_binary(&bin);
    return 0;
}
