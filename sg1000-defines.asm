# SG-1000 Defines
# ---
# Contains definitions for Sega SG-1000 hardware, including the
# Soggy clone

# The bottom of work-RAM on all models of SG-1000
# (Move this into $8000 if you are building a cartridge with RAM)
#define SG1000_RAM_BOTTOM $c000

# The top of RAM on an original SG-1000 (1k)
#define SEGA_RAM_TOP $c400

# The top of RAM on an original Soggy-1000 (16k, pages 0 and 1 in series)
#define SOGGY_RAM_TOP $ffff

# The paging control register for the Soggy SG-1000 clone
#define SOGGY_PAGING_REGISTER $10
