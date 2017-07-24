# contrib/jsonb_plpython/Makefile

MODULE_big = jsonb_plpython$(python_majorversion)u
OBJS = jsonb_plpython.o $(WIN32RES)
PGFILEDESC = "jsonb_plpython - transform between jsonb and plpythonu"

PG_CPPFLAGS = -I$(top_srcdir)/src/pl/plpython $(python_includespec) -DPLPYTHON_LIBNAME='"plpython$(python_majorversion)"'

EXTENSION = jsonb_plpython$(python_majorversion)u
DATA = jsonb_plpython$(python_majorversion)u--1.0.sql

REGRESS = jsonb_plpython$(python_majorversion)
REGRESS_PLPYTHON3_MANGLE := $(REGRESS)

ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/jsonb_plpython
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif

# We must link libpython explicitly
ifeq ($(PORTNAME), win32)
# ... see silliness in plpython Makefile ...
SHLIB_LINK += $(sort $(wildcard ../../src/pl/plpython/libpython*.a))
else
rpathdir = $(python_libdir)
SHLIB_LINK += $(python_libspec) $(python_additional_libs)
endif

ifeq ($(python_majorversion),2)
REGRESS_OPTS += --load-extension=plpython2u
else
REGRESS_OPTS += --load-extension=plpython3u
endif
